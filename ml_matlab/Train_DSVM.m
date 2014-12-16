function [svmstruct] = Train_DSVM(train_data,train_label)

% This function trains a multiclass dendogram-based support vector machine
% The details of the classifier are described in Lajnef et al.  and Benani et al.
% This function requires the number of classes to be greater than 2
%
%
% Inputs:
%   train_data: is a 1 by n cell vector that contains the training data correspanding to each class  
%   train_label: is a 1 by n cell vector that contains the training labels that correspand to each classe
%                (The labels should be positive numerical values) 
% Output: 
%   svmstruct: an n-1 by 1 cell vector which contains svmstructs resulting from the training phase
%
% Dependencies and requirements:
%   1)Bioinformatics matlab toolbox is needed in order to run this function  
%   2)linkage and svmtrain parameters can be modified inside this function.
%    
% Author: Tarek Lajnef
% Sfax National Engineering School (ENIS), LETI Lab, University of Sfax, Sfax, Tunisia
% Contact: lajnef.tarek@gmail.com
% Version 1.0 (12/2014)

[s] = size(train_label);
label=zeros(1,s(2));
for i=1:s(2)
label(i)=unique(train_label{i});
end
nb_class=length(label);

for i=1:nb_class
test(i,:)=mean(train_data{i});
end
% Dendogram generation 
Z = linkage(test,'single','correlation');

% SVM implementation and training at each node 
M=Z(:,1:2);
n=1;
A1=[];B1=[];C1=[]; Classes_label=cell(size(M));C=cell(1,4);Classes=cell(size(M));
A2=[];B2=[];C2=[];svmstruct=cell(nb_class-1,1);
for j=1:nb_class-1
   mat=M(j,:);
    if (mat(1)<=nb_class && mat(2)<=nb_class)
        C{n}=mat;
        Classes{n,1}=[train_data{mat(1)}];
        Classes{n,2}=train_data{mat(2)};
        Classes_label{n,1}=train_label{mat(1)};
        Classes_label{n,2}=train_label{mat(2)};
        svmstruct{n}=svmtrain([Classes{n,1};Classes{n,2}],[train_label{mat(1)};train_label{mat(2)}],'Showplot',false, 'Kernel_Function','rbf');
        n=n+1;
    elseif (mat(1)> nb_class && mat(2)> nb_class)
        cluster=mat(mat>nb_class)-nb_class;
        m1=C{cluster(1)};
        m12=C{cluster(2)};
        C{n}=[m1,m12];
       for h=1:length(m1)
         A1=[A1;train_label{m1(h)}];
         A2=[A2;train_data{m1(h)}];
       end
         Classes_label{n,1}=A1;
         Classes{n,1}=A2;
        for p=1:length(m12)
         B1=[B1;train_label{m12(p)}];
         B2=[B2;train_data{m12(p)}];
        end
       Classes_label{n,2}=B1;
       Classes{n,2}=B2;
       svmstruct{n}=svmtrain([Classes{n,1};Classes{n,2}],[-1*ones(length(Classes{n,1}),1);-2*ones(length(Classes{n,2}),1)],'Showplot',false, 'Kernel_Function','rbf');
        ordre(cluster(1))=-1;
        ordre(cluster(2))=-2;
       n=n+1; 
       B1=[];
       B2=[];
       A1=[];
       A2=[];
    else 
        cluster=mat(mat>nb_class)-nb_class;
        C{n}=[mat(mat<=nb_class),C{cluster}];
        m2=C{cluster};
        Classes_label{n,1}=[train_label{mat(mat<=nb_class)}];
        Classes{n,1}=train_data{mat(mat<=nb_class)};
         for h=1:length(m2)
         C1=[C1;train_label{m2(h)}];
         C2=[C2;train_data{m2(h)}];
         end
         Classes_label{n,2}=C1;
         Classes{n,2}=C2;
         svmstruct{n}=svmtrain([Classes{n,1};Classes{n,2}],[train_label{mat(mat<=nb_class)};-3*ones(length(Classes{n,2}),1)],'Showplot',false, 'Kernel_Function','rbf');
         n=n+1;
         C1=[];
         C2=[];
   end
end


end

