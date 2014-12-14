%% Classify using the Nearest neighbor algorithm
function [test_targets] = Knn (train_features, train_targets, test_features, K)
% Inputs:
% 	train_features - Train features
%	train_targets - Train targets
%   test_features - Test features
%	K - Number of nearest neighbors
%
% Outputs
%	test_targets - Test targets

    uc = unique(train_targets);
    nc = length(uc);
    [nf na] = size(train_features);

    %% Normalize the features (per row)
    train_features = normr(train_features);
    test_features = normr(test_features);
    
    %% Training the classifier
    for i=1:size(test_features,1)
        distances(i,:) = sqrt(sum((train_features-repmat(test_features(i,:),size(train_features,1),1)).^2,2));
        [ordered_distance, ordered_index] = sort(distances(i,:));

        %% Testing the classifier
        best_fit = train_targets(ordered_index(1:K));
        [max_class best_class] = max(histc(best_fit, uc));
        test_targets(i) = best_class;
    end
end