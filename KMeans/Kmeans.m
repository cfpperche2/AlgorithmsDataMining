%% KMeans
function [cluster_assignments, cluster_means, f] = Kmeans(dataset, num_classes, num_attrs, uniq_classes, K, threshold)
    nc = num_classes;
    na = num_attrs;
    uc = uniq_classes;
    nf = size(dataset,1);

%% Normalize the features (per row)
f = normr(double(dataset(:,1:na)));

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

end
