function D = C45(train_features, train_targets, inc_node, region)

% Classify using Quinlan's C4.5 algorithm
% Inputs:
% 	features	- Train features
%	targets	    - Train targets
%	inc_node    - Percentage of incorrectly assigned samples at a node
%	region	    - Decision region vector: [-x x -y y number_of_points]
%
% Outputs
%	D			- Decision sufrace

%NOTE: In this implementation it is assumed that a feature vector with fewer than 10 unique values (the parameter Nu)
%is discrete, and will be treated as such. Other vectors will be treated as continuous

[Ni, M]		= size(train_features);
inc_node    = inc_node*M/100;
Nu          = 10;

%For the decision region
N           = region(5);
mx          = ones(N,1) * linspace (region(1),region(2),N);
my          = linspace (region(3),region(4),N)' * ones(1,N);
flatxy      = [mx(:), my(:)]';

%Preprocessing
%[f, t, UW, m]      = PCA(train_features, train_targets, Ni, region);
%train_features  = UW * (train_features - m*ones(1,M));;
%flatxy          = UW * (flatxy - m*ones(1,N^2));;

%Find which of the input features are discrete, and discretisize the corresponding
%dimension on the decision region
discrete_dim = zeros(1,Ni);
for i = 1:Ni,
   Nb = length(unique(train_features(i,:)));
   if (Nb <= Nu),
      %This is a discrete feature
      discrete_dim(i)	= Nb;
      [H, flatxy(i,:)]	= high_histo(flatxy(i,:), Nb);
   end
end

%Build the tree recursively
disp('Building tree')
tree = make_tree(train_features, train_targets, inc_node, discrete_dim, max(discrete_dim), 0);

%Make the decision region according to the tree
disp('Building decision surface using the tree')
targets	= use_tree(flatxy, 1:N^2, tree, discrete_dim, unique(train_targets));

D = reshape(targets,N,N);
end