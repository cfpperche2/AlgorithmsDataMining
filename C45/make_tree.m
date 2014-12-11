function tree = make_tree(features, targets, inc_node, discrete_dim, maxNbin, base)
%Build a tree recursively
[Ni, L]    					= size(features);
Uc         					= unique(targets);
tree.dim						= 0;
%tree.child(1:maxNbin)	= zeros(1,maxNbin);
tree.split_loc				= inf;

if isempty(features),
   break
end

%When to stop: If the dimension is one or the number of examples is small
if ((inc_node > L) | (L == 1) | (length(Uc) == 1)),
   H					= hist(targets, length(Uc));
   [m, largest] 	= max(H);
   tree.child	 	= Uc(largest);
   break
end

%Compute the node's I
for i = 1:length(Uc),
    Pnode(i) = length(find(targets == Uc(i))) / L;
end
Inode = -sum(Pnode.*log(Pnode)/log(2));

%For each dimension, compute the gain ratio impurity
%This is done separately for discrete and continuous features
delta_Ib    = zeros(1, Ni);
split_loc	= ones(1, Ni)*inf;

for i = 1:Ni,
   data	= features(i,:);
   Nbins	= length(unique(data));
   if (discrete_dim(i)),
      %This is a discrete feature
		P	= zeros(length(Uc), Nbins);
      for j = 1:length(Uc),
         for k = 1:Nbins,
            indices 	= find((targets == Uc(j)) & (features(i,:) == k));
            P(j,k) 	= length(indices);
         end
      end
      Pk          = sum(P);
      P           = P/L;
      Pk          = Pk/sum(Pk);
      info        = sum(-P.*log(eps+P)/log(2));
      delta_Ib(i) = (Inode-sum(Pk.*info))/-sum(Pk.*log(eps+Pk)/log(2));
   else
      %This is a continuous feature
      P	= zeros(length(Uc), 2);
      
      %Sort the features
      [sorted_data, indices] = sort(data);
      sorted_targets = targets(indices);
      
      %Calculate the information for each possible split
      I	= zeros(1, L-1);
      for j = 1:L-1,
         for k =1:length(Uc),
            P(k,1) = length(find(sorted_targets(1:j) 		== Uc(k)));
            P(k,2) = length(find(sorted_targets(j+1:end) == Uc(k)));
         end
         Ps		= sum(P)/L;
         P		= P/L;
         info	= sum(-P.*log(eps+P)/log(2));
         I(j)	= Inode - sum(info.*Ps);   
      end
      [delta_Ib(i), s] = max(I);
		split_loc(i) = sorted_data(s);      
   end
end

%Find the dimension minimizing delta_Ib 
[m, dim] = max(delta_Ib);
dims		= 1:Ni;
tree.dim = dim;

%Split along the 'dim' dimension
Nf		= unique(features(dim,:));
Nbins	= length(Nf);
if (discrete_dim(dim)),
   %Discrete feature
   for i = 1:Nbins,
      indices    		= find(features(dim, :) == Nf(i));
      tree.child(i)	= make_tree(features(dims, indices), targets(indices), inc_node, discrete_dim(dims), maxNbin, base);
   end
else
   %Continuous feature
   tree.split_loc		= split_loc(dim);
   indices1		   	= find(features(dim,:) <= split_loc(dim));
   indices2	   		= find(features(dim,:) > split_loc(dim));
   tree.child(1)		= make_tree(features(dims, indices1), targets(indices1), inc_node, discrete_dim(dims), maxNbin);
   tree.child(2)		= make_tree(features(dims, indices2), targets(indices2), inc_node, discrete_dim(dims), maxNbin);
end

end

	