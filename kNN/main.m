%% K-Nearest Neighbor classification (KNN)
clear all; close all; clc; 

%% Load data sample and prepare
load fisheriris
attributes = {'SLength','SWidth','PLength','PWidth'};
description = 'Fisher''s Iris Dataset';
[ds, uc, nf] = build_dataset(meas,species,attributes,description);

%% Knn parameters
K = [1:2:105]; % The number of clusters

%% Shuffle the dataset
ds = shuffle_dataset(ds);

%% Prepare test and training sets. 
[train_dataset, test_dataset] = splitting_dataset(ds,0.7);

%% Run Knn
[train_targets_i, train_targets_l]=grp2idx(train_dataset.(5)); % Change class name into ordinal index
[test_targets_i, test_targets_l]=grp2idx(test_dataset.(5)); % Change class name into ordinal index

for i=1:length(K)
    tic();
        predicted_features(:,i) = Knn(double(train_dataset(:,1:4)), train_targets_i, double(test_dataset(:,1:4)), K(i));
    etime(i) = toc();
end
%% Checking error rate
for i=1:length(K)
    bad_predicted = find(test_targets_i~=predicted_features(:,i));
    error_rate(i) = length(bad_predicted) /size(test_dataset,1);
end
%% Print outputs
fprintf('KNN for gaussian model\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
fprintf('Error rate is %0.5f.\n', error_rate);

%% Plot
figure(1)
subplot(2,2,1) % first subplot
gscatter(meas(:,1), meas(:,2), species,'rgb','osd');
hold on;
grid on;
plot(double(test_dataset(bad_predicted,1)),double(test_dataset(bad_predicted,2)),'kx');
xlabel('Sepal length');
ylabel('Sepal width');
title 'Fisher''s Iris Data';

subplot(2,2,2) % second subplot
gscatter(meas(:,3), meas(:,4), species,'rgb','osd');
hold on;
grid on;
plot(double(test_dataset(bad_predicted,3)),double(test_dataset(bad_predicted,4)),'kx');
xlabel('Petal length');
ylabel('Petal width');
title 'Fisher''s Iris Data';

subplot(2,2,3) % first subplot
plot(K,etime);
hold on;
grid on;
xlabel('Number of Knn');
ylabel('Elapsed Time');
title 'Fisher''s Iris Data';

subplot(2,2,4) % first subplot
plot(K,error_rate);
hold on;
grid on;
xlabel('Number of Knn');
ylabel('Error rate');
title 'Fisher''s Iris Data';
