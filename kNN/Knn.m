%% K-Nearest Neighbor classification (KNN)

function [predicted_features] = Knn (train_features, test_features, num_classes, num_attrs, uniq_classes, K)
    nc = num_classes;
    na = num_attrs;
    uc = uniq_classes;

%% Normalize the features
train_f = double(train_features(:,1:na));
test_f = double(test_features(:,1:na));
train_f = normr(train_f);
test_f = normr(test_f);

%% Training the classifier
for i=1:length(test_f)
    diff_f = (train_f-repmat(test_f(i,:),length(train_f),1)).^2;
    dist_f(i,:) = sqrt(sum(diff_f,2));
    [dist_of, dist_oi] = sort(dist_f(i,:));
    %% Testing the classifier
    for j=1:K
        %Assign the class with the minimum distance
        k_nn = train_features.(5)(dist_oi(1:j));
        
        [k_unn, k_unnc, k_unni] = unique(k_nn);
        [k_nno, k_nnoi] = histc(k_unni, 1:length(k_unn));
        %prediction(i,j) = uc(find(k_nno==max(k_nno)));
        predicted_features(i,j) = uc(mode(k_nnoi));        
    end    
end
end