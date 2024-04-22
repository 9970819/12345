function chrom = Mutate(chrom, fitness, Pmmin, Pmmax, avg_fitness, max_fitness)
% Adaptive mutation function that dynamically adjusts mutation probability based on individual fitness
[px, py] = size(chrom);

for i = 1:px
    Pm = calculateMutationProbability(fitness(i), avg_fitness, max_fitness, Pmmin, Pmmax); % Calculate mutation probability for each individual
    if rand <= Pm
        positions = randperm(py-2) + 1; % Generate a random permutation from 2 to py-1
        pos1 = positions(1);
        pos2 = positions(2);
        temp = chrom(i, pos1); % Swap two gene positions
        chrom(i, pos1) = chrom(i, pos2);
        chrom(i, pos2) = temp;
    end
end

end

function Pm = calculateMutationProbability(fitness, avg_fitness, max_fitness, Pmmin, Pmmax)
% Adjusts mutation probability based on individual fitness relative to average and maximum fitness
if fitness > avg_fitness
    Pm = Pmmax - (Pmmax - Pmmin) * (max_fitness - fitness) / (max_fitness - avg_fitness);
else
    Pm = Pmmax;
end
Pm = min(Pmmax, max(Pmmin, Pm)); % Ensure mutation probability is within specified range
end