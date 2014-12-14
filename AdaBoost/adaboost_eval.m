%% Classify using the AdaBoost algorithm
function [estimateclasstotal] = adaboost_eval (test_features, model)
% This function AdaBoost, consist of two parts a simpel weak classifier and
% a boosting part: The weak classifier tries to find the best threshold in
% one of the data dimensions to sepparate the data into two classes -1 and
% 1 The boosting part calls the clasifier iteratively, after every
% classification step it changes the weights of miss-classified examples.
% This creates a cascade of "weak classifiers" which behaves like a "strong
% classifier" Inputs:
%   test_features - Test features
%   model - A struct with the cascade of weak-classifiers
%
% Outputs
%    estimateclass - The by the adaboost model classified data

    % Limit datafeatures to orgininal boundaries
    if(length(model) > 1);
        minb = model(1).boundary(1:end/2);
        maxb = model(1).boundary(end/2+1:end);
        test_features = bsxfun(@min,test_features,maxb);
        test_features = bsxfun(@max,test_features,minb);
    end

    % Add all results of the single weak classifiers weighted by their alpha 
    estimateclasssum = zeros(size(test_features,1),1);
    for t=1:length(model);
        estimateclasssum = estimateclasssum + model(t).alpha * weak_learner(model(t), test_features);
    end
    % If the total sum of all weak classifiers
    % is less than zero it is probablly class -1 otherwise class 1;
    estimateclasstotal = sign(estimateclasssum);
end
