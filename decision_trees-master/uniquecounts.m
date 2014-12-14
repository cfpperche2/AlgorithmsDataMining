
function results=uniquecounts(rows)
% Create counts of possible results.

    % The last column of each row is the result.
    if ~isempty(rows)
        lastrow=rows(:,end);
        if iscellstr(lastrow)
            is_cell_str=1;
             results=unique(lastrow);
        else
            is_cell_str=0;
            results=unique(cell2mat(lastrow));
            results=mat2cell(results,ones(1,size(results,1)),size(results,2));
        end
        
    else
        results={};
    end
    
    % how many
    for i=1:size(results,1)
        if is_cell_str
             count=size(strmatch(results{i},char(lastrow)),1);
        else
            count=size(lastrow(cell2mat(lastrow)==results{i}),1);
        end
        results{i,2}=count;
    end