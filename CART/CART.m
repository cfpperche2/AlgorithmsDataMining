%% Classify using classification and regression trees
function test_targets = CART(train_features, train_targets, test_features, inc_node, splitting_rule)
% Inputs:
% 	train_features - Train features
%	train_targets - Train targets
%   test_features - Test features
%	inc_node - Percentage of incorrectly assigned samples at a node
%	splitting_rule - Impurity type can be: Entropy, Variance (or Gini), or Missclassification
%
% Outputs
%	test_targets - Test targets

[Ni, M] = size(train_features);
inc_node = inc_node*M/100;

%Build the tree recursively
tree = make_tree(train_features, train_targets, inc_node, 0)
%Classify test samples according to the tree
%test_targets = use_tree(flatxy, 1:N^2, tree, discrete_dim, unique(train_targets));
test_targets = train_features;
end

%% Helper to build a tree recursively
function tree = make_tree(features, targets, inc_node, base)
[Ni, L] = size(features);
Uc = unique(targets);
tree.dim = 0;
tree.split_loc = inf;

%When to stop: If the dimension is one or the number of examples is small
if ((inc_node > L) | (L == 1) | (length(Uc) == 1))
   H = hist(targets, length(Uc));
   [m, largest] = max(H);
   tree.Nf = [];
   tree.split_loc = [];
   tree.child = Uc(largest);
   return
end

%Compute the node's information
for i = 1:length(Uc),
    Pnode(i) = length(find(targets == Uc(i))) / L;
end
Inode = -sum(Pnode.*log(Pnode)/log(2));

%For each dimension, compute the gain ratio impurity
%This is done separately for discrete and continuous features
delta_Ib = zeros(1, Ni);
split_loc = ones(1, Ni)*inf;

for i = 1:Ni,
    data = features(i,:);
    Ud = unique(data);
    Nbins = length(Ud);
    
    %This is a continuous pattern
    P = zeros(length(Uc), 2);
    %Sort the patterns
    [sorted_data, indices] = sort(data);
    sorted_targets = targets(indices);
    %Calculate the information for each possible split
    I	= zeros(1, L-1);
    for j = 1:L-1,
        %for k =1:length(Uc),
        %    P(k,1) = sum(sorted_targets(1:j)        == Uc(k));
        %    P(k,2) = sum(sorted_targets(j+1:end)    == Uc(k));
        %end
        P(:,1) = hist(sorted_targets(1:j), Uc);
        P(:,2) = hist(sorted_targets(j+1:end), Uc);
        Ps = sum(P)/L;
        P = P/L;
        Pk = sum(P);            
        P1 = repmat(Pk, length(Uc), 1);
        P1 = P1 + eps*(P1==0);
        info = sum(-P.*log(eps+P./P1)/log(2));
        I(j) = Inode - sum(info.*Ps);
    end
    [delta_Ib(i), s] = max(I);
    split_loc(i) = sorted_data(s);  
end

%Find the dimension minimizing delta_Ib
[m, dim] = max(delta_Ib);
dims = 1:Ni;
tree.dim = dim;
%Split along the 'dim' dimension
Nf = unique(features(dim,:));
Nbins = length(Nf);
tree.Nf = Nf;
tree.split_loc = split_loc(dim);
%If only one value remains for this pattern, one cannot split it.
if (Nbins == 1)
    H = hist(targets, length(Uc));
    [m, largest] = max(H);
    tree.Nf = [];
    tree.split_loc = [];
    tree.child = Uc(largest);
    return
end
%Continuous pattern
indices1 = find(features(dim,:) <= split_loc(dim));
indices2 = find(features(dim,:) > split_loc(dim));
if ~(isempty(indices1) | isempty(indices2))
    tree.child(1) = make_tree(features(dims, indices1), targets(indices1), inc_node, base+1);
    tree.child(2) = make_tree(features(dims, indices2), targets(indices2), inc_node, base+1);
else
    H = hist(targets, length(Uc));
    [m, largest] = max(H);
    tree.child = Uc(largest);
    tree.dim = 0;
end
end

%% Classify recursively using a tree
function targets = use_tree(features, indices, tree, discrete_dim, Uc)
targets = zeros(1, size(features,2));

if (tree.dim == 0)
   %Reached the end of the tree
   targets(indices) = tree.child;
   return
end
        
%This is not the last level of the tree, so:
%First, find the dimension we are to work on
dim = tree.dim;
dims = 1:size(features,1);

%And classify according to it
   %Continuous feature
   in = indices(find(features(dim, indices) <= tree.split_loc));
   targets = targets + use_tree(features(dims, :), in, tree.child(1), discrete_dim(dims), Uc);
   in = indices(find(features(dim, indices) >  tree.split_loc));
   targets = targets + use_tree(features(dims, :), in, tree.child(2), discrete_dim(dims), Uc);
end

function delta = splitting_rules(split_point, features, targets, dim, split_type)
    %Calculate the difference in impurity for the CART algorithm
    Uc = unique(targets);
    for i = 1:length(Uc),
       in = find(targets == Uc(i));
       Pr(i) = length(find(features(dim, in) >   split_point))/length(in);
       Pl(i) = length(find(features(dim, in) <=  split_point))/length(in);
    end

    switch split_type,
    case 'Entropy'
       Er = sum(-Pr.*log(Pr+eps)/log(2));
       El = sum(-Pl.*log(Pl+eps)/log(2));
    case {'Variance', 'Gini'}
        Er = 1 - sum(Pr.^2);
        El = 1 - sum(Pl.^2);
    case 'Missclassification'
       Er = 1 - max(Pr);
       El = 1 - max(Pl);
    otherwise
       error('Possible splitting rules are: Entropy, Variance, Gini, or Missclassification')
    end
    P = length(find(features(dim, :) <= split_point)) / length(targets);
    delta = -P*El - (1-P)*Er;
end