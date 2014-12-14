function set=divideset(rows,column,value)
% Divides a set on a specific column. Can handle numeric or nominal values.
% Make a function that tells us if a row is in the first group (true) or
% the second group (false)
    if isinteger(value) || isfloat(value)
        split_function=@(row) rows{row,column}>=value;
    else
        split_function=@(row) strcmp(rows{row,column},value);
    end
    
    set=cell(1,2);
    for i=1:size(rows,1)
        if split_function(i)
            set{1,1}=[set{1,1}; rows(i,:)];
        else
            set{1,2}=[set{1,2};rows(i,:)];
        end
    end

