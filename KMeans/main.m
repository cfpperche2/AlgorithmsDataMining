%% Kmeans
clear all; close all; clc; 

%% Load data sample and prepare
load fisheriris
attributes = {'SLength','SWidth','PLength','PWidth'};
description = 'Fisher''s Iris Dataset';
[ds, uc, nf] = build_dataset(meas,species,attributes,description);


%% Kmeans parameters
K = 3; % The number of clusters
threshold = 0.01; % Stop criteria

%% Shuffle the dataset
ds = shuffle_dataset(ds);

%% Run Kmeans
tic();
[cluster_assignments, cluster_means, f] = Kmeans(ds, length(uc),length(attributes), uc, 3, 0.01);
etime = toc();

%% Checking error rate
prediction = [];
for i=1:K
    aux = find(cluster_assignments(:,i) == 1);
    prediction = [prediction; aux];
end
error_rate = sum(~strcmpi(ds.(5),ds.(5)(prediction)))/length(ds.(5));

%% Print outputs
fprintf('Kmeans finished\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
fprintf('Error rate is %0.5f.\n', error_rate);

%% Plot
meas = normr(meas);

figure(1)
subplot(2,2,1) % first subplot
gscatter(meas(:,1), meas(:,2), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Sepal width');
title 'Original Fisher''s Iris Data';

subplot(2,2,2) % second subplot
gscatter(meas(:,3), meas(:,4), species,'rgb','osd');
xlabel('Petal length');
ylabel('Petal width');
title 'Original Fisher''s Iris Data';

subplot(2,2,3) % third subplot
cols = {'r','g','b','y','m','c','k'};
% Plot the assigned data
for k = 1:K
    plot(f(cluster_assignments(:,k),1),f(cluster_assignments(:,k),2),...
        'ko','markerfacecolor',cols{k});
    hold on
end
% Plot the means
for k = 1:K
    plot(cluster_means(k,1),cluster_means(k,2),'ko','markersize',12,...
        'markerfacecolor',cols{k});
end
xlabel('Sepal length');
ylabel('Sepal width');
title 'Kmeans Fisher''s Iris Data';

subplot(2,2,4) % fourth subplot
% Plot the assigned data
for k = 1:K
    plot(f(cluster_assignments(:,k),3),f(cluster_assignments(:,k),4),...
        'ko','markerfacecolor',cols{k});
    hold on
end
% Plot the means
for k = 1:K
    plot(cluster_means(k,3),cluster_means(k,4),'ko','markersize',12,...
        'markerfacecolor',cols{k});
end
xlabel('Petal length');
ylabel('Petal width');
title 'Kmeans Fisher''s Iris Data';