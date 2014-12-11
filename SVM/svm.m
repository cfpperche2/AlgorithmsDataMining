function [predicted_features] = svm (train_features, test_features, num_classes, num_attrs, uniq_classes)
    nc = num_classes;
    na = num_attrs;
    uc = uniq_classes;
    %% Training the classifier
    mu = zeros(nc, na);
    sd = zeros(nc, na);
    for i=1:nc
        IndexC = ismember(train_features.(5), uc(i));
        Index = find(IndexC==1);
        prior(i) = length(Index)/length(train_features.(5));
        mu(i,:) = mean(double(train_features(Index,1:4)));
        sd(i,:) = std(double(train_features(Index,1:4)));
    end


    %% Testing the classifier
    for i = 1:size(test_features,1)
        for j = 1:nc
            likelihood = normpdf(double(test_features(i,1:4)),mu(j,:),sd(j,:));
            posterior(j) = prior(j) * prod(likelihood);
        end

        %Assign the class with the highest posterior value
        [max_prob, iklass] = max(posterior);
        iprediction(i) = iklass;
    end
    predicted_features = uc(iprediction(:));
end