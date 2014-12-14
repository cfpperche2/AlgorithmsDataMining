function predicted_features = naive_bayes (train_features, train_targets, test_features)
    uc = unique(train_targets);
    nc = length(uc);
    [nf na] = size(train_features);

    %% Training the classifier

    %Estimate class priors
    priors = hist(train_targets,uc);
    prior = priors/sum(priors);

    %Estimate mean and standard deviation for each class and feature
    mu = zeros(nc, na);
    sd = zeros(nc, na);
    for i = 1:nc
        mu(i,:) = mean(train_features(train_targets == uc(i),:));
        sd(i,:) = std(train_features(train_targets == uc(i),:));
    end

    sd(sd(i,:) == 0) = sqrt((size(train_features,1)-1)/12);

    %% Testing the classifier
    for i = 1:size(test_features,1)
        for j = 1:nc
        likelihood = normpdf(test_features(i,:),mu(j,:),sd(j,:));
        posterior(j) = prior(j) * prod(likelihood);
        end
 
        %Assign the class with the highest posterior value
        [max_prob, class] = max(posterior);
        predicted_features(i) = class;
    end
    predicted_features = predicted_features';
end