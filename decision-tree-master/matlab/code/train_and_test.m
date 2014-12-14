function [confusionMatrix,recall,precision] = train_and_test(training_sample,test_sample,class,actual_class)
%% create all 6 trained trees and store in an array 'treeArrays' 
for index = 1:6
	treeArrays{index} = getEachTree(training_sample,class,index) ; 
end


testSet= test_sample;
actualClass= actual_class;

%% this function takes treeArray  (containing all six trees) and feature x 
%% and return a vector of label predictions in the format of loaddata.
%% 'predictedResult' has 6 columns for each tree 
predictedResult = testTrees(treeArrays,testSet) ;



%% strategy towards ambiguity
%% In each row which represents one training example
%% check if the row is all zeros or there are more than one '1' value

for i= 1:10
    %% check whether all are zeros in the row
    %% if so, randomly choose one column to fill 1
    if ((min(predictedResult(i,:))==max(predictedResult(i,:)))&&min(predictedResult(i,:))==0)
        first_random=randperm(6);
        predictedResult(i,first_random(1))=1;
    end
    %% check if more than one '1' values on the same row
    %% if so, randomly pick one column from them, fill the row all with zeros, then fill that
    %% particular column with '1'
    if (size(find(predictedResult(i,:)),2)>1)
        
        picked_column=find(predictedResult( i,:));
        random_value=randperm(size(find(predictedResult(i,:)),2));
        predictedResult(i,:)=[0 0 0 0 0 0];
        predictedResult(i,picked_column(random_value(1))) =1;
    end
end







%% producing the confusionMatrix from the predictedresult 

confusionMatrix = zeros(6,6) ;
precision_recall=zeros(1,12);
for n = 1:6
	oneColumn = predictedResult(:,n) ;
	for j = 1:size(oneColumn,1)
		if ( (actualClass(j) == n) && (oneColumn(j) == 1) )
			confusionMatrix(n,n) = confusionMatrix(n,n) + 1 ; %increment by 1 
		elseif ( (actualClass(j) ~= n) && (oneColumn(j) == 1) )
			confusionMatrix(actualClass(j),n) = confusionMatrix(actualClass(j),n) + 1 ;

			
		end
		
	end
end

%% producing recall and precision
for n = 1:6
    sumvector=sum(confusionMatrix,2);
    recall(1,n)=confusionMatrix(n,n)/sumvector(n);
    sumvector=sum(confusionMatrix,1);
    precision(1,n)=confusionMatrix(n,n)/sumvector(n);
end



%%  subfunction to get the tree
function [tree] = getEachTree(training_sample,class,target)

new_y=class;
new_y(new_y ~= target) = 0;
new_y(new_y == target) = 1;

attribs=(1:45);
[tree] = decisiontree( training_sample, attribs, new_y);
end
%
%
%% subfunction to get the predicted result
function [SixPredictedClasses] = testTrees(treeArrays,testSet) 
SixPredictedClasses=[];
for count = 1:6
	% process one tree by one tree from 6 trees
	eachTrainedTree = treeArrays{count} ;
	
	% each tree tested with one test set produces 'predictedLabels' array
	predictedLabels = testSamples(testSet,eachTrainedTree) ;
	
	% SixPredictedClasses is 2D array which has 6 columns
	SixPredictedClasses = [SixPredictedClasses,predictedLabels];
    
    
end
end

%
% 
%

function [arrayClassResult] = testSamples(sampleSet,tree)
%return an array with predicted class
%this function results shall be compared to actual class from y feature of loaddata
 
%find out the size of sampleSet
[sampleSizeRows,sampleSizeColumns] = size(sampleSet) ;

%to avoid expanding array, the last element is initialized with 0
%%arrayClassResult(sampleSizeRows) = 0 ;
 arrayClassResult=zeros(10,1);
for rowIndex = 1:sampleSizeRows
	% create new matrix 'eachRow' representing row vector (1x45)
	eachRow = sampleSet(rowIndex,:) ;
	arrayClassResult(rowIndex,1) = testOneExample(eachRow,tree) ;	
end
% END OF FUNCTION
end


% THIS FUNCTION WILL TEST EACH LINE OF EXAMPLES FROM A SAMPLE
% RECURSIVE
function [predictedClass] = testOneExample(oneExample,tree)

if (~isempty(tree.class)) % 'not empty' means that it is a leaf node
	predictedClass = tree.class ;
else 
	valueOfThisNode = oneExample(tree.op) ; %get index for oneExample by extracting from root node tree.op attribute
	leftSubtree  = tree.kids{1} ;
	rightSubtree = tree.kids{2} ;

	if (valueOfThisNode == 0)
		predictedClass = testOneExample(oneExample,leftSubtree) ;
	else 
		predictedClass = testOneExample(oneExample,rightSubtree) ;
	end 

end
end

end
