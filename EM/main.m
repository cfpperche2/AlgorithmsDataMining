%% Expectation Maximization for Gaussian Mixture Model
clear all; close all; clc; 

%% Load data sample and prepare
load fisheriris
attributes = {'SLength','SWidth','PLength','PWidth'};
description = 'Fisher''s Iris Dataset';
[ds, uc, nf] = build_dataset(meas,species,attributes,description);


%% EM parameters
% k is the number of clusters to use, you should experiment with this
% number and MAKE SURE YOUR CODE WORKS FOR ANY VALUE OF K >= 1
K = 3;
theta = 0.01;

%% Shuffle the dataset
ds = shuffle_dataset(ds);

%% Run Naive Bayes
tic();
[f m_shuffled labels_shuffled m_predicted labels_predicted] = EM(ds, length(uc),length(attributes), uc, K, theta);
etime = toc();

%% Checking error rate
%error_rate = sum(~strcmpi(prediction,test_c))/length(test_c);

%% Print outputs
fprintf('Expectatio Maximization for Gaussian Mixture Model\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
%fprintf('Error rate is %0.5f.\n', error_rate);

%% Plot Data Shuffle
figure(1)
subplot(1,2,1) % first subplot
plot_data(double(ds(:,1:length(attributes))),labels_shuffled)
xlabel('Sepal length');
ylabel('Sepal width');
title 'Fisher''s Iris Shuffled Data';
%% Plot Predicted Data
% this draws a plot of the initial labeling.
subplot(1,2,2) % second subplot
plot_data(f,labels_predicted);
xlabel('Sepal length');
ylabel('Sepal width');
title 'Fisher''s Iris Predicted Data ';
