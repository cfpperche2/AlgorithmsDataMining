function variance=variance(rows)
% Variance calculates statistical variance for a set of rows

    if size(rows, 2)==0
        variance=0;
    else
        data=cell2mat(rows(:,end));
        mean=sum(data)/size(data,1);
        variance=sum((data-mean).^2)/size(data,1);
    end