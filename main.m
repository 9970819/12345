clc;
clear;
close all;

% Load data
data = xlsread('0.xlsx', 1, 'A:F');
position = data(:, 2:3);
demand = data(:, 4);
ET = data(:, 5);
LT = data(:, 6);

% Initialize parameters
BatteryCapacity = 150;
BatteryDist = 120;
CarDistance = 30000000;
FlightNum = 25;
ChargeNum = 1;
NP = 200;
maxgen = 500;
Pcmax = 0.8;
Pcmin = 0.6;
Gap = 0.9;
speed = 25 / 3.6;
fitmax = 10000000;
c0 = 50;
c1 = 0.005;
c2 = 0.2;

ST = [0; ones(FlightNum, 1) * 10; ones(ChargeNum, 1) * 36];
CE = 0.1;
CL = 0.5;

% Parameters for adaptive mutation
Pmmin = 0.009;
Pmmax = 0.2;
alpha = 0.1;

% Calculate distance matrix
distance = zeros(FlightNum + 1 + ChargeNum);
for i = 1 : FlightNum + ChargeNum + 1
    for j = i + 1 : FlightNum + ChargeNum + 1
        distance(i, j) = sqrt((position(i, 1) - position(j, 1))^2 + (position(i, 2) - position(j, 2))^2);
        distance(j, i) = distance(i, j);
    end
end

runtime = 1;
for run = 1:runtime
    % Initialize paths
    X = initpop(NP, FlightNum, demand, BatteryCapacity);
    Xa = X(1, :);

    % Iteration
    gen = 1;
    while gen <= maxgen
        fprintf('Generation %d\n', gen);

        % Calculate fitness
        [allcost, fit] = fitness(distance, demand, X, BatteryDist, BatteryCapacity, ET, LT, ST, CE, CL, speed, fitmax, FlightNum, ChargeNum, c0, c1, c2);

        % Find the best individual
        [leastcost, bestindex] = min(allcost);
        bestindex = bestindex(1);
        fpbest(gen) = leastcost;
        pbest(gen, :) = X(bestindex, :);

        % Calculate average and maximum fitness of the population
        favg = mean(fit);
        fmax = max(fit);

        % Selection
        XSel = Select(X, fit, Gap);

        % Adaptive crossover operation
        for i = 1:size(XSel, 1)
            if mod(i, 2) == 0
                fa = fit(i - 1);
                fb = fit(i);
                XSel([i - 1, i], :) = Cross(XSel([i - 1, i], :), fa, fb, fmax, favg, Pcmax, Pcmin);
            end
        end

        % Adaptive mutation
        XSel = Mutate(XSel, fit, Pmmin, Pmmax, favg, fmax);

        % Reversal operation
        if gen > maxgen / 2
            XSel = Reverse(distance, demand, XSel, BatteryDist, BatteryCapacity, ET, LT, ST, CE, CL, speed, fitmax, FlightNum, ChargeNum, c0, c1, c2, fit, Pmmin, Pmmax, favg, fmax);
        end

        % Update population
        X = Reins(X, XSel, fit);
        gen = gen + 1;
    end

    % Record the best results
    [minfpbest, minindex] = min(fpbest);
    minindex = minindex(1);
    gbest = pbest(minindex, :);
    XR(run, :) = gbest;
    PR(run, 1) = minfpbest;
    GR(run, :) = fpbest;
end

[fgbest, id] = min(PR);
gbest = XR(id(1), :);
fpbest = GR(id(1), :);

% Display and plotting
disp('Optimal driving route:');
route = OutputPath(distance, demand, gbest, BatteryDist, BatteryCapacity, ET, LT, ST, CE, CL, speed, fitmax, FlightNum, ChargeNum, c0, c1, c2);
disp(['Optimal route cost: ', num2str(fgbest)]);
figure(1);
plot(fpbest);
title('Genetic Algorithm Optimization Process');
xlabel('Generation Number');
ylabel('Optimal Value');