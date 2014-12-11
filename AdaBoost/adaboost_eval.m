function [estimateclasstotal, model] = adaboost_eval(mode,datafeatures,dataclass_or_model,itt)
% This function AdaBoost, consist of two parts a simpel weak classifier and
% a boosting part:
% The weak classifier tries to find the best threshold in one of the data
% dimensions to sepparate the data into two classes -1 and 1
% The boosting part calls the clasifier iteratively, after every classification
% step it changes the weights of miss-classified examples. This creates a
% cascade of "weak classifiers" which behaves like a "strong classifier"
%
%  Training mode:
%    [estimateclass,model]=adaboost('train',datafeatures,dataclass,itt)
%  Apply mode:
%    estimateclass=adaboost('apply',datafeatures,model)
% 
%  inputs/outputs:
%    datafeatures : An Array with size number_samples x number_features
%    dataclass : An array with the class off all examples, the class
%                 can be -1 or 1
%    itt : The number of training itterations
%    model : A struct with the cascade of weak-classifiers
%    estimateclass : The by the adaboost model classified data
%%
switch(mode)
    case 'train'
        % Train the adaboost model
        
        % Set the data class 
        dataclass=dataclass_or_model(:);
        model=struct;
        
        % Weight of training samples, first every sample is even important
        % (same weight)
        D=ones(length(dataclass),1)/length(dataclass);
        
        % This variable will contain the results of the single weak
        % classifiers weight by their alpha
        estimateclasssum=zeros(size(dataclass));
        
        % Calculate max min of the data
        boundary=[min(datafeatures,[],1) max(datafeatures,[],1)];
        % Do all model training itterations
        for t=1:itt
            % Find the best threshold to separate the data in two classes
            [estimateclass,err,h] = WeightedThresholdClassifier(datafeatures,dataclass,D);

            % Weak classifier influence on total result is based on the current
            % classification error
            alpha=1/2 * log((1-err)/max(err,eps));
            
            % Store the model parameters
            model(t).alpha = alpha;
            model(t).dimension=h.dimension;
            model(t).threshold=h.threshold;
            model(t).direction=h.direction;
            model(t).boundary = boundary;
            
            % We update D so that wrongly classified samples will have more weight
            D = D.* exp(-model(t).alpha.*dataclass.*estimateclass);
            D = D./sum(D);
            
            % Calculate the current error of the cascade of weak classifiers
            estimateclasssum=estimateclasssum +estimateclass*model(t).alpha;
            estimateclasstotal=sign(estimateclasssum);
            model(t).error=sum(estimateclasstotal~=dataclass)/length(dataclass);
            if(model(t).error==0), break; end
        end
        
    case 'apply' 
        % Apply Model on the test data
        model=dataclass_or_model;
        
        % Limit datafeatures to orgininal boundaries
        if(length(model)>1);
            minb=model(1).boundary(1:end/2);
            maxb=model(1).boundary(end/2+1:end);
            datafeatures=bsxfun(@min,datafeatures,maxb);
            datafeatures=bsxfun(@max,datafeatures,minb);
        end
    
        % Add all results of the single weak classifiers weighted by their alpha 
        estimateclasssum=zeros(size(datafeatures,1),1);
        for t=1:length(model);
            estimateclasssum=estimateclasssum+model(t).alpha*ApplyClassThreshold(model(t), datafeatures);
        end
        % If the total sum of all weak classifiers
        % is less than zero it is probablly class -1 otherwise class 1;
        estimateclasstotal=sign(estimateclasssum);
    otherwise
        error('adaboost:inputs','unknown mode');
end