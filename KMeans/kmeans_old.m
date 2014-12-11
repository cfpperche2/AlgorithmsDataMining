%% KMeans
clc; close all; clear all;

%% Load data sample and extract some informations
load fisheriris

tic();
uc = unique(species); %unique classes, occurrences, index
nc = length(uc); %number of classes
[nf, na] = size(meas); %number of features, number of attributes

%% Kmeans parameters
K = 3; % The number of clusters
threshold = 0.01; % Stop criteria

%% Shuffle the data
idxperm = randperm(nf);
f = meas(idxperm,:); %features
c = species(idxperm,:); %classes
%% Normalize the features (per row)
f = normr(f);

%% Randomly initialise the cluster means
randidx = randperm(size(f, 1));
cluster_means = f(randidx(1:K), :);

%% KMeans Classification 
converged = 0;
cluster_assignments = zeros(nf,K);
di = zeros(nf,K);
while ~converged
    for k = 1:K
        di(:,k) = sqrt(sum((f - repmat(cluster_means(k,:),nf,1)).^2,2));
    end
    old_assignments = cluster_assignments;
    cluster_assignments = (di == repmat(min(di,[],2),1,K));
    % add square of distance to running sum of squared error
    %sse = sse + min^2
    % Check stop criteria
    if sum(sum(old_assignments~=cluster_assignments)) / nf <= threshold
        converged = 1;
    end
    
    % Update centroids
    for k = 1:K
        if sum(cluster_assignments(:,k))==0
            % This cluster is empty, randomise it
            cluster_means(k,:) = f(randperm(nf,1),:)
        else
            cluster_means(k,:) = mean(f(cluster_assignments(:,k),:),1);
        end
    end
end
etime = toc();
%% Checking error rate
prediction = [];
for i=1:K
    aux = find(cluster_assignments(:,i) == 1);
    prediction = [prediction; aux];
end
error_rate = sum(~strcmpi(c,c(prediction)))/length(c);

%% Print outputs
fprintf('Kmeans finished\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
fprintf('Error rate is %0.5f.\n', error_rate);

%% Plot
meas = normr(meas);
figure(1)

subplot(2,2,1) % first subplot
gscatter(meas(:,1), meas(:,2), species,'rgb','osd');
xlabel('Sepal length');
ylabel('Sepal width');
title 'Original Fisher''s Iris Data';

subplot(2,2,2) % second subplot
gscatter(meas(:,3), meas(:,4), species,'rgb','osd');
xlabel('Petal length');
ylabel('Petal width');
title 'Original Fisher''s Iris Data';

subplot(2,2,3) % third subplot
cols = {'r','g','b','y','m','c','k'};
% Plot the assigned data
for k = 1:K
    plot(f(cluster_assignments(:,k),1),f(cluster_assignments(:,k),2),...
        'ko','markerfacecolor',cols{k});
    hold on
end
% Plot the means
for k = 1:K
    plot(cluster_means(k,1),cluster_means(k,2),'ks','markersize',15,...
        'markerfacecolor',cols{k});
end
xlabel('Sepal length');
ylabel('Sepal width');
title 'Kmeans Fisher''s Iris Data';

subplot(2,2,4) % fourth subplot
% Plot the assigned data
for k = 1:K
    plot(f(cluster_assignments(:,k),3),f(cluster_assignments(:,k),4),...
        'ko','markerfacecolor',cols{k});
    hold on
end
% Plot the means
for k = 1:K
    plot(cluster_means(k,3),cluster_means(k,4),'ks','markersize',15,...
        'markerfacecolor',cols{k});
end
xlabel('Petal length');
ylabel('Petal width');
title 'Kmeans Fisher''s Iris Data';

%%