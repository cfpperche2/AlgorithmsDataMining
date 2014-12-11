function [mu,sigma,pih] = m_step_gm(data,gamma)
% Performs the M-step of the EM algorithm for gaussain mixture model.
%
% @param data   : n x d matrix with rows as d dimensional data points
% @param gamma  : n x k matrix of resposibilities
%
% @return mu    : d x k matrix of maximized cluster centers
% @return sigma : cell array of maximized 


% number of clusters k
k = size(gamma,2);
% number of observations n
n = size(data,1);
% number of dimensions d
d = size(data,2);
% number of elements in cluster k
N_k = zeros(1,k);
% matrix of maximized cluster centers
mu = zeros(d,k);
% mixing coefficients pi
pih = ones(1,k);
% k x 1 cell array of class covariance matrices (each are d x d)
sigma = zeros(d,d,k);
% calculate the cluster centers
for i = 1:k, % Compute Weights
    for j = 1:n,
        N_k(i) = N_k(i) + gamma(j,i);
        mu(:,i) = mu(:,i) + gamma(j,i)*data(j,:)';
    end
    mu(:,i) = mu(:,i)/N_k(i);
end
%calculate the mixing coefficients
for i = 1:k,
    for j = 1:n,
        pih(i) = pih(i) + gamma(j,i);
        
    end
end
pih = pih/n;
% calculate class covariance matrices
for i = 1:k,
    for j = 1:n,
        dXM = data(j,:)- mu(:,i)';
        sigma(:,:,i) = sigma(:,:,i) + gamma(j,i).*(dXM'*dXM);
    end
    sigma(:,:,i) = sigma(:,:,i)/N_k(i);
    %sigma(:,:,i) = sigma(:,:,i) + eye(d)*(.005);

end
% make sure sigma is positive definite
 for i = 1:k,
     [R ,p] = chol(sigma(:,:,i));
     while p ~= 0
       sigma(:,:,i) = sigma(:,:,i) + eye(d)*(.001);
       [R ,p] = chol(sigma(:,:,i));

     end
 end