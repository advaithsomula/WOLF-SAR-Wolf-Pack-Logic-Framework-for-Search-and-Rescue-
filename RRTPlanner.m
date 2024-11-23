classdef RRTPlanner
    properties
        wolves_positions; % Array of starting positions for each pursuer
        prey; % Evader Node
        step_size;
        obstacle_list;
        env_width;
        env_height;
        trees = {}; % Array of trees, one for each pursuer
    end

    methods
        function obj = RRTPlanner(wolves_positions, prey, step_size, obstacle_list, env_width, env_height)
            % RRTPlanner constructor
            if size(wolves_positions, 1) == 1 && size(wolves_positions, 2) == 2
           
                wolves_positions = {wolves_positions}; % Convert to cell array for consistency
            end

            for i = 1:length(wolves_positions)
                start_point = wolves_positions{i};
                if ~isa(start_point, 'Node')
                    pursuer_start = Node(start_point(1), start_point(2));
                else
                    pursuer_start = start_point;
                end
                obj.trees{end+1} = [pursuer_start]; % Initialize each tree
            end

            if ~isa(prey, 'Node')
                prey = Node(prey(1), prey(2));
            end

            obj.prey = prey;
            obj.step_size = step_size;
            obj.obstacle_list = obstacle_list;
            obj.env_width = env_width;
            obj.env_height = env_height;
        end

        function [paths] = search(obj, iter, visualize)
        paths = cell(1, length(obj.trees));
        isPathFound = false(1, length(obj.trees));

        if visualize
            figure; hold on;
            % Plotting evader and pursuers
            plot(obj.prey.x, obj.prey.y, 'ro','LineWidth', 4, 'MarkerSize', 12);
            for i = 1:length(obj.trees)
                plot(obj.trees{i}(1).x, obj.trees{i}(1).y, 'go', 'LineWidth', 4, 'MarkerSize', 12);
            end
        end
        for idx = 1:iter
            for i = 1:length(obj.trees)
                new_node = obj.generate_random_node();
                nearest_node = obj.nearest_node(new_node, i);
                new_node = obj.connect_nodes(nearest_node, new_node, i);

                if ~isempty(new_node)
                    obj.trees{i} = [obj.trees{i}; new_node];
                    new_node.parent = nearest_node;
                    if visualize
                        plot([nearest_node.x, new_node.x], [nearest_node.y, new_node.y], 'k');
                        plot(new_node.x, new_node.y, 'm.');
                    end
                end
            end

            for i = 1:length(obj.trees)
                if obj.pursuer_reached_evader(i) && ~isPathFound(i)
                    paths{i} = obj.find_path(obj.trees{i}(end), i);
                    isPathFound(i) = true;
                    if visualize
                        plot(paths{i}(:,1), paths{i}(:,2), 'g-', 'LineWidth', 2);
                    end
                end
            end

            pause(0.1); % Pause for visualization
        end

        if visualize
            hold off;
        end
    end
        function new_node = generate_random_node(obj)
            % generate_random_node method
            if rand < 0.05
                x = obj.prey.x;
                y = obj.prey.y;
            else
                x = rand() * obj.env_width;
                y = rand() * obj.env_height;
            end
            new_node = Node(x, y);
        end

        function [nearest_node, nearest_idx] = nearest_node(obj, node, tree_idx)
            % nearest_node method
            nearest_idx = 1;
            nearest_node = obj.trees{tree_idx}(1);
            min_dist = sqrt((node.x - nearest_node.x)^2 + (node.y - nearest_node.y)^2);

            for i = 2:length(obj.trees{tree_idx})
                current_node = obj.trees{tree_idx}(i);
                dist = sqrt((node.x - current_node.x)^2 + (node.y - current_node.y)^2);

                if dist < min_dist
                    min_dist = dist;
                    nearest_node = current_node;
                    nearest_idx = i;
                end
            end
        end

        function new_node = connect_nodes(obj, parent, child, tree_idx)
            % connect_nodes method
            direction = atan2(child.y - parent.y, child.x - parent.x);
            step = obj.step_size;
            new_node = Node(parent.x + step * cos(direction), parent.y + step * sin(direction));
            new_node.parent = parent;

            if obj.check_collision(new_node, parent)
                new_node = []; % Collision detected, return empty array
            end
        end

        function collision = check_collision(obj, node, parent)
            % check_collision method
            collision = false;
            for i = linspace(0, 1, obj.step_size)
                intermediate_x = parent.x * (1 - i) + node.x * i;
                intermediate_y = parent.y * (1 - i) + node.y * i;
                for j = 1:length(obj.obstacle_list)
                    obstacle = obj.obstacle_list(j);
                    if strcmp(obstacle.type, 'rectangle') && intermediate_x >= obstacle.x && intermediate_x <= obstacle.x + obstacle.width && intermediate_y >= obstacle.y && intermediate_y <= obstacle.y + obstacle.height
                        collision = true;
                        return;
                    elseif strcmp(obstacle.type, 'circle') && norm([intermediate_x, intermediate_y] - obstacle.center) <= obstacle.radius
                        collision = true;
                        return;
                    end
                end
            end
        end

        function reached = pursuer_reached_evader(obj, tree_idx)
            % pursuer_reached_evader method
            latest_node = obj.trees{tree_idx}(end);
            distance_to_evader = sqrt((latest_node.x - obj.prey.x)^2 + (latest_node.y - obj.prey.y)^2);
            safeDistance = 5; % Threshold distance to consider the evader reached
            reached = distance_to_evader <= safeDistance;
        end
        function inside = is_inside_obstacle(node, obstacle_list)
    % Check if a node is inside any obstacle
            inside = false;
            for i = 1:length(obstacle_list)
                obstacle = obstacle_list(i);
                if strcmp(obstacle.type, 'rectangle')
                    if node.x >= obstacle.x && node.x <= obstacle.x + obstacle.width && ...
                       node.y >= obstacle.y && node.y <= obstacle.y + obstacle.height
                        inside = true;
                        return;
                    end
                elseif strcmp(obstacle.type, 'circle')
                    if norm([node.x, node.y] - obstacle.center) <= obstacle.radius
                        inside = true;
                        return;
                    end
                end
            end
        end
        function path = find_path(obj, node, tree_idx)
            % find_path method
            path = [];
            while ~isempty(node)
                path = [node.x, node.y; path];
                node = node.parent;
            end
        end

    end 
end 
