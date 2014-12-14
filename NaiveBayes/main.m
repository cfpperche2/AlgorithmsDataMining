%% Naive Bayes
clear all; close all; clc; 

%% Load data sample and prepare
load fisheriris
attributes = {'SLength','SWidth','PLength','PWidth'};
description = 'Fisher''s Iris Dataset';
[ds, uc, nf] = build_dataset(meas,species,attributes,description);

%% Shuffle the dataset
ds = shuffle_dataset(ds);

%% Prepare test and training sets. 
[train_dataset, test_dataset] = splitting_dataset(ds,0.7);

%% Run Naive Bayes
[train_targets_i, train_targets_l]=grp2idx(train_dataset.(5)); % Change class name into ordinal index
[test_targets_i, test_targets_l]=grp2idx(test_dataset.(5)); % Change class name into ordinal index

tic();
    predicted_features = naive_bayes(double(train_dataset(:,1:4)), train_targets_i, double(test_dataset(:,1:4)));
etime = toc();

%% Checking error rate

%predicted_features_labels = train_targets_l(predicted_features); %Convert to class name

%bad_predicted = strcmp(cellstr(predicted_features_labels),cellstr(test_dataset.(5)))

bad_predicted = find(test_targets_i~=predicted_features);

error_rate = length(bad_predicted) /size(test_dataset,1);


%% Print outputs
fprintf('Naive Bayes for normal distribution\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
fprintf('Error rate is %0.5f.\n', error_rate);
%% Plot
figure(1)
subplot(1,2,1) % first subplot
gscatter(meas(:,1), meas(:,2), species,'rgb','osd');
hold on;
grid on;
plot(double(test_dataset(bad_predicted,1)),double(test_dataset(bad_predicted,2)),'kx');
xlabel('Sepal length');
ylabel('Sepal width');
title 'Fisher''s Iris Data';
subplot(1,2,2) % second subplot
gscatter(meas(:,3), meas(:,4), species,'rgb','osd');
hold on;
grid on;
plot(double(test_dataset(bad_predicted,3)),double(test_dataset(bad_predicted,4)),'kx');
xlabel('Petal length');
ylabel('Petal width');
title 'Fisher''s Iris Data';