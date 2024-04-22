function XSel = Reverse(distance, demand, XSel, BatteryDist, BatteryCapcity, ET, LT, ST, CE, CL, speed, fitmax, FlightNum, ChargeNum, c0, c1, c2, fit, Pmmin, Pmmax, favg, fmax)

    % Calculate the current cost of the selected individuals
    [allcost, ~] = fitness(distance, demand, XSel, BatteryDist, BatteryCapcity, ET, LT, ST, CE, CL, speed, fitmax, FlightNum, ChargeNum, c0, c1, c2);
    
    % Mutate the individuals using adapted mutation function
    XSel2 = Mutate(XSel, fit, Pmmin, Pmmax, favg, fmax);

    % Calculate the new cost after mutation
    [allcostNew, ~] = fitness(distance, demand, XSel2, BatteryDist, BatteryCapcity, ET, LT, ST, CE, CL, speed, fitmax, FlightNum, ChargeNum, c0, c1, c2);
    
    % Replace the original individuals with the mutated ones if the new cost is lower
    index = allcostNew < allcost;
    XSel(index, :) = XSel2(index, :);
end