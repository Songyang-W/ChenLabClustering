function [indextable,average_plot,avg_plot_cluster,neurons_avg_bygroup]=Avg_Cluster(clusters,new_idx,combined_cellid,combined_avg,neurons)

%{ 
Inputs
clusters:array 
new_idx: tca index in original average 2p plot
combined_cellid: cell id for average 2p plot
combined_avg:average 2p plot
neurons: tca matrix

Outputs
indextable: combine of the index
average_plot: average plot for each cluster, row--cluster #, col--time, z--condition 
avg_plot_cluster: concatenate of the average plot
neurons_avg_bygroup:sort the tca vectors by cluster

%}
start_ind = 1;
for idx = 1:length(new_idx)
    combined_cellid_reorder{start_ind,1} = combined_cellid{new_idx(start_ind)};
    start_ind = start_ind+1;
end

sz = [length(new_idx) 4];
varTypes = {'double','string','double','double'};
varNames = {'cluster','cellid','avgplotindex','tcaindex'};
indextable = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
indextable.cluster = clusters;
indextable.cellid = combined_cellid_reorder;
indextable.avgplotindex = new_idx;
indextable.tcaindex = [1:length(new_idx)]';

avg_plot_cluster = cell(length(unique(clusters)),1);
tca_bygroup = cell(length(unique(clusters)),1);

for neuron =1:length(new_idx)
    cluster_number = indextable.cluster(neuron);
    average_plot_index = indextable.avgplotindex(neuron);
    avg_plot_cluster{cluster_number}(end+1,:,:) = combined_avg(average_plot_index,:,:);
    
    tca_bygroup{cluster_number}(end+1,:) = neurons(neuron,:);
end

for cl = 1:length(unique(clusters))
    average_plot(cl,:,:) = mean(avg_plot_cluster{cl},1);
    neurons_avg_bygroup(cl,:) = mean(tca_bygroup{cl},1);
end
   
end

    
