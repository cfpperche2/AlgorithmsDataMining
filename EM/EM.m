%% Expectation Maximization for Gaussian Mixture Model
% Reference: http://cs229.stanford.edu/notes/cs229-notes7b.pdf
function [f m_shuffled labels_shuffled m_predicted labels_predicted] = EM(dataset, num_classes, num_attrs, uniq_classes, K, theta)
    nc = num_classes;
    na = num_attrs;
    uc = uniq_classes;
    nf = size(dataset,1);
    f = double(dataset(:,1:na));

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