%% Naive Bayes for normal distribution
clc; close all; clear all;

%% Load data sample and extract some informations
load fisheriris

tic();
uc = unique(species); %unique classes
nc = length(uc); %number of classes
[nf, na] = size(meas); %number of features, number of attributes

%% Shuffle the data
idxperm = randperm(nf);
f = meas(idxperm,:); %features
c = species(idxperm,:); %classes

%% Prepare test and training sets. 
train_f = f(1:round(nf*0.7),:); % train features dataset
test_f = f(round(nf*0.7)+1:nf,:); % test features dataset
train_c = c(1:round(nf*0.7),:); % train classes dataset
test_c = c(round(nf*0.7)+1:nf,:); % test classes dataset

%% Training the classifier
mu = zeros(nc, na);
sd = zeros(nc, na);
for i=1:nc
    IndexC = ismember(train_c, uc(i));
    Index = find(IndexC==1);
    prior(i) = length(Index)/length(train_c);
    mu(i,:) = mean(train_f(Index,:));
    sd(i,:) = std(train_f(Index,:));
end


%% Testing the classifier
for i = 1:length(test_f)
    for j = 1:nc
        likelihood = normpdf(test_f(i,:),mu(j,:),sd(j,:));
        posterior(j) = prior(j) * prod(likelihood);
    end
 
    %Assign the class with the highest posterior value
    [max_prob, iklass] = max(posterior);
    iprediction(i) = iklass;
end
prediction = uc(iprediction(:));
etime = toc();
%% Checking error rate
error_rate = sum(~strcmpi(prediction,test_c))/length(test_c);

%% Print outputs
fprintf('Naive Bayes for normal distribution\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
fprintf('Error rate is %0.5f.\n', error_rate);
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