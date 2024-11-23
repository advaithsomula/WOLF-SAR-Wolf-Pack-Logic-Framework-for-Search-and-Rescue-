function length = calculatePathLength(path)
    length = 0;
    for i = 1:size(path, 1) - 1
        length = length + norm(path(i, :) - path(i + 1, :));
    end
end
