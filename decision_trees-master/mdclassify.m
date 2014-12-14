function result=mdclassify(observation,tree)
% Takes an observation and a trained decision tree and return a resulting
% classification based on the decision tree - can handle missing data.
    
    if ~isempty(tree.results)
        result=tree.results;
    else
        v=observation{tree.col};
        if isempty(v)
            tr=mdclassify(observation,tree.tb);
            fr=mdclassify(observation,tree.fb);
            tcount=sum(cell2mat(tr(:,2)));
            fcount=sum(cell2mat(fr(:,2)));
            tw=tcount/(tcount+fcount);
            fw=fcount/(tcount+fcount);
            tr(:,2)=cellfun(@(x) x*tw, tr(:,2),'UniformOutput', false);
            fr(:,2)=cellfun(@(x) x*fw, fr(:,2),'UniformOutput', false);
            result=[tr;fr];
        else
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
            result=mdclassify(observation,branch);
        end
    end
