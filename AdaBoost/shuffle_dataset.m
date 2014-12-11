%% Shuffle the dataset
function ds = shuffle_dataset(dataset)
    idxperm = randperm(size(dataset,1));
    ds = dataset(idxperm,:);
end