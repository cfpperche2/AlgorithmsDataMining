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
[train_dataset, test_dataset] = splitting_dataset(ds,0.7);

%% Run C4.5
[train_targets_i, train_targets_l]=grp2idx(train_dataset.(5)); % Change class name into ordinal index
[test_targets_i, test_targets_l]=grp2idx(test_dataset.(5)); % Change class name into ordinal index

tic();
    predicted = C45(double(train_dataset(:,1:2)), train_targets_i, double(test_dataset(:,1:2)), 10);
etime = toc();
