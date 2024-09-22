% this code aims to cluster the dimension reduced (tca) 2p dataset
% load jc105_tca.mat
% Songyang Wang 240506

load("jc105_tca.mat")
load("combined_average.mat")
%% Preprocessing
% neurons = rrr;
neuron_norm = normalize(neurons);
[coef_pca, neurons_pca, ~,~,explained] = pca(neurons');
neurons_norm_pca = normalize(neurons_pca);
neurons_tsne = tsne(neurons,NumPCAComponents=15);

selected_neurons = neuron_norm(tcaind,:);
%% Visualize Data
cluster_single_group = ones(length(neurons_norm_pca),1);
Overlay_Cluster(neurons_norm_pca,cluster_single_group);
figure;
gscatter(neurons_tsne(:,1),neurons_tsne(:,2))
%% hierarchical
% https://www.mathworks.com/help/stats/hierarchical-clustering.html

file_name = '/Users/songyangwang/Desktop/Chen Lab/Cluster_Result/hierarchical_normonly.pdf';

pair_dist_norm = pdist(neuron_norm);
cluster_tree_norm=linkage(neuron_norm,"complete","correlation");

figure
dendrogram(cluster_tree_norm,'Orientation','left','ColorThreshold','default')
title('sample 25')

k = 8;
clusters = cluster(cluster_tree_norm, 'maxclust', k);
silhouette(neuron_norm, clusters);
title(['Silhouette for ' num2str(k) ' Clusters']);

[indextable_h,average_plot_h,avg_plot_cluster_h]=Avg_Cluster(clusters,new_idx,combined_cellid,combined_avg,neurons);
exclude = [];
Plot_Cluster(clusters,condition,average_plot_h,exclude,1,file_name);
Overlay_Cluster(neurons_tsne,clusters);
Overlay_Cluster(neurons_norm_pca(:,1:4),clusters);

%% k-mean
% https://www.mathworks.com/help/stats/k-means-clustering.html
opts = statset('Display','final','MaxIter',500);  % Increase to 500 iterations
maxClusters = 20; % Maximum number of clusters you want to test
sumdArray = zeros(maxClusters,1); % Array to store sum of squared distances
for k = 1:maxClusters
    [~, clusterIdx, sumd] = kmeans(neuron_norm, k,'Options', opts);
    sumdArray(k) = sum(sumd); % Total sum of squared distances for this k
end

figure;
subplot(211)
plot(1:maxClusters, sumdArray, '-o');
xlabel('Number of Clusters k');
ylabel('Sum of Squared Distances');
title('Elbow Method for Optimal k');
grid on;

silhouetteValues = zeros(maxClusters-1, 1); % Array to store silhouette scores

for k = 2:maxClusters
    [clusterIdx, ~] = kmeans(neuron_norm, k,'Options', opts);
    s = silhouette(neuron_norm, clusterIdx);
    silhouetteValues(k-1) = mean(s);
end

subplot(212)
plot(2:maxClusters, silhouetteValues, '-o');
xlabel('Number of Clusters k');
ylabel('Average Silhouette Score');
title('Silhouette Analysis for Optimal k');
grid on;



file_name_kmean = '/Users/songyangwang/Desktop/Chen Lab/Cluster_Result/kmean_normonly.pdf';

figure;
opts = statset('Display','final','MaxIter',500);  % Increase to 500 iterations

[idx,C,sumdist] = kmeans(neuron_norm,9,'Distance','cityblock', ...
    'Display','final','Options', opts);
[silh,h] = silhouette(neurons_pca,idx,'cityblock');
xlabel('Silhouette Value')
ylabel('Cluster')

[indextable_k,average_plot_k,avg_plot_cluster_k]=Avg_Cluster(idx,new_idx,combined_cellid,combined_avg,neurons);
exclude = [1,3,4,6,2,8,7];
Plot_Cluster(idx,condition,average_plot_k,exclude,1,file_name_kmean);
Overlay_Cluster(neurons_tsne,idx);
Overlay_Cluster(neurons_norm_pca,idx);

%% GMM
% https://www.mathworks.com/help/stats/clustering-using-gaussian-mixture-models.html
rng(3);
k = 10; % Number of GMM components TODO
options = statset('MaxIter',1000);
gmm = fitgmdist(neurons, k);
clusterIdx = cluster(gmm, neurons);  % Cluster indices for each data point
AIC = gmm.AIC;
BIC = gmm.BIC;
% [coeff, score] = pca(neurons);
% figure;
% scatter(score(:,1), score(:,2), 10, clusterIdx);  % Scatter plot of first two principal components
% title('Cluster Visualization with PCA');
% xlabel('First Principal Component');
% ylabel('Second Principal Component');

%%
maxClusters = 10;
aic = zeros(1, maxClusters);
bic = zeros(1, maxClusters);

for k = 1:maxClusters
    gmm = fitgmdist(neurons, k,'RegularizationValue', 0.01);
    aic(k) = gmm.AIC;
    bic(k) = gmm.BIC;
end
clusterIdx = cluster(gmm, neurons);  % Cluster indices for each data point


[indextable_k,average_plot_k,avg_plot_cluster_k]=Avg_Cluster(idx,new_idx,combined_cellid,combined_avg);
exclude = [];
Plot_Cluster(idx,condition,average_plot_k,exclude,2)
figure;
plot(1:maxClusters, aic, 'b-', 1:maxClusters, bic, 'r-');
legend('AIC', 'BIC');
title('AIC and BIC for Different Numbers of Clusters');


