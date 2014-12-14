%% Classify using classification and regression trees
function test_targets = CART(train_features, train_targets, test_features, inc_node, split_type)
% Inputs:
% 	train_features - Train features
%	train_targets - Train targets
%   test_features - Test features
%	inc_node - Percentage of incorrectly assigned samples at a node
%	split_type - Impurity type can be: Entropy, Variance (or Gini), or Missclassification
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
function tree = make_tree(features, targets, Dlength, split_type, inc_node, region)
    if (length(unique(targets)) == 1)
        %There is only one type of targets, and this generates a warning, so deal with it separately
        tree.right = [];
        tree.left = [];
        tree.Raction = targets(1);
        tree.Laction = targets(1);
        return
    end
    
    [Ni, M] = size(features);
    Nt = unique(targets);
    N = hist(targets, Nt);

    if ((sum(N < Dlength*inc_node) == length(Nt) - 1) | (M == 1)) 
        %No further splitting is neccessary
        tree.right = [];
        tree.left = [];
        if (length(Nt) ~= 1)
            MLlabel = find(N == max(N));
        else
            MLlabel = 1;
        end
        tree.Raction = Nt(MLlabel);
        tree.Laction = Nt(MLlabel);
    else
        %Split the node according to the splitting criterion  
        deltaI = zeros(1,Ni);
        split_point = zeros(1,Ni);
        op = optimset('Display', 'off');   
        for i = 1:Ni
            split_point(i) = fminbnd('CARTfunctions', region(i*2-1), region(i*2), op, features, targets, i, split_type);
            I(i) = feval('CARTfunctions', split_point(i), features, targets, i, split_type);
        end

        [m, dim] = min(I);
        loc = split_point(dim);

        %So, the split is to be on dimention 'dim' at location 'loc'
        indices = 1:M;
        tree.Raction = ['features(' num2str(dim) ',indices) >  ' num2str(loc)];
        tree.Laction = ['features(' num2str(dim) ',indices) <= ' num2str(loc)];
        in_right = find(eval(tree.Raction));
        in_left = find(eval(tree.Laction));

        if isempty(in_right) | isempty(in_left)
            %No possible split found
            tree.right = [];
            tree.left = [];
            if (length(Nt) ~= 1)
                MLlabel = find(N == max(N));
            else
                MLlabel = 1;
            end
        tree.Raction = Nt(MLlabel);
        tree.Laction = Nt(MLlabel);
        else
            %...It's possible to build new nodes
            tree.right = make_tree(features(:,in_right), targets(in_right), Dlength, split_type, inc_node, region);
            tree.left  = make_tree(features(:,in_left), targets(in_left), Dlength, split_type, inc_node, region);      
        end
    end
end

%% Classify recursively using a tree
function targets = use_tree(features, indices, tree)
%Classify recursively using a tree

    if isnumeric(tree.Raction)
        %Reached an end node
        targets = zeros(1,size(features,2));
        targets(indices) = tree.Raction(1);
    else
        %Reached a branching, so:
        %Find who goes where
        in_right = indices(find(eval(tree.Raction)));
        in_left = indices(find(eval(tree.Laction)));

        Ltargets = use_tree(features, in_left, tree.left);
        Rtargets = use_tree(features, in_right, tree.right);

        targets = Ltargets + Rtargets;
    end
end

%% Calculate the difference in impurity for the CART algorithm
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