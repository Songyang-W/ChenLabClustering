function Similarity_matrix(data)

R_mat = corrcoef(data);
figure('WindowState','maximized');
h = heatmap(R_mat);
h.Title = 'Pearson Corr Coef';
h.FontSize = 18;
cmap = [0.529 0.808 0.922; 1 1 1; 1 0.5 0.5];
fineCmap = interp1([-1 0 1], cmap, linspace(-1, 1, 256), 'linear');
colormap(fineCmap);
caxis([-1 1]);

end