function fh = Overlay_Cluster(full_dataset,clusters)
numGroups = length(unique(clusters));
colors = lines(numGroups);
edge_colors = lines(7);
legendEntries = cell(numGroups, 1);
size_input = size(full_dataset);
fh = figure();
hold on
title('Clustering Result Overlay On TCA');
fh.WindowState = 'maximized';
xlabel('1^{st} PCA Component');
ylabel('2^{nd} PCA Component');
if size_input(2)>2
    zlabel('3^{rd} PCA Component');
    for i = 1:numGroups
        idx = clusters == i;
        scatter3(full_dataset(idx,1), full_dataset(idx,2), full_dataset(idx,3), 'MarkerFaceColor', colors(i,:),...
            'MarkerEdgeColor',edge_colors(ceil(i/7),:),LineWidth=1.5);
        legendEntries{i} = sprintf('Cluster %d', i);
    end
else
    for i = 1:numGroups
        idx = clusters == i;
        scatter(full_dataset(idx,1), full_dataset(idx,2), 'MarkerFaceColor', colors(i,:),...
            'MarkerEdgeColor',edge_colors(ceil(i/7),:),LineWidth=1.5);
        legendEntries{i} = sprintf('Cluster %d', i);
    end
end
set(gcf,'color', 'w');
legend(legendEntries, 'Location', 'best');  % Add a legend with dynamic entries
hold off
set(gca,'fontsize',14)
grid on