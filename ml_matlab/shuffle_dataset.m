%% Shuffle the dataset
function [f, t]  = shuffle_dataset(features, targets)
    idxperm = randperm(size(features,1));
    f = features(idxperm,:);
    t = targets(idxperm,:);
end