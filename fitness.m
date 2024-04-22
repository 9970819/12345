function [allcost, fit] = fitness(distance, demand, chrom, BatteryDist, BatteryCapacity, ET, LT, ST, CE, CL, speed, fitmax, FlightNum, ChargeNum, c0, c1, c2)
    %% Genetic Algorithm for solving the VRP with Time Windows (VRPTW)
    NP = size(chrom, 1); % Number of individuals in the population
    
    for i = 1:NP
        restdist = BatteryDist; % Remaining battery range
        powerconsumption = 0;   % Total power consumed by the vehicle
        driveDistance = 0;      % Total distance driven by the vehicle
        delivery = 0;           % Total delivery load, sum of demand at reached points
        nowTime = ET(1);        % Current time
        sumPunish = 0;          % Total penalty cost for the entire path
        cost = 0;               % Total cost for the entire path
        route = chrom(i, :);

        % Remove consecutive duplicate nodes
        for j = 1:length(route) - 1
            if route(j) - route(j + 1) == 0
                route(j) = 0;
            end
        end
        ii = find(route == 0);
        route(ii) = [];

        % Convert VRP path to include charging stations
        route = Vrp2ChargeVrp(route, distance, BatteryDist, FlightNum, demand);
        nCharge = 0; % Number of charging stops

        for j = 2:length(route)
            powerconsumption = powerconsumption + 0.00165 * distance(route(j-1), route(j)) + 0.000715 * speed^2 + demand(route(j));
            driveDistance = driveDistance + distance(route(j-1), route(j)) + 50;
            delivery = delivery + demand(route(j));
            restdist = restdist - 0.00165 * distance(route(j-1), route(j)) - 0.000715 * speed^2 - demand(route(j));

            [nowTime, punish] = timepunish(ET, LT, CE, CL, route, distance(route(j-1), route(j)), j, speed, nowTime);
            nowTime = nowTime + ST(route(j)); % Add service time at node j
            sumPunish = sumPunish + punish;

            if delivery > BatteryCapacity || restdist < 0
                cost = fitmax;
                break;
            end

            if ismember(route(j), 1 + FlightNum + 1 : 1 + FlightNum + ChargeNum) % Charging station passed
                restdist = 0.75 * BatteryDist;
                nCharge = nCharge + 1;
            end

            if route(j) == 1 % Return to the depot
                cost0 = c1 * driveDistance;
                cost = cost + c0 + cost0 + powerconsumption * c2 + sumPunish;
                driveDistance = 0;
                powerconsumption = 0;
                restdist = BatteryDist;
                nCharge = 0;
                delivery = 0;
                nowTime = ET(1);
                sumPunish = 0;
            end
        end

        % Count the number of vehicles used
        kCar = 0;
        for jj = 1:size(route, 2) - 1
            if route(jj) == 1 && route(jj) - route(jj + 1) ~= 0
                kCar = kCar + 1;
            end
        end

        punish = 0; % Reset or adjust penalty calculation as necessary
        allcost(i) = cost + punish; % Store total cost
        fit(i) = 1 / allcost(i)^3; % Calculate fitness, penalizing higher costs more severely
    end
end


