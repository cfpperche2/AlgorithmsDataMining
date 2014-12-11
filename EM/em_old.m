%% Expectation Maximization for Gaussian Mixture Model
% Reference: http://cs229.stanford.edu/notes/cs229-notes7b.pdf
clc; close all; clear all;

%% Load data sample and extract some informations
load fisheriris

tic();
uc = unique(species); %unique classes
nc = length(uc); %number of classes
[nf, na] = size(meas); %number of features, number of attributes

%% Shuffle the data
idxperm = randperm(nf);
f = meas(idxperm,:); %features
c = species(idxperm,:); %classes

%% EM constants
% k is the number of clusters to use, you should experiment with this
% number and MAKE SURE YOUR CODE WORKS FOR ANY VALUE OF K >= 1
K = 3;
theta = .01;

%% Initial values
% this sets the initial values of the gamma matrix, the matrix of
% responsibilities, randomly based on independent draws from a dirichlet
% distribution.
gamma = gamrnd(ones(size(f,1),K),1);
gamma = gamma ./ repmat(sum(gamma,2),1,K);

% to facilitate visualization, we label each data point by the cluster
% which takes most responsibility for it.
[m labels] = max(gamma,[],2);

% given the initial labeling we set mu, sigma, and pih based on the m step
% and calculate the likelihood.
ll = -inf;
[mu,sigma,pih] = m_step_gm(f,gamma);
nll = log_likelihood_gm(f,mu,sigma,pih);
%disp(['the log likelihood = ' num2str(nll);])


%% Plot Data Shuffle
figure(1)
subplot(1,2,1) % first subplot
plot_data(f,labels)
xlabel('Sepal length');
ylabel('Sepal width');
title 'Fisher''s Iris Shuffled Data';

% the loop iterates until convergence as determined by theta.
while ll + theta < nll
    ll = nll;
    gamma = e_step_gm(f,pih,mu,sigma);
    [mu,sigma,pih] = m_step_gm(f,gamma);
    nll = log_likelihood_gm(f,mu,sigma,pih);
    %disp(['the log likelihood = ' num2str(nll)]);
    [m labels] = max(gamma,[],2);
end
etime = toc();

%% Checking error rate
%error_rate = sum(~strcmpi(prediction,test_c))/length(test_c);

%% Print outputs
fprintf('Expectatio Maximization for Gaussian Mixture Model\n');
fprintf('Elapsed time is %0.5f seconds.\n', etime);
%fprintf('Error rate is %0.5f.\n', error_rate);

%% Plot Predicted Data
% this draws a plot of the initial labeling.
subplot(1,2,2) % second subplot
plot_data(f,labels);
xlabel('Petal length');
ylabel('Petal width');
title 'Fisher''s Iris Predicted Data ';