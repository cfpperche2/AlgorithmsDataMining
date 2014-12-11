%% Adaptative Boosting
clear all; close all; clc; 

%% Load data sample and prepare
load fisheriris
attributes = {'SLength','SWidth','PLength','PWidth'};
description = 'Fisher''s Iris Dataset';
[ds, uc, nf] = build_dataset(meas,species,attributes,description);

%% Shuffle the dataset
ds = shuffle_dataset(ds);

%% Prepare test and training sets. 
[train_features, test_features] = splitting_dataset(ds,0.7);

%% Run Naive Bayes
tic();
predicted_features = adaboost(train_features, test_features, length(uc),length(attributes), uc);
etime = toc();
bad_predicted = [];
%% Checking error rate
for i=1:size(test_features,1)
    if ~strcmp(cellstr(predicted_features(i)),cellstr(test_features(i,5)))
        bad_predicted = [bad_predicted, i];
    end
end

error_rate = length(bad_predicted) /size(test_features,1);


%% Print outputs
fprintf('Naive Bayes for normal distribution\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
fprintf('Error rate is %0.5f.\n', error_rate);
%% Plot
figure(1)
subplot(1,2,1) % first subplot
gscatter(meas(:,1), meas(:,2), species,'rgb','osd');
hold on;
%plot(double(test_features(bad_predicted,1)),double(test_features(bad_predicted,2)),'kx');
hold off;
xlabel('Sepal length');
ylabel('Sepal width');
title 'Fisher''s Iris Data';
subplot(1,2,2) % second subplot
gscatter(meas(:,3), meas(:,4), species,'rgb','osd');
hold on;
%plot(double(test_features(bad_predicted,3)),double(test_features(bad_predicted,4)),'kx');
hold off;
xlabel('Petal length');
ylabel('Petal width');
title 'Fisher''s Iris Data';