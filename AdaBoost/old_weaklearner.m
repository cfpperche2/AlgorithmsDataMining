function y = weakLearner(h, x)
% function y = weakLearner(h, x)
%
% weak classifier, or dummy classifiers
% These classifiers are really simple, it simply classify data with a
% single threshold on a certain data dimension
%
% h: a weak classifier, which is a struct with 3 fields:
%       threshold
%       dim (data dimension)
%       pos (direction, if bigger than threshold, will be classified as 1
%       or -1)
%
% x: data, Nx2. N is number of samples and 2 is dimension number
% y: classifier result, Nx1 {-1, 1}
%
% Xu Cui
% 2009/5/12
%

if(h.pos == 1)
    y =  double(x(:,h.dim) >= h.threshold);
else
    y =  double(x(:,h.dim) < h.threshold);
end

pos = find(y==0);
y(pos) = -1;