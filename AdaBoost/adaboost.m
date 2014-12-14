%% Classify using the AdaBoost algorithm
function [estimateclasstotal, model] = adaboost (train_features, train_targets, weak_learners)
% This function AdaBoost, consist of two parts a simpel weak classifier and
% a boosting part: The weak classifier tries to find the best threshold in
% one of the data dimensions to sepparate the data into two classes -1 and
% 1 The boosting part calls the clasifier iteratively, after every
% classification step it changes the weights of miss-classified examples.
% This creates a cascade of "weak classifiers" which behaves like a "strong
% classifier" Inputs:
% 	train_features - Train features
%	train_targets - Train targets
%   test_features - Test features
%   weak_learners - The number of training itterations
%
% Outputs
%    estimateclass - The by the adaboost model classified data
%    model - A struct with the cascade of weak-classifiers

    uc = unique(train_targets);
    nc = length(uc);
    [nf na] = size(train_features);
    
    % Train the adaboost model
        
    % Set the data class 
    dataclass = train_targets(:);
    model = struct;

    % Weight of training samples, first every sample is even important
    % (same weight)
    D = ones(length(dataclass),1)/length(dataclass);

    % This variable will contain the results of the single weak
    % classifiers weight by their alpha
    estimateclasssum = zeros(size(dataclass));

    % Calculate max min of the data
    boundary = [min(train_features,[],1) max(train_features,[],1)];
    % Do all model training itterations
    for t=1:weak_learners
        % Find the best threshold to separate the data in two classes
        [estimateclass,err,h] = weighted_classifier(train_features,dataclass,D);

        % Weak classifier influence on total result is based on the current
        % classification error
        alpha=1/2 * log((1-err)/max(err,eps));

        % Store the model parameters
        model(t).alpha = alpha;
        model(t).dimension = h.dimension;
        model(t).threshold = h.threshold;
        model(t).direction = h.direction;
        model(t).boundary = boundary;

        % We update D so that wrongly classified samples will have more weight
        D = D.* exp(-model(t).alpha.*dataclass.*estimateclass);
        D = D./sum(D);

        % Calculate the current error of the cascade of weak classifiers
        estimateclasssum = estimateclasssum + estimateclass * model(t).alpha;
        estimateclasstotal = sign(estimateclasssum);
        model(t).error = sum(estimateclasstotal~=dataclass)/length(dataclass);
        if(model(t).error == 0)
            return; 
        end
    end
end
