function imp=giniimpurity(rows)
% Returns probability that a randomly placed item will be in the wrong
% category
    total=size(rows,1);
    counts=uniquecounts(rows);
    imp=0;
    for k1=1:size(counts,1)
        p1=counts{k1,2}/total;
        for k2=1:size(counts,1)
            if k1==k2
                continue;
            else
                p2=counts{k2,2}/total;
                imp=imp+p1*p2;
            end
        end
    end
