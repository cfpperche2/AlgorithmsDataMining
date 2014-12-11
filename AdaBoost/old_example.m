% Demo of adaBoost (adaptive boosting)
%
% Xu Cui
% 2009/05/12
%

clear

% training data (1000 samples, 2 dimensions, can be seen as 1000 people, each people have 2 variable: weight and age)
data = randn(1000,2);
label = double(data(:,1)>data(:,2)); % a linear separation example
label = double((data(:,1).^2 - data(:,2).^2)<1); % a nonlinear separation example
%label = double((data(:,1).^2 + data(:,2).^2)<1); % a nonlinear separation example

pos1 = find(label == 1);
pos2 = find(label == 0);
label(pos2) = -1;

% plot training data
figure('color','w');plot(data(pos1,1), data(pos1,2), 'b*')
hold on;plot(data(pos2,1), data(pos2,2), 'r*')
xlim([-3 3])
ylim([-3 3])
title('original data')
axis square


% addBoost

T = 10; % we choose maximally T weak learners (weak classifiers)
D = ones(size(label))/length(label); % initial weight is equal weight for all samples
h = {}; % will hold weak classifiers
alpha = []; % weight of each weak learner (not weight of sample)

for t=1:T
    % loop through all possible weak classifiers and find the best
    % (minimize error rate respect to D)
    % in our case, we totally have 244 weak classifiers (in theory, you can
    % have infinite). Each classifier is really dummy, it simply classifier
    % the data based on a single threshold on a certain data dimension
    % (either 1 or 2). Check out weakLearner.m
    err(t) = inf;
    thresholds = [-3:0.1:3];
    for ii=1:length(thresholds) %threshold
        for jj=[-1 1] %direction
            for kk=[1 2] %dim
                tmph.dim = kk;
                tmph.pos = jj;
                tmph.threshold  = thresholds(ii);
                tmpe = sum(D.*(weaklearner(tmph,data) ~= label));
                if( tmpe < err(t))
                    err(t) = tmpe;
                    h{t} = tmph;
                end
            end
        end
    end
    
    if(err(t) >= 1/2)
        disp('stop b/c err>1/2')
        break;
    end
    
    alpha(t) = 1/2 * log((1-err(t))/err(t));
    
    % we update D so that wrongly classified samples will have more weight
    D = D.* exp(-alpha(t).*label.* weaklearner(h{t}, data));
    D = D./sum(D);
end

figure('color','w')
% strong learner, which is simply a linear sum of weak learners. The weight
% of each weak learner is in alpha
finalLabel = zeros(size(label));
for t=1:length(alpha)
    finalLabel = finalLabel + alpha(t) * weaklearner(h{t}, data);
    tfinalLabel = sign(finalLabel);
    misshits(t) = sum(tfinalLabel ~= label)/size(data,1);    
    
    pos1 = find(tfinalLabel == 1);
    pos2 = find(tfinalLabel == -1);
    subplot(5,2,t);plot(data(pos1,1), data(pos1,2), 'b*')
    hold on;plot(data(pos2,1), data(pos2,2), 'r*')
    xlim([-3 3])
    ylim([-3 3])
    xlabel(['t = ' num2str(t)])
    axis square
    
end


% plot miss hits when more and more weak learners are used
figure('color','w');plot(misshits)
ylabel('miss hists')