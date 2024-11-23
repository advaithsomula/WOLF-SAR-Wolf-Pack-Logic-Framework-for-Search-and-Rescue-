function fitness = calculateFitness(path, obstacleList, weights)
    pathLength = calculatePathLength(path);
    obstaclePenalty = calculateObstaclePenalty(path, obstacleList, weights.safeDistance);
    fitness = weights.lengthWeight * pathLength + ...
              weights.obstacleWeight * obstaclePenalty;
end


function length = calculatePathLength(path)
    if iscell(path)
        path = cell2mat(path);
    end
    length = 0;
    for i = 1:size(path, 1) - 1
        length = length + norm(path(i, :) - path(i + 1, :));
    end
end



function penalty = calculateObstaclePenalty(path, obstacleList, safeDistance)
    penalty = 0;
    for point = path'
        minDist = minDistanceToObstacles(point, obstacleList);
        if minDist < safeDistance
            penalty = penalty + (safeDistance - minDist);
        end
    end
end



function minDist = minDistanceToObstacles(point, obstacleList)
    minDist = inf;
    for i = 1:length(obstacleList)
        obstacle = obstacleList(i);
        dist = distanceToObstacle(point, obstacle);
        if dist < minDist
            minDist = dist;
        end
    end
end


function dist = distanceToObstacle(point, obstacle)
    if strcmp(obstacle.type, 'rectangle')
        % Rectangle obstacle
        left = obstacle.x;
        right = obstacle.x + obstacle.width;
        bottom = obstacle.y;
        top = obstacle.y + obstacle.height;

        dx = max([left - point(1), 0, point(1) - right]);
        dy = max([bottom - point(2), 0, point(2) - top]);

        dist = sqrt(dx^2 + dy^2);
    elseif strcmp(obstacle.type, 'circle')
        % Circle obstacle
        center = obstacle.center;
        radius = obstacle.radius;

        distToCenter = norm(point - center);
        dist = max(distToCenter - radius, 0);
    else
        error('Unknown obstacle type');
    end
end

