clear all; close all; clc;
% Make training data of two classes "red" and "blue"
% with 2 features for each sample (the position  x and y).
angle = rand(200,1)*2*pi; 
l = rand(200,1)*40+30; 
blue = [sin(angle).*l cos(angle).*l];

angle = rand(200,1)*2*pi; 
l = rand(200,1)*40;    
red = [sin(angle).*l cos(angle).*l];

% All the training data
datafeatures = [blue;red];
dataclass(1:200) = -1; 
dataclass(201:400) = 1;

% Show the data
figure 
subplot(2,2,1)
hold on;
grid on
plot(blue(:,1),blue(:,2),'bo'); 
plot(red(:,1),red(:,2),'ro');
title('Training Data');

% Use Adaboost to make a classifier
[classestimate,model] = adaboost_eval('train',datafeatures,dataclass,50);

% Training results
% Show results
bad = (classestimate(:)~=dataclass(:));
blue = datafeatures(classestimate==-1,:); 
red = datafeatures(classestimate==1,:);
I = zeros(161,161);
for i=1:length(model)
  if(model(i).dimension==1)
      if(model(i).direction==1)
          rec = [-80 -80 80+model(i).threshold 160];
      else
          rec = [model(i).threshold -80 80-model(i).threshold 160 ];
      end
  else
      if(model(i).direction==1)
          rec = [-80 -80 160 80+model(i).threshold];
      else
          rec = [-80 model(i).threshold 160 80-model(i).threshold];
      end
  end
  rec = round(rec);
  y = rec(1)+81:rec(1)+81+rec(3); 
  x = rec(2)+81:rec(2)+81+rec(4);
  I = I-model(i).alpha; 
  I(x,y) = I(x,y)+2*model(i).alpha;    
end
subplot(2,2,2)
%imshow(I,[]); 
%colorbar; 
%colormap('jet')
hold on
grid on
plot(blue(:,1),blue(:,2),'bo');
plot(red(:,1),red(:,2),'ro');
plot(datafeatures((bad==1),1),datafeatures((bad==1),2),'kx');

title('Training Data classified with adaboost model');

% Show the error verus number of weak classifiers
error = zeros(1,length(model)); 
for i=1:length(model)
    error(i) = model(i).error; 
end 
subplot(2,2,3) 
plot(error); 
grid on
title('Classification error versus number of weak classifiers');

% Make some test data
angle = rand(200,1)*2*pi; 
l = rand(200,1)*70; 
testdata = [sin(angle).*l cos(angle).*l];

% Classify the testdata with the trained model
testclass = adaboost_eval('apply', testdata, model);

% Show result
blue = testdata(testclass==-1,:); 
red = testdata(testclass==1,:);

% Show the data
subplot(2,2,4)
hold on
grid on
plot(blue(:,1),blue(:,2),'bo');
plot(red(:,1),red(:,2),'ro');
title('Test Data classified with adaboost model');