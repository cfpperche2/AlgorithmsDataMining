%% K-Nearest Neighbor classification (KNN)

function [predicted_features] = Knn (train_features, test_features, num_classes, num_attrs, uniq_classes)
    nc = num_classes;
    na = num_attrs;
    uc = uniq_classes;

    
end
clc; close all; clear all;

%% Load data sample and extract some informations
load fisheriris

tic();
uc = unique(species); %unique classes, occurrences, index
nc = length(uc); %number of classes
[nf, na] = size(meas); %number of features, number of attributes
k = [1:2:3];

%% Shuffle the data
idxperm = randperm(nf);
f = meas(idxperm,:); %features
c = species(idxperm,:); %classes
%% Normalize the features
% f_median = median(f);
% f_asd = (1/nc)*(abs(sum(f-f_median)));
f = normr(f);
%% Prepare test and training sets. 
train_f = f(1:round(nf*0.7),:); % train features dataset
test_f = f(round(nf*0.7)+1:nf,:); % test features dataset
train_c = c(1:round(nf*0.7),:); % train classes dataset
test_c = c(round(nf*0.7)+1:nf,:); % test classes dataset
%% Training the classifier
for i=1:length(test_c)
    diff_f = (train_f-repmat(test_f(i,:),length(train_f),1)).^2;
    dist_f(i,:) = sqrt(sum(diff_f,2));
    [dist_of, dist_oi] = sort(dist_f(i,:));
    %% Testing the classifier
    for j=1:length(k)
        %Assign the class with the minimum distance
        k_nn = train_c(dist_oi(1:k(j)));
        
        [k_unn, k_unnc, k_unni] = unique(k_nn);
        [k_nno, k_nnoi] = histc(k_unni, 1:length(k_unn));
        %prediction(i,j) = uc(find(k_nno==max(k_nno)));
        prediction(i,j) = uc(mode(k_nnoi));        
    end    
end
etime = toc();
%% Checking error rate
for err=1:length(k)
    error_rate(err) = sum(~strcmp(prediction(:,err),test_c))/length(test_c);
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
plot(k,error_rate,'-b');
xlabel('k for k-nearest neighbors');
ylabel('error rates');
title 'Training dataset';
