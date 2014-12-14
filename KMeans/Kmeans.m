%% Classify using the K Means
function [cluster_assignments, cluster_means, train_features] = Kmeans(train_features, train_targets, K, threshold)
% Inputs:
% 	train_features - Train features
%	train_targets - Train targets
%	K - Number of clusters
%	threshold - Percentage of incorrectly assigned samples at a clusters
%
% Outputs
%	test_targets - Test targets

    uc = unique(train_targets);
    nc = length(uc);
    [nf na] = size(train_features);
    
    %% Normalize the features (per row)
    train_features = normr(train_features);
   
    %% Randomly initialise the cluster means
    randidx = randperm(size(train_features, 1));
    cluster_means = train_features(randidx(1:K), :);

    %% KMeans Classification 
    converged = 0;
    cluster_assignments = zeros(nf,K);
    di = zeros(nf,K);
    while ~converged
        for k = 1:K
            di(:,k) = sqrt(sum((train_features - repmat(cluster_means(k,:),nf,1)).^2,2));
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
                cluster_means(k,:) = train_features(randperm(nf,1),:)
            else
                cluster_means(k,:) = mean(train_features(cluster_assignments(:,k),:),1);
            end
        end
    end
end
