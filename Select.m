function XSel = Select(X, fit, Gap)
    % Selection operation
    % Input:
    % X    - Population
    % fit  - Fitness values
    % Gap  - Selection probability
    % Output:
    % XSel - Selected individuals
    
    NP = size(X, 1); % Number of individuals in the population

    Px = fit / sum(fit); % Normalize probabilities
    Px = cumsum(Px);     % Cumulative sum for roulette wheel probabilities

    XSel(1:NP*Gap, :) = X(1:NP*Gap, :); % Select individuals based on the generation gap probability for crossover and mutation
    % Preserve the original population when no crossover is performed (if rand > PC)

    for i = 1:NP*Gap
        % Selection operation
        sita = rand(); % Random number for roulette wheel
        for j = 1:NP
            if sita <= Px(j)
                XSel(i, :) = X(j, :); % Determine parent using roulette wheel rule
                break;
            end
        end
    end
end