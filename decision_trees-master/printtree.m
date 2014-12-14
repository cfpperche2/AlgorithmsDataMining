function out=printtree(tree,indent)
% Output the decision tree in plain text
    
    if nargin <2
        indent='';
    end

    out='';
    
    % Is this a leaf node?
    if ~isempty(tree.results)
        for i=1:size(tree.results,1)
            if i==size(tree.results,1)
                out=[out sprintf('''%s'':%d\n',tree.results{i,1},tree.results{i,2})];
            else
                out=[out sprintf('''%s'':%d, ',tree.results{i,1},tree.results{i,2})];
            end
        end
    else
        % Print the criteria
        if ischar(tree.value)
            out=[out sprintf('%d:%s?\n',tree.col,tree.value)];
        else
            out=[out sprintf('%d:%d?\n',tree.col,tree.value)];
        end
        
        % Print the branches
        out=[out indent sprintf('T-> %s',printtree(tree.tb,[indent ' ']))];
        out=[out indent sprintf('F-> %s',printtree(tree.fb,[indent ' ']))];
        
    end