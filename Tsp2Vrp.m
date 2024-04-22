function routeVrp = Tsp2Vrp(route, demand, BatteryCapacity)
% Convert a TSP (Traveling Salesman Problem) route into a VRP (Vehicle Routing Problem) route.
% The distribution center is represented as 0.

FlightNum = length(route); % Total number of cities in the route
route = [0, route, 0]; % Start and end at the depot (garage)
routeVrp = zeros(1, FlightNum * 2 + 1); % Initialize VRP route with maximum possible stops
delivery = 0; % Initialize delivered goods weight
k = 1; % Start from the first position in the VRP route

for i = 2:FlightNum + 1
    if delivery + demand(route(i) + 1) <= BatteryCapacity % Check if adding this city's demand exceeds the vehicle's capacity
        delivery = delivery + demand(route(i) + 1); % Add this city's demand to current load
        k = k + 1; % Move to the next position in VRP route
        routeVrp(k) = route(i); % Assign city to VRP route
    else % If capacity is exceeded, return to the depot
        delivery = 0; % Reset delivery load
        k = k + 1; % Move to next position in VRP route
        routeVrp(k) = 0; % Route back to the depot
        % Proceed to the next city
        delivery = demand(route(i) + 1); % Load demand from next city
        k = k + 1; % Move to next position in VRP route
        routeVrp(k) = route(i); % Assign next city to VRP route
    end
end

routeVrp = routeVrp + 1; % Adjust indices to MATLAB 1-based indexing

% Clean up any consecutive zeros to ensure proper formatting of the route
for i = 1:length(routeVrp) - 1
    if routeVrp(i) - routeVrp(i + 1) == 0
        routeVrp(i) = 0; % Eliminate redundant zeros
    end
end

ii = find(routeVrp == 0); % Find indices of zeros
routeVrp(ii) = []; % Remove zeros from route for a clean VRP path

