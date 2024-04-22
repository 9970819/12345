function R = Vrp2ChargeVrp(route, distance, BatteryDist, FlightNum, demand)
% Convert a standard VRP route to a route that includes stops at charging stations.

% Initialize variables
speed = 25 / 3.6; % Convert speed from km/h to m/s
restdist = BatteryDist; % Initialize remaining battery distance
R = route(1); % Start route with the first node
last = route(1); % Track the last visited node

% Iterate over each node in the route
for j = 2:length(route)
    % Calculate distance and energy consumption between the last and current node
    dnow = distance(route(j-1), route(j)); 
    cnow = 0.00165 * dnow + 0.000715 * speed^2; 

    % Find nearest charging station to the current node
    [dcharge, id] = min(distance(route(j), FlightNum+2:end)); 
    ccharge = 0.00165 * dcharge + 0.000715 * speed^2;

    % Check if there is enough remaining battery to proceed without charging
    if restdist < (cnow + demand(route(j)) + ccharge)
        % If not, find nearest charging station to the last node and update the route
        [dcharge, id] = min(distance(route(j-1), FlightNum+2:end)); 
        charge = FlightNum + 1 + id;
        R = [R, charge];
        last = charge;
        restdist = 0.75 * BatteryDist; % Recharge to 75% capacity
    end

    % Add current node to route and update remaining battery distance
    R = [R, route(j)];
    restdist = restdist - (0.00165 * distance(last, route(j)) + 0.000715 * speed^2 + demand(route(j)));

    % Reset battery distance when returning to depot
    if route(j) == 1
        restdist = BatteryDist;
    end

    last = route(j); % Update last node
end