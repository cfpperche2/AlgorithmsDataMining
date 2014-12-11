function targets = use_tree(features, indices, tree, discrete_dim, Uc)
%Classify recursively using a tree

targets = zeros(1, size(features,2));

if (tree.dim == 0)
   %Reached the end of the tree
   targets(indices) = tree.child;
   break
end
        
%This is not the last level of the tree, so:
%First, find the dimension we are to work on
dim = tree.dim;
dims= 1:size(features,1);

%And classify according to it
if (discrete_dim(dim) == 0),
   %Continuous feature
   in = indices(find(features(dim, indices) <= tree.split_loc));
   targets = targets + use_tree(features(dims, :), in, tree.child(1), discrete_dim(dims), Uc);
   in = indices(find(features(dim, indices) >  tree.split_loc));
   targets = targets + use_tree(features(dims, :), in, tree.child(2), discrete_dim(dims), Uc);
else
   %Discrete feature
   Uf				= unique(features(dim,:));
	for i = 1:length(Uf),
	   in   	   = indices(find(features(dim, indices) == Uf(i)));
      targets	= targets + use_tree(features(dims, :), in, tree.child(i), discrete_dim(dims), Uc);
   end
end
end