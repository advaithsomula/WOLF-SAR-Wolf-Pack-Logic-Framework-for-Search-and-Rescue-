function wolves = initializeWolvesRRTPaths(rrtPaths)
    wolves = arrayfun(@(idx) createWolves(rrtPaths{idx}), 1:length(rrtPaths));
end
