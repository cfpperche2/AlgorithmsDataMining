function drawtree(tree,drawtitle)
% Graphycally displays a decision tree object created by buildtree function

    % Validate input arguments
    if nargin <2
        drawtitle='Decision Tree';
    end

    w=getwidth(tree)*100+120;
    h=getdepth(tree)*100+120;
    
    figure1 = figure('Name','Fig-1');
    axes('Parent',figure1);
    xlim([0 w]);
    ylim([0 h]);
    hold('all');
    title(drawtitle);
    drawnode(tree,w/2,h-20)
end

function w=getwidth(tree)
% Returns the width of the tree

    % The total width of a branch is the combined width of its child
    % branches, or 1 if it has none.
    if isempty(tree.tb) && isempty(tree.fb)
        w=1;
    else
        w=getwidth(tree.tb)+getwidth(tree.fb);
    end
end

function h=getdepth(tree)
% Returns the height of the tree

    % The depth of a branch is 1 plus the total depth of its longest child
    % branch.
    if isempty(tree.tb) && isempty(tree.fb)
        h=0;
    else
        h=max(getdepth(tree.tb),getdepth(tree.fb))+1;
    end
end

function drawnode(tree,x,y)
    if isempty(tree.results)
        % Get the width of each branch
        w1=getwidth(tree.fb)*100;
        w2=getwidth(tree.tb)*100;
        
        % Determine the total space required by this node
        left=x-(w1+w2)/2;
        right=x+(w1+w2)/2;
        
        % Draw the condition string
        if ischar(tree.value)
            text(x-20,y-10,sprintf('%d:%s?',tree.col,tree.value));
        else
            text(x-20,y-10,sprintf('%d:%d?',tree.col,tree.value));
        end
        
        % Draw links to the branches
        line([x,left+w1/2],[y-20,y-120]);
        line([x,right-w2/2],[y-20,y-120]);
        
        % Draw the branch nodes
        drawnode(tree.fb,left+w1/2,y-100);
        drawnode(tree.tb,right-w2/2,y-100);
    else
        if ischar(tree.results{1,1})
            txt=sprintf('\n\n''%s'':%d',tree.results{1,1},tree.results{1,2});
        else
            txt=sprintf('\n\n''%d'':%d',tree.results{1,1},tree.results{1,2});
        end
        text(x-20,y,txt);
    end
end
