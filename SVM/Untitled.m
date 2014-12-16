%load iris data
load fisheriris;
data=meas;

%prepare test set and training set
trainset=[data(1:20,:);data(51:70,:);data(101:120,:)];
testset=[data(21:50,:);data(71:100,:);data(121:150,:)];

%prepare class label for first run of svm
class=zeros(60,1);
class(1:20,1)=1;
class(21:60,1)=2;

%perform first run of svm
SVMStruct = svmtrain(trainset,class);
Group = svmclassify(SVMStruct,testset);

%prepare class label for second run of svm
class1=zeros(60,1);
class1(1:40,1)=1;
class1(41:60,1)=2;

%perform second run of svm
SVMStruct1 = svmtrain(trainset,class1);
Group1 = svmclassify(SVMStruct1,testset);

%prepare final class label
GroupF=zeros(90,1);
for i=1:90
    if Group(i,1)==1
        GroupF(i,1)=1;
    else
        if Group1(i,1)==2
            GroupF(i,1)=2;
        else
            GroupF(i,1)=3;
        end
    end
end

%Final class label
GroupF