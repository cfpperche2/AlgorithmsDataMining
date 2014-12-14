function ent=entropy(rows)
% Entropy is the sum of p(x)log(p(x)) across all the different possible
% results

    log2=@(x) log(x)/log(2);
    results=uniquecounts(rows);
    
    % Now calculate the entropy
    ent=0.0;
    for i=1:size(results,1)
        p=results{i,2}/size(rows,1);
        ent=ent-p*log2(p);
    end
    
