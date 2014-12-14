function [ tree ] = decisiontree( example, attribs, new_y)
%% Follow ID3 algorithm to set up a tree 
%% if examples have same label
if max(new_y) == min(new_y)
    tree.op=[];
    tree.kids=[];
    tree.class=new_y(1);
    return

%% else if run out of attribute
elseif isempty(attribs)
    tree.op=[];
    tree.kids=[];
    tree.class=majority_value(new_y);
    return
   
    
else
     best_index= choose_best_attribute(example, new_y);
    tree.op=attribs(best_index);
    tree.class=[];
    for vi=0:1
       
        best_index= choose_best_attribute(example, new_y);
        index=find(example(:,best_index)==vi);
        if isempty(index)
            tree.kids{vi+1}.op=[];
            tree.kids{vi+1}.kids=[];
            %% vi = 0 :1 , vi+1 =1 :2,  tree.kids index should be 1 and 2 
            tree.kids{vi+1}.class=majority_value(new_y);
        else
            
            example_new = [];
            new_new_y = [];
            for ii=1:size(index,1)
                    example_new=[example_new; example(index(ii),:)];
                    new_new_y = [new_new_y;new_y(index(ii),:)];
            end
            example_new(:,best_index)=[];
            new_attribs=attribs;
            new_attribs(best_index)=[];
          
            tree.kids{vi+1}=decisiontree(example_new,new_attribs,new_new_y);
        end
     end
end
    




end

%% find the majority in new_y(either 0 or 1)
function [most_label] = majority_value(new_y)
pos_num = size(find(new_y),1);
if (size(new_y,1) - 2*pos_num) >= 0
    most_label = '0';
    return 
else
    most_label = '1';
    return
end

end

%% find the best attribute with highest information gain
function [best_att_ind] = choose_best_attribute(example, new_y)
attributes = zeros(size(example,1),2,size(example,2));
for att_ind = 1:size(example,2)
    attributes(:,:,att_ind) = [example(:,att_ind) new_y];
    IG(att_ind,1) = cal_ig(attributes(:,:,att_ind));
end

[m,best_att_ind] = max(IG);
end

%% find IG for corresponding attribute
function [IG] = cal_ig(attributes)
p_pos = find(attributes(:,1));
n_pos = find(attributes(:,1) == 0);
p_attr_set = zeros(size(p_pos,1),2);
n_attr_set = zeros(size(n_pos,1),2);

for i=1:size(p_pos,1)
    p_attr_set(i,:) = attributes(p_pos(i),:);
end
for i=1:size(n_pos,1)
    n_attr_set(i,:) = attributes(n_pos(i),:);
end
if isempty(p_pos) || isempty(n_pos)
    Remainder = cal_entropy(attributes);
else
    Remainder = (size(p_attr_set,1)/size(attributes,1))*cal_entropy(p_attr_set) ...
            + (size(n_attr_set,1)/size(attributes,1))*cal_entropy(n_attr_set);
end

IG = cal_entropy(attributes) - Remainder;

end

%% calculate entropy
function [entropy] = cal_entropy(train_set)

p_label_ind = find(train_set(:,2) == 1);
n_label_ind = find(train_set(:,2) == 0);
p_label = size(p_label_ind,1);
n_label = size(n_label_ind,1);


if p_label == 0 || n_label ==0
    entropy = 0;
else
    entropy = -(p_label/(p_label+n_label))*log2(p_label/(p_label+n_label)) ...
              - (n_label/(p_label+n_label))*log2(n_label/(p_label+n_label));
end
end
