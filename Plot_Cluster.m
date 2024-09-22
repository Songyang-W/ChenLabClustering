function cluster_avg = Plot_Cluster(clusters, condition, average_plot, exclude, version, file_name)
% Plot_Cluster: Generates plots for clusters of neural data across conditions
% and exports them to a file.
%
% Inputs:
%   clusters     - Array of cluster assignments for each neuron.
%   condition    - Cell array of condition names (for titles of the plots).
%   average_plot - 3D matrix of average activity plots (cluster x time x condition).
%   exclude      - Array of cluster indices to exclude from plotting.
%   version      - Specifies the layout version for plotting (1, 2, or 3).
%   file_name    - Name of the file to save the plots to.
%
% Outputs:
%   cluster_avg  - Handle to the generated figure(s).
%
% The function plots average activity for clusters across conditions with options 
% to plot in different layouts based on the 'version' input.

% Define the window size for the moving average filter applied to the traces
moving_avg = 10;

% Get the unique clusters and remove the ones that should be excluded
full_cluster = unique(clusters);
plot_idx = setdiff(full_cluster, exclude);

% Check the layout version to decide how to plot the data
if version == 1
    % Version 1: All clusters in one figure, 3x4 tile layout
    cluster_avg = figure('WindowState', 'maximized');  % Maximize figure window
    tiledlayout(3, 4, "TileSpacing", 'compact');       % Create a 3x4 layout
    sgtitle('All clusters');                           % Add a title for the figure

    % Loop over 12 conditions/channels and create a subplot for each
    for ch = 1:12
        % Create subplots in a 3x4 grid
        sp(ch) = subplot(3, 4, ch);
        
        % Apply a moving average filter to smooth the traces for each cluster
        neuron_trace_movingaveraged = movmean(squeeze(average_plot(plot_idx, :, ch))', moving_avg); 
        
        % Plot the smoothed neuron activity traces
        plot(neuron_trace_movingaveraged, 'LineWidth', 1.5);
        title(sprintf(condition{ch}), 'Interpreter', 'none');  % Add title for each condition
        
        % Add a legend for the first subplot to display cluster numbers
        if ch == 1
            lg = legend(cellstr(num2str(plot_idx)), 'Interpreter', 'none', ...
                'Position', [0.047 0.86 0.034 0.024]);
        end
        
        % Adjust labels based on subplot position (for readability)
        [x, y] = ind2sub([4, 3], ch);
        if x == 1, ylabel('F_{mean}'); end
        if y == 3, xlabel('Frame'); end
        
        % Set font size for the current subplot
        set(gca, 'FontSize', 14);
    end
    
    % Add a title to the legend to indicate that it represents cluster numbers
    title(lg, 'Cluster #');
    
    % Link axes of all subplots to allow synchronized zooming and panning
    linkaxes(sp, 'xy');
    
    % Save the figure to the specified file
    exportgraphics(cluster_avg, file_name, 'append', true);
    
    % Set background color of the figure to white
    set(gcf, 'color', 'w');

elseif version == 2
    % Version 2: Multiple figures, each with 3x4 tile layout
    % Determine the number of figures required based on the number of clusters
    numbfigure = ceil(length(plot_idx) / 4);
    
    % Loop over the number of figures needed
    for fig_num = 1:numbfigure
        cluster_avg = figure('WindowState', 'maximized');  % Maximize figure window
        tiledlayout(3, 4, "TileSpacing", 'compact');       % Create a 3x4 layout
        
        % Loop over rows and columns of the subplot grid
        for subplot_row = 0:2
            for subplot_col = 1:4
                try
                    % Calculate cluster index for the current subplot
                    cl = (fig_num - 1) * 4 + subplot_col;
                    num_of_subplot = subplot_col + subplot_row * 4;

                    % Create subplot for current cluster and condition
                    sp(num_of_subplot) = subplot(3, 4, num_of_subplot);
                    
                    % Apply a moving average filter to smooth the traces
                    neuron_trace_movingaveraged = movmean(squeeze(average_plot(plot_idx(cl), :, ...
                        (1+subplot_row*4):(4+subplot_row*4))), moving_avg);
                    
                    % Plot the smoothed traces
                    plot(neuron_trace_movingaveraged, 'LineWidth', 1.5);
                    
                    % Adjust labels and titles based on subplot position
                    [x, y] = ind2sub([4, 3], num_of_subplot);
                    if x == 1 
                        ylabel('F_{mean}');
                        legend(condition((1+subplot_row*4):(4+subplot_row*4)), 'Interpreter', 'none', ...
                            'Position', [0.25, 1.19 - 0.3 * y, 0.05, 0.08]);
                    end
                    if y == 3, xlabel('Frame'); end
                    if y == 1
                        title(["Cluster ", num2str(plot_idx(cl))]);
                    end
                end
                % Set font size for the current subplot
                set(gca, 'FontSize', 14);
            end
        end
        
        % Link axes of all subplots to allow synchronized zooming and panning
        linkaxes(sp, 'xy');
        
        % Set background color of the figure to white
        set(gcf, 'color', 'w');
    end
    
else
    % Version 3: Each cluster gets its own figure
    for cl = 1:length(plot_idx)
        cluster_avg = figure('WindowState', 'maximized');  % Maximize figure window
        tiledlayout(3, 4, "TileSpacing", 'compact');       % Create a 3x4 layout
        sgtitle(['Cluster #', num2str(plot_idx(cl))]);     % Add a title for the figure
        
        % Loop over 12 conditions/channels and create a subplot for each
        for ch = 1:12
            sp(ch) = nexttile();  % Create the next subplot tile
            
            % Apply a moving average filter to smooth the traces for the current cluster
            neuron_trace_movingaveraged = movmean(squeeze(average_plot(plot_idx(cl), :, ch)), moving_avg);
            
            % Plot the smoothed neuron activity traces
            plot(neuron_trace_movingaveraged, 'LineWidth', 1.5);
            title(sprintf(condition{ch}), 'Interpreter', 'none');  % Add title for each condition
            
            % Adjust labels based on subplot position (for readability)
            [x, y] = ind2sub([4, 3], ch);
            if x == 1, ylabel('F_{mean}'); end
            if y == 3, xlabel('Frame'); end
            
            % Set font size for the current subplot
            set(gca, 'FontSize', 14);
        end
        
        % Save the figure to the specified file
        exportgraphics(cluster_avg, file_name, 'append', true);
        
        % Link axes of all subplots to allow synchronized zooming and panning
        linkaxes(sp, 'xy');
        
        % Set background color of the figure to white
        set(gcf, 'color', 'w');
        
        % Clear subplot handles for the next iteration
        clearvars sp;
    end
end

end