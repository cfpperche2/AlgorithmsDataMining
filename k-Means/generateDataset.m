function X = generateDataset(Coeff, Samples)

% Ordem
O = length(Coeff);

% You need to return the following variables correctly.
X = zeros(Samples,Coeff);

% generate random dataset
for i = 1:Samples
    for j = 1:O
        X(i,j) = Coeff(j)*rand();
    end
end

end