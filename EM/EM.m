% Classify using the expectation-maximization algorithm
% Reference: http://cs229.stanford.edu/notes/cs229-notes7b.pdf
function [f m_shuffled labels_shuffled m_predicted labels_predicted] = EM(train_features, train_targets, K, theta)
% Inputs:
% 	train_features - Train features
%	train_targets - Train targets
%	K - Number of clusters
%	threshold - Percentage of incorrectly assigned samples at a clusters
%
% Outputs
%	test_targets - Test targets

    uc = unique(train_targets);
    nc = length(uc);
    [nf na] = size(train_features);    
    
    f = train_features;

    %% Initial values
    % this sets the initial values of the gamma matrix, the matrix of
    % responsibilities, randomly based on independent draws from a dirichlet
    % distribution.
    gamma = gamrnd(ones(size(f,1),K),1);
    gamma = gamma ./ repmat(sum(gamma,2),1,K);

    % to facilitate visualization, we label each data point by the cluster
    % which takes most responsibility for it.
    [m_shuffled labels_shuffled] = max(gamma,[],2);

    % given the initial labeling we set mu, sigma, and pih based on the m step
    % and calculate the likelihood.
    ll = -inf;
    [mu,sigma,pih] = m_step_gm(f,gamma);
    nll = log_likelihood_gm(f,mu,sigma,pih);
    %disp(['the log likelihood = ' num2str(nll);])

    % the loop iterates until convergence as determined by theta.
    while ll + theta < nll
        ll = nll;
        gamma = e_step_gm(f,pih,mu,sigma);
        [mu,sigma,pih] = m_step_gm(f,gamma);
        nll = log_likelihood_gm(f,mu,sigma,pih);
        %disp(['the log likelihood = ' num2str(nll)]);
        [m_predicted labels_predicted] = max(gamma,[],2);
    end
end

%%
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
end

%%
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
end

%%
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
end