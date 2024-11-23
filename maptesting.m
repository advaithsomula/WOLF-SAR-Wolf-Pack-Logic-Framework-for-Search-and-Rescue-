function [obstacles, circularObstacles] = maptesting(level)
    % Define the environment size
    envWidth = 200;
    envHeight = 200;

    % Create a figure
    figure;
    hold on; % Keep the plot for adding obstacles

    % Plot the outer boundary
    rectangle('Position',[0, 0, envWidth, envHeight], 'EdgeColor', 'k', 'LineWidth', 2);

    % Initialize obstacles array
    obstacles = [];    
    circularObstacles = [];
    
    
    % Determine the rectangular and circular obstacles based on the difficulty level
    switch level
        case 'A' % Easy Terrain (Level A): No obstacles
            % No rectangular or circular obstacles

        case 'B' % Medium Complexity (Level B)
            obstacles = [
                % Rectangular obstacles [x, y, width, height]
                25, 40, 20, 50;
                60, 100, 30, 10;
                85, 10, 30, 30;
                120, 160, 40, 10;
            ];
            circularObstacles = [
                % Circular obstacles [center_x, center_y, radius]
                170, 90, 20;
                60, 20, 10;
            ];

        case 'C' % Hard Terrain (Level C)
            obstacles = [
                % Rectangular obstacles [x, y, width, height]
            13, 0, 10, 150; % Vertical wall
            180, 50, 10, 150; % Vertical wall
            30, 20, 150, 10; % Horizontal wall
            50, 170, 100, 10; % Horizontal wall
            20, 100, 80, 30; % Horizontal wall
            120, 100, 80, 10; % Horizontal wall
            ];
            circularObstacles = [
                % Circular obstacles [center_x, center_y, radius]
                140, 30, 10;
                60, 150, 15;
                90, 80, 20;

            ];

        otherwise
            error('Unknown level. Choose A, B, or C.');
    end

    % Loop through and plot each rectangular obstacle
    for i = 1:size(obstacles, 1)
        rectangle('Position',obstacles(i,:), 'FaceColor', 'k');
    end
    
    % Loop through and plot each circular obstacle
    theta = linspace(0, 2*pi, 100); % Parameter for circle
    for i = 1:size(circularObstacles, 1)
        x = circularObstacles(i,1) + circularObstacles(i,3) * cos(theta);
        y = circularObstacles(i,2) + circularObstacles(i,3) * sin(theta);
        fill(x, y, 'k', 'EdgeColor', 'none'); % Fill color black
    end

    % Set the axes limits and labels
    axis([0 envWidth 0 envHeight]);
    axis square;
    xlabel('X [meters]');
    ylabel('Y [meters]');
    title(['Environment Level ' level]);

    hold off; % Release the plot
    
    % Return the obstacles and circularObstacles
end
