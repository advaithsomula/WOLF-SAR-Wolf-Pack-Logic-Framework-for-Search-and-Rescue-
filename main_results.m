function main_results(level, step_size)
    % Set up the environment and get obstacles
    [obstacles, circularObstacles] = maptesting(level);
    env_width = 200;
    env_height = 200;

    % Convert obstacles to the format expected by RRTPlanner
    obstacle_list = convertObstacles(obstacles, circularObstacles);

    % Initialize positions of wolves (pursuers) and the evader
    wolves_positions = {[10, 10]; [9, 11]; [8, 10]; [8, 8]; [9, 7]; [7, 6]; [6, 5]};
    prey = [140, 80]; % Fixed position of the evader

    % Create an RRT planner instance
    % Create an RRT planner instance
    rrt = RRTPlanner(wolves_positions, prey, step_size, obstacle_list, env_width, env_height);
    iterations = 2500;
    paths = rrt.search(iterations, true);
    
    % Identify wolves with empty paths
    validIndices = ~cellfun(@isempty, paths);
    
    % Inform about wolves that did not find a path
    for i = 1:length(paths)
        if isempty(paths{i})
            fprintf('Wolf %d did not find a path.\n', i);
        end
    end
    
    % Keep only wolves with valid paths
    paths = paths(validIndices);
    wolves_positions = wolves_positions(validIndices);
    wolves = initializeWolvesRRTPaths(paths);



    
   
    weights.lengthWeight = 1;
    weights.obstacleWeight = 10;
    weights.safeDistance = 5;

    for iter = 1:iterations
        % Evaluate fitness of each wolf
        for i = 1:length(wolves)
            if iscell(wolves(i).path)
                wolves(i).path = cell2mat(wolves(i).path);
            end
            wolves(i).fitness = calculateFitness(wolves(i).path, obstacle_list, weights);
        end

        % Sort wolves based on fitness (best fitness first)
        [~, idx] = sort([wolves.fitness]);
        wolves = wolves(idx);
        alpha = wolves(1);  % Alpha wolf with the best path towards the goal
        beta = wolves(2);   % Beta wolf
        delta = wolves(3);  % Delta wolf

        % Recalculate fitness after path adjustment
        for i = 1:length(wolves)
            wolves(i).fitness = calculateFitness(wolves(i).path, obstacle_list, weights);
            % Calculate and update path length
            wolves(i).pathLength = calculatePathLength(wolves(i).path);
        end

        % Update alpha, beta, and delta wolves if necessary
        [~, idx] = sort([wolves.fitness]);
        wolves = wolves(idx);
        
        
    end
    
    % Final visualization and computation of additional metrics
    visualizeFinalPaths(wolves, obstacle_list, prey);
    
    % Display path lengths and fitness scores for all wolves
    wolfDesignations = {'Alpha', 'Beta', 'Delta', 'Omega1', 'Omega2', 'Omega3', 'Omega4'};
    for i = 1:length(wolves)
        designation = wolfDesignations{min(i, length(wolfDesignations))};
        fprintf('%s Wolf Path Length: %f\n', designation, wolves(i).pathLength);
        fprintf('%s Wolf Fitness Score: %f\n', designation, wolves(i).fitness);
    end
end


function obstacle_list = convertObstacles(rectangularObstacles, circularObstacles)
    obstacle_list = [];  % Initialize empty list

    % Add rectangular obstacles
    for i = 1:size(rectangularObstacles, 1)
        rect = rectangularObstacles(i, :);
        obstacle = struct('type', 'rectangle', ...
                          'x', rect(1), 'y', rect(2), ...
                          'width', rect(3), 'height', rect(4), ...
                          'center', [0, 0], 'radius', 0);  % Include center and radius with default values
        obstacle_list = [obstacle_list; obstacle];
    end

    % Add circular obstacles
    for i = 1:size(circularObstacles, 1)
        circ = circularObstacles(i, :);
        obstacle = struct('type', 'circle', ...
                          'center', circ(1:2), 'radius', circ(3), ...
                          'x', 0, 'y', 0, 'width', 0, 'height', 0);  % Include x, y, width, and height with default values
        obstacle_list = [obstacle_list; obstacle];
    end
end


function visualizeFinalPaths(wolves, obstacle_list, prey)
    figure; hold on;
    
    drawMap(obstacle_list); % Ensure this function is defined
    
    % Define colors and markers for different types of wolves
    colors = {'r', 'b', 'y', 'c', 'm', 'g', 'k'};
    markers = {'^', 's', 'd', 'o', 'x', '+', '*'};
    wolfNames = {'Alpha', 'Beta', 'Delta', 'Omega1', 'Omega2', 'Omega3', 'Omega4'};
    
    % Plotting each wolf's final path
    for i = 1:length(wolves)
        wolf = wolves(i);
        path = wolf.path;
        
        % Check if path is empty or invalid
        if isempty(path) || size(path,2) < 2
            fprintf('Wolf %d has an empty or invalid path. Skipping visualization.\n', i);
            continue; % Skip plotting this wolf
        end
        
        color = colors{mod(i-1, length(colors)) + 1};
        marker = markers{mod(i-1, length(markers)) + 1};
        
        % Plotting the path as a line
        plot(path(:,1), path(:,2), 'Color', color, 'LineWidth', 2);
        scatter(path(:,1), path(:,2), 'Marker', marker, 'MarkerEdgeColor', color);
    end
    
    % Plotting the prey position
    plot(prey(1), prey(2), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
    
    xlabel('X Position');
    ylabel('Y Position');
    title('Wolves Final Paths');
    legendEntries = {};
    for i = 1:length(wolves)
        designation = wolfNames{min(i, length(wolfNames))};
        legendEntries{end+1} = [designation ' Path'];
        legendEntries{end+1} = designation;
    end
    legend(legendEntries);
    axis equal;
    grid on;
    hold off;
end

% Include the drawMap function
function drawMap(obstacle_list)
    for i = 1:length(obstacle_list)
        obstacle = obstacle_list(i);
        if strcmp(obstacle.type, 'rectangle')
            rectangle('Position', [obstacle.x, obstacle.y, obstacle.width, obstacle.height], ...
                      'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'k', 'LineWidth', 2);
        elseif strcmp(obstacle.type, 'circle')
            pos = [obstacle.center(1) - obstacle.radius, obstacle.center(2) - obstacle.radius, ...
                   obstacle.radius * 2, obstacle.radius * 2];
            rectangle('Position', pos, 'Curvature', [1, 1], ...
                      'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'k', 'LineWidth', 2);
        end
    end
end
