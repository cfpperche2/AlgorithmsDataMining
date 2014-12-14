function create_draw_save_trees(filename)
%% function to draw six trees for each emotion, and save all trees in a cell array called 'treeArray'
%% for loop to generate tree from 1 to 6
for target=1:6
[example,y]=loaddata(filename);
new_y=y;
%% keep the target emotions, and set other targets to be 0
new_y(new_y ~= target) = 0;
new_y(new_y == target) = 1;
%% initialize the attributes array
attribs=(1:45);
%% get the tree by calling the 'decisiontree' function 
[tree] = decisiontree( example, attribs, new_y);
%% save each tree to the variable 'treeArray'
treeArray{target}=tree;
DrawDecisionTree(tree,target);
%% save the 'treeArray' in a mat file
save('treeArray.mat','treeArray');

end
