function plot_data(X,labels)
% utility function to plot the data based on the first 2 principle
% components of the data.
[pc,SCORE,latent,tsquare] = princomp(X);
if nargin > 1 %nargin - Number of function input arguments
    gscatter(X*pc(:,1),X*pc(:,2),labels,'rgb','osd');
else
    gscatter(X*pc(:,1),X*pc(:,2),'rgb','osd');
end