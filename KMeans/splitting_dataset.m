%% Splitting dataset into training and test sets
function [training, tests] = splitting_dataset(dataset, range)
    nf = size(dataset,1);
    training = dataset(1:round(nf*range),:); % train features dataset
    tests = dataset(round(nf*range)+1:end,:); % test features dataset
end