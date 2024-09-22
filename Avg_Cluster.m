function [indextable, average_plot, avg_plot_cluster, neurons_avg_bygroup] = Avg_Cluster(clusters, new_idx, combined_cellid, combined_avg, neurons)
% Avg_Cluster: Organizes and averages cluster data from a dataset of 
% neurons and their associated activity plots.
%
% Inputs:
%   clusters        - Array of cluster assignments for each neuron.
%   new_idx         - Index of TCA (Tensor Component Analysis) in the original 
%                     average 2-photon plot.
%   combined_cellid - Cell array of neuron IDs corresponding to the 2-photon plot.
%   combined_avg    - 3D matrix representing the average 2-photon activity 
%                     (time x condition x neuron).
%   neurons         - Matrix representing the TCA vectors for each neuron.
%
% Outputs:
%   indextable         - A table that combines various indices and metadata.
%   average_plot       - Average 2-photon activity for each cluster.
%   avg_plot_cluster   - Concatenation of average plots by cluster.
%   neurons_avg_bygroup - TCA vectors averaged by cluster.
%
% The function:
% 1. Reorders the neuron IDs based on the new index.
% 2. Creates a table combining cluster, cell ID, and index information.
% 3. Groups 2-photon activity and TCA vectors by cluster and calculates the averages.
    
% Initialize start index for reordering the combined_cellid
start_ind = 1;

% Loop through new_idx and reorder combined_cellid based on the TCA index
for idx = 1:length(new_idx)
    % Reorder combined_cellid based on new_idx, mapping to the original indices
    combined_cellid_reorder{start_ind, 1} = combined_cellid{new_idx(start_ind)};
    start_ind = start_ind + 1;
end

% Define the size and types of columns for the indextable
sz = [length(new_idx), 4]; % Number of rows = length(new_idx), 4 columns
varTypes = {'double', 'string', 'double', 'double'}; % Column types
varNames = {'cluster', 'cellid', 'avgplotindex', 'tcaindex'}; % Column names

% Initialize the table with predefined size, types, and names
indextable = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames', varNames);

% Populate the indextable columns with the appropriate data
indextable.cluster = clusters;                      % Assign clusters to the table
indextable.cellid = combined_cellid_reorder;        % Assign reordered cell IDs
indextable.avgplotindex = new_idx;                  % Assign TCA indices for the plot
indextable.tcaindex = (1:length(new_idx))';         % Assign a running index for TCA

% Initialize cell arrays to hold average plots and TCA vectors grouped by cluster
avg_plot_cluster = cell(length(unique(clusters)), 1); % Preallocate average plots by cluster
tca_bygroup = cell(length(unique(clusters)), 1);      % Preallocate TCA vectors by cluster

% Loop through each neuron and assign its data to the correct cluster
for neuron = 1:length(new_idx)
    % Get the cluster number for the current neuron
    cluster_number = indextable.cluster(neuron);
    
    % Get the corresponding index for the average plot
    average_plot_index = indextable.avgplotindex(neuron);
    
    % Append the neuron's average plot data to the correct cluster group
    avg_plot_cluster{cluster_number}(end+1, :, :) = combined_avg(average_plot_index, :, :);
    
    % Append the neuron's TCA vector to the correct cluster group
    tca_bygroup{cluster_number}(end+1, :) = neurons(neuron, :);
end

% Initialize matrices to store the averaged plots and neurons by cluster
for cl = 1:length(unique(clusters))
    % Calculate the mean of the average plot for each cluster
    average_plot(cl, :, :) = mean(avg_plot_cluster{cl}, 1);
    
    % Calculate the mean of the TCA vectors for each cluster
    neurons_avg_bygroup(cl, :) = mean(tca_bygroup{cl}, 1);
end

end