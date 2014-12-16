function [Class_test] = Classify_DSVM(test_data,label,svmstruct)

% This function classifies the test_data using a dendogram-based svm  
%
% Inputs: 
%
%    test_data: an m by p matrix that contains the data to be classified 
%    label: is an n by 1 vector containing label of n classes, example label =[0 1 2 3 4]
%    (Note that the labels have to be numerical values) 
%    svmstruct: an n-1 by 1 cell vector which contains svmstructs, which are the result
%    of the training phase (obtained with the function Train_DSVM)
%
% Output:
%
%    Class_test: is a 1 by m vector containing labels of the classified data
%
% Example: Training and classification using fisheriris data
%
%             load fisheriris
%             train_label={zeros(30,1),ones(30,1),2*ones(30,1)};
%             train_cell={meas(1:30,:),meas(51:80,:),meas(101:130,:)};
%             [svmstruct] = Train_DSVM(train_cell,train_label);
%             label=[0 1 2];
%             [Class_test] = Classify_DSVM(meas(31:50,:),label,svmstruct);
%
% Author: Tarek Lajnef
% Sfax National Engineering School (ENIS), LETI Lab, University of Sfax, Sfax, Tunisia
% Contact: lajnef.tarek@gmail.com
% Version 1.0 (12/2014)

[lg]=size(test_data);
Class_test=zeros(1,lg(1));
for i=1:lg(1)
test=test_data(i,:);
cond=length(svmstruct);
while cond>=1
    class_x=svmclassify(svmstruct{cond,1},test);
    if (ismember(class_x,label))
        Class_test(i)=class_x;
        cond=1;
    elseif (class_x==-1 || class_x==-2)
        indx=find(ordre==class_x);
        class_x=svmclassify(svmstruct{indx,1},test);
        if ismember(class_x,label);
        Class_test(i)=class_x;
        cond=1;
        end    
    end
    cond=cond-1;
end
end
end

