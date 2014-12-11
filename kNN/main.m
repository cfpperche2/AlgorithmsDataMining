%% K-Nearest Neighbor classification (KNN)
clear all; close all; clc; 

%% Load data sample and prepare
load fisheriris
attributes = {'SLength','SWidth','PLength','PWidth'};
description = 'Fisher''s Iris Dataset';
[ds, uc, nf] = build_dataset(meas,species,attributes,description);

%% Knn parameters
K = 3; % The number of clusters

%% Shuffle the dataset
ds = shuffle_dataset(ds);

%% Prepare test and training sets. 
[train_features, test_features] = splitting_dataset(ds,0.7);

%% Run Naive Bayes
tic();
predicted_features = Knn(train_features, test_features, length(uc),length(attributes), uc, K);
etime = toc();

etime = toc();
%% Checking error rate
for err=1:K
    error_rate(err) = sum(~strcmp(predicted_features(:,err),test_features.(5)))/length(test_features.(5));
end
%% Print outputs
fprintf('KNN for gaussian model\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
fprintf('Error rate is %0.5f.\n', error_rate);
%{

%% Plot
figure(1)
subplot(1,2,1) % first subplot
gscatter(meas(:,1), meas(:,2), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Sepal width');
title 'Fisher''s Iris Data';
subplot(1,2,2) % second subplot
gscatter(meas(:,3), meas(:,4), species,'rgb','osd');
xlabel('Petal length');
ylabel('Petal width');
title 'Fisher''s Iris Data';
%%
%}
figure(2)
plot([1:K],error_rate,'-b');
xlabel('k for k-nearest neighbors');
ylabel('error rates');
title 'Training dataset';