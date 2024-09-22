function fh = Overlay_Cluster(full_dataset, clusters)
% Overlay_Cluster: Visualizes clustering results by overlaying clusters 
% onto a 2D or 3D scatter plot.
%
% Inputs:
%   full_dataset - A matrix where each row is a data point and columns 
%                  represent different features (dimensions).
%   clusters     - A vector containing cluster assignments for each data point.
%
% Outputs:
%   fh           - Handle to the generated figure.

% Determine the number of unique clusters
numGroups = length(unique(clusters));

% Generate distinct colors for each cluster and edge colors for marker borders
colors = lines(numGroups); % Creates a set of colors for each group
edge_colors = lines(7);    % Fixed set of edge colors (reused every 7 clusters)

% Initialize legend entries for each cluster (to be shown in the legend)
legendEntries = cell(numGroups, 1);

% Get the size of the full dataset to determine if it's 2D or 3D
size_input = size(full_dataset);

% Create a new figure and prepare it for plotting
fh = figure();
hold on;  % Allows multiple plots to be added to the figure without overwriting

% Set title and maximize the figure window for better visualization
title('Clustering Result Overlay On TCA');
fh.WindowState = 'maximized';  % Maximizes the figure window for better viewing

% Label the x and y axes (assuming PCA or similar components)
xlabel('1^{st} PCA Component');
ylabel('2^{nd} PCA Component');

% Check if the dataset has more than 2 dimensions (i.e., 3D plot)
if size_input(2) > 2
    % If the dataset has 3 dimensions, label the z-axis
    zlabel('3^{rd} PCA Component');
    
    % Loop over each cluster and plot its points in 3D
    for i = 1:numGroups
        % Find the indices of points that belong to the current cluster
        idx = clusters == i;
        
        % Plot the points for this cluster in 3D space using scatter3
        scatter3(full_dataset(idx, 1), full_dataset(idx, 2), full_dataset(idx, 3), ...
            'MarkerFaceColor', colors(i,:), ...                % Set marker color
            'MarkerEdgeColor', edge_colors(ceil(i/7), :), ...  % Set marker edge color
            'LineWidth', 1.5);                                 % Set marker edge thickness
        
        % Create a label for the cluster to be shown in the legend
        legendEntries{i} = sprintf('Cluster %d', i);
    end
else
    % If the dataset has 2 dimensions, use a 2D scatter plot
    for i = 1:numGroups
        % Find the indices of points that belong to the current cluster
        idx = clusters == i;
        
        % Plot the points for this cluster in 2D space using scatter
        scatter(full_dataset(idx, 1), full_dataset(idx, 2), ...
            'MarkerFaceColor', colors(i,:), ...                % Set marker color
            'MarkerEdgeColor', edge_colors(ceil(i/7), :), ...  % Set marker edge color
            'LineWidth', 1.5);                                 % Set marker edge thickness
        
        % Create a label for the cluster to be shown in the legend
        legendEntries{i} = sprintf('Cluster %d', i);
    end
end

% Set figure background color to white for better visibility
set(gcf, 'color', 'w');

% Add a legend to the plot with entries for each cluster
legend(legendEntries, 'Location', 'best');  % Place the legend at the best location

% Release the hold on the current figure so no further plots are added
hold off;

% Set font size of axis labels and ticks for better readability
set(gca, 'fontsize', 14);

% Enable grid on the plot for better alignment and visualization
grid on;
end