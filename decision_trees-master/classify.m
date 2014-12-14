function result=classify(observation,tree)
% Takes an observation and a trained decision tree and return a resulting
% classification based on the decision tree. 
    
    if ~isempty(tree.results)
        result=tree.results;
    else
        v=observation{tree.col};
        if isinteger(v) || isfloat(v)
            if v >= tree.value
                branch=tree.tb;
            else
                branch=tree.fb;
            end
        else
            if strcmp(v,tree.value)
                branch=tree.tb;
            else
                branch=tree.fb;
            end
        end
        result=classify(observation,branch);
    end
