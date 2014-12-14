function node=buildtree(rows,scoref)
% Build the Classification and Regression Tree (CART) 
    if nargin <2
        scoref=@entropy;
    end
    
    current_score=scoref(rows);
    
    % Set up some variables to track the best criteria
    best_gain=0.0;
    best_criteria={};
    best_sets={};
    
    % Loop through all the columns except the last
    for col=1:size(rows,2)-1
        % Generate the list of different values in this column
        if iscellstr(rows(:,col))
            is_cell_str=1;
            column_values=sortrows(unique(rows(:,col)),-1);
        else
            is_cell_str=0;
            column_values=unique(cell2mat(rows(:,col)));
        end
        for v=1:size(column_values,1)
            if is_cell_str
                set=divideset(rows,col,column_values{v});
            else
                set=divideset(rows,col,column_values(v));
            end
            
            % Information gain
            p=size(set{1,1},1)/size(rows,1);
            gain=current_score-p*scoref(set{1,1})-(1-p)*scoref(set{1,2});
            if gain>best_gain && size(set{1,1},1)>0 && size(set{1,2},1)>0
                best_gain=gain;
                if is_cell_str
                    best_criteria={col,column_values{v}};
                else
                    best_criteria={col,column_values(v)};
                end
                best_sets=set;
            end
        end
    end
    
    % Create the subbranches
    if best_gain >0
        trueBranch=buildtree(best_sets{1,1},scoref);
        falseBranch=buildtree(best_sets{1,2},scoref);
        node=decisionnode(best_criteria{1},best_criteria{2},{},trueBranch,falseBranch);
    else
        node=decisionnode(-1,{},uniquecounts(rows));
    end
    
    