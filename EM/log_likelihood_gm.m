function ll = log_likelihood_gm(data,mu,sigma,pih)
% Calculates the log likelihood of the data given the parameters of the
% model
%
% @param data   : each row is a d dimensional data point
% @param mu     : a d x k dimensional matrix with columns as the means of
% each cluster
% @param sigma  : a cell array of the cluster covariance matrices
% @param pih     : a column matrix of probabilities for each cluster
%
% @return ll    : the log likelihood of the data (scalar)

% number of observations n 
n = size(data,1);
% number of clusters k
k = size(mu,2);
% number of dimensions d
d = size(data,2);
% define the MVN Gaussian
product_1 = (2*3.14159)^(0.5*d);

det_sigma = zeros(1,k);
inverse_sigma = zeros(d,d,k);

for i = 1:k
    det_sigma(i) = sqrt(det(sigma(:,:,i)));
    inverse_sigma(:,:,i) = inv(sigma(:,:,i));
end
llh = zeros(n,k);
for i = 1:n,
    for j = 1:k,
        dXM = data(i,:) - mu(:,j)';
        product = exp(-0.5*dXM*inverse_sigma(:,:,j)*dXM')/...
            (product_1*det_sigma(j));
        llh(i,j) = pih(j)*product;
    end
    llh1(i,:) = sum(llh(i,:));
end
inner = zeros(150,1);
for i = 1:n
        inner(i,1) = sum(log(llh1(i,:)));
end
ll = sum(inner);