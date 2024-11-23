function wolf = createWolves(path)
    if iscell(path) % Check if the path is a cell array
        path = cell2mat(path); % Convert cell to matrix
    end
    wolf.path = path;
    wolf.fitness = Inf;
end

