function prune(tree,mingain)
%

    % If the subbranches are not endpoints, then do more pruning
    if isempty(tree.tb.results)
        prune(tree.tb,mingain)
    end
    if isempty(tree.fb.results)
        prune(tree.fb,mingain)
    end
    
    % If both subbranches are enndpoints, see if they should be merged
    if ~isempty(tree.tb.results) && ~isempty(tree.fb.results)
        % Build a combined dataset
        tb=[];
        fb=[];
        for i=1:size(tree.tb.results,1)
            tb=[tb; repmat(tree.tb.results(i,1),tree.tb.results{i,2},1)];
        end
        for i=1:size(tree.fb.results,1)
            fb=[fb; repmat(tree.fb.results(i,1),tree.fb.results{i,2},1)];
        end
        % Test the reduction in entropy
        delta=entropy([tb;fb])-(entropy(tb)+entropy(fb)/2);
        
        if delta<mingain
            % Merge the branches
            tree.tb=[]; 
            tree.fb=[];
            tree.results=uniquecounts([tb;fb]);
        end
            
    end