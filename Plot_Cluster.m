function cluster_avg = Plot_Cluster(clusters,condition,average_plot,exclude,version,file_name)
moving_avg = 10;
full_cluster = unique(clusters);
plot_idx = setdiff(full_cluster,exclude);
if version == 1
    cluster_avg = figure('WindowState','maximized');
    tiledlayout(3,4,"TileSpacing",'compact')
    sgtitle('All clusters')

    for ch = 1:12
        
        sp(ch) = subplot(3,4,ch);
        neuron_trace_movingaveraged = movmean(squeeze(average_plot(plot_idx,:,ch))',moving_avg); %set the last number for window size
        plot(neuron_trace_movingaveraged,'LineWidth',1.5)
        title(sprintf(condition{ch}),'Interpreter','none')
        if ch==1, lg = legend(cellstr(num2str(plot_idx)),'Interpreter','none','Position',[0.047 0.86 0.034 0.024]);end
        [x,y]=ind2sub([4,3],ch);
        if x==1, ylabel('F_{mean}');end
        if y==3, xlabel('Frame');end
        set(gca,'FontSize',14)
        
    end
    title(lg,'Cluster #')
    linkaxes(sp,'xy')
    exportgraphics(cluster_avg,file_name,'append',true);
    set(gcf,'color','w')

elseif version == 2
    %TODO for loop not neccessary!
    numbfigure = ceil(length(plot_idx)/4);
    for fig_num = 1:numbfigure
        cluster_avg = figure('WindowState','maximized');
        tiledlayout(3,4,"TileSpacing",'compact')
        for subplot_row = 0:2           
            for subplot_col = 1:4 
                try
                cl = (fig_num-1)*4+subplot_col;
                num_of_subplot = subplot_col+subplot_row*4;
                %             linS = {'-.','-.','-','-'};
                %             linc = {'r','k','b','m'};
                sp(num_of_subplot) = subplot(3,4,num_of_subplot);
                neuron_trace_movingaveraged = movmean(squeeze(average_plot(plot_idx(cl),:,(1+subplot_row*4):(4+subplot_row*4))),moving_avg); %set the last number for window size
                plot(neuron_trace_movingaveraged,'LineWidth',1.5)
                [x,y]=ind2sub([4,3],num_of_subplot);
                if x==1 
                    ylabel('F_{mean}');
                    legend(condition((1+subplot_row*4):(4+subplot_row*4)),'Interpreter','none',...
                        'Position',[0.25,1.19-0.3*y,0.05,0.08])
                end
                if y==3, xlabel('Frame');end
                if y==1
                    title(["Cluster ",num2str(plot_idx(cl))]);
                end
                end
                set(gca,'FontSize',14)
            end
        end

        
        linkaxes(sp,'xy')
        % exportgraphics(cluster_avg,file_name,'append',true);
        set(gcf,'color','w')

    end
            

else
    for cl = 1:length(plot_idx)
        cluster_avg = figure('WindowState','maximized');
        tiledlayout(3,4,"TileSpacing",'compact')
        sgtitle(['Cluster #',num2str(plot_idx(cl))])
        for ch = 1:12
            sp(ch) = nexttile();
            neuron_trace_movingaveraged = movmean(squeeze(average_plot(plot_idx(cl),:,ch)),moving_avg); %set the last number for window size
            plot(neuron_trace_movingaveraged,'LineWidth',1.5)
            title(sprintf(condition{ch}),'Interpreter','none')
            %         if cl==1, lg = legend(condition,'Interpreter','none','Location','northoutside');end
            [x,y]=ind2sub([4,3],ch);
            if x==1, ylabel('F_{mean}');end
            if y==3, xlabel('Frame');end
            set(gca,'FontSize',14)
        end
        exportgraphics(cluster_avg,file_name,'append',true);
        linkaxes(sp,'xy')
        set(gcf,'color','w')

        clearvars sp
    end
end


end

