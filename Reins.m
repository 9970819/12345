function X = Reins(X, XSel, fit)
    %% Reinsertion of offspring into the new population
    % Inputs:
    % X      - Parent population
    % XSel   - Offspring population
    % fit    - Fitness of the parent population
    % Outputs:
    % X      - New population combined from parents and offspring

    NP = size(X, 1); % Number of individuals in the parent population
    NSel = size(XSel, 1); % Number of individuals in the offspring population
    
    % Sort the fitness in descending order to prioritize higher fitness individuals
    [~, index] = sort(fit, 'descend');
    
    % Combine the top individuals from the parent population with the offspring
    X = [X(index(1:NP - NSel), :); XSel];
end