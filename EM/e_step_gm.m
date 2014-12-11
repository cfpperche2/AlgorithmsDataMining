function gamma = e_step_gm(data,pih,mu,sigma)
% Returns a matrix of responsibilities.
%
% @param    data : data matrix n x d with rows as elements of data
% @param    pi   : column vector of probabilities for each class
% @param    mu   : d x k matrix of class centers listed as columns
% @param    sigma: cell array of class covariance matrices (d x d)
%
% @return   gamma: n x k matrix of responsibilities

% observations
n = size(data,1);
% dimensions
d = size(data,2);
% number of Gaussians allowed
k = size(mu, 2);
% responsibilities 
gamma = zeros(n,k);
% define the MVN Gaussian
product_1 = (2*pi)^(0.5*d);
det_sigma = zeros(1,k);
inverse_sigma = zeros(d,d,k);

for i = 1:k
    det_sigma(i) = sqrt(det(sigma(:,:,i)));
    inverse_sigma(:,:,i) = inv(sigma(:,:,i));
end

for i = 1:n,
    for j = 1:k,
        dXM = data(i,:) - mu(:,j)';
        product = exp(-0.5*dXM*inverse_sigma(:,:,j)*dXM')/...
            (product_1*det_sigma(j));
        gamma(i,j) = pih(j)*product;
    end
    gamma(i,:) = gamma(i,:)/sum(gamma(i,:));
end