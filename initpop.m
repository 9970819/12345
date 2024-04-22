function chrom = initpop(NP, FlightNum, demand, BatteryCapcity)
chrom= ones (NP, FlightNum * 2 + 1);
for i = 1 : NP
    x = randperm(FlightNum);
    route = Tsp2Vrp (x, demand, BatteryCapcity);
    chrom(i,1:length(route)) = route;
end