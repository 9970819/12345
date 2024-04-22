function route = OutputPath(distance, demand, route, BatteryDist, BatteryCapacity, ET, LT, ST, CE, CL, speed, fitmax, FlightNum, ChargeNum, c0, c1, c2)
    %% Route Output Function
    % Inputs:
    % R - Path
    % Outputs:
    % route - Modified path after evolutionary processes

    % Remove duplicate consecutive nodes
    for j = 1:length(route) - 1
        if route(j) - route(j + 1) == 0
            route(j) = 0;
        end
    end
    ii = find(route == 0);
    route(ii) = [];

    % Convert VRP path to a path with charging stations included
    route = Vrp2ChargeVrp(route, distance, BatteryDist, FlightNum, demand);
    
    %% Display Route
    Path = num2str(route(1) - 1);
    for i = 2 : length(route)
        Path = [Path, '¡ª>', num2str(route(i) - 1)];
    end
    disp(Path);

    %%
    % Initialize variables for tracking route performance
    restdist = BatteryDist;           % Remaining battery range
    powerconsumption = 0;             % Total power consumed
    drivedist = 0;                    % Total distance driven
    delivery = 0;                     % Total delivery load handled
    nowTime = ET(1);                  % Current time
    sumPunish = 0;                    % Total penalty cost accumulated
    sumlatePunish = 0;
    cost = 0;                         % Total cost of the route
    mPath = '0';
    mTime = num2str(ET(1));
    kCar = 1;
    nCharge = 0;                      % Number of charging stops made

    for j = 2:length(route)
        % Calculate power consumption and distances driven
        powerconsumption = powerconsumption + 0.00165 * distance(route(j-1), route(j)) + 0.000715 * speed^2 + demand(route(j));
        drivedist = drivedist + distance(route(j-1), route(j)) + 50;
        delivery = delivery + demand(route(j));
        restdist = restdist - 0.00165 * distance(route(j-1), route(j)) - 0.000715 * speed^2 - demand(route(j));
        
        % Update time and penalties at each node
        [nowTime, punish, latePunish] = timepunish(ET, LT, CE, CL, route, distance(route(j-1), route(j)), j, speed, nowTime);
        nowTime = nowTime + ST(route(j)); % Add service time at node j
        sumPunish = sumPunish + punish;
        sumlatePunish = sumlatePunish + latePunish;
        mPath = [mPath, '¡ª>', num2str(route(j) - 1)];
        mTime = [mTime, '¡ª', num2str(nowTime)];
        
        % Check for over-capacity or battery depletion
        if delivery > BatteryCapacity || restdist < 0
            cost = fitmax;
            break;
        end

        % If a charging station is passed
        if ismember(route(j), 1 + FlightNum + 1 : 1 + FlightNum + ChargeNum)
            restdist = 0.75 * BatteryDist;
            nCharge = nCharge + 1;
        end

        % If the vehicle returns to the depot
        if route(j) == 1
            cost0 = c1 * drivedist;
            cost = cost + c0 + cost0 + powerconsumption * c2 + sumPunish;
            fprintf('Vehicle %d: Power consumption %.3f, Number of charges %d, Distance driven %f, Route taken %s;\n', kCar, powerconsumption, nCharge, drivedist, mPath);
            fprintf('Time of arrival at each customer node %s\n', mTime);
            fprintf('Fixed vehicle cost %.3f, Variable cost %.3f, Charging cost %.3f, Penalty cost %.3f, Delay cost %.3f, Total cost of the route %.3f;\n', c0, cost0, powerconsumption * c2, sumPunish, sumlatePunish, cost);
            kCar = kCar + 1;
            powerconsumption = 0;
            drivedist = 0;
            restdist = BatteryDist;
            nCharge = 0;
            delivery = 0;
            nowTime = ET(1);
            sumPunish = 0;
            sumlatePunish = 0;
            mTime = num2str(ET(1));
            mPath = '0';
        end
    end

    allcost = cost;
    fit = 1 / allcost;
    route = route - 1;  % Adjust route indexing for output
end