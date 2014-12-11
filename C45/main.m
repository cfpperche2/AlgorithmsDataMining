%% C4.5
clc; close all; clear all;

%% Load data sample and prepare
load fisheriris
attributes = {'SLength','SWidth','PLength','PWidth'};
description = 'Fisher''s Iris Dataset';
[ds, uc, nf] = build_dataset(meas,species,attributes,description);

%% Shuffle the dataset
ds = shuffle_dataset(ds);

%% Prepare test and training sets. 
[train_features, test_features] = splitting_dataset(ds,0.7);

%% Run C4.5

% Entropy should be in the range [0:1]
%entropy = sum(-(prior(i)*log2(prior(i))));
%info_gain = entropy(X) - sum(prior(a|x) * entropy(A|X))
%gain_ratio = info_gain(A|X) / entropy(X);
%regions = [{min(double(train_features(:,1:4)))} {max(double(train_features(:,1:4)))} {size(train_features,1)}];
C4_5(train_features,attributes,test_features);

