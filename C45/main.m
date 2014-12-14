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
[Gidx, Glabels]=grp2idx(train_features.(5));
Gfeatures = double(train_features(:,1:4));
predicted = C45(Gfeatures, Gidx, 0);

