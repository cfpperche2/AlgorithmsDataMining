classdef decisionnode < handle 
% DECISIONNODE is a handle class class that holds data model of a decision 
% node. Actual data is stored a the time objects are created via 
% constructor method.
%   External function calls the constructor method to create a decisionnode
%   object to hold specific dataset.

   properties
       col;     % col index of criteria (predictors) to be tested
       value;   % value of col to match for true/false test
       results; % stores possible results for this branch
       tb;      % 'true' branch holding another decisionnode object
       fb;      % 'false' branch holding another decisionnode object
   end

   methods
       % Constructor Method
       function self=decisionnode(col,value,results,tb,fb)
           if nargin <1
               self.col=-1;
               self.value={};
               self.results={};
               self.tb=[];
               self.fb=[];
           elseif nargin <2
               self.col=col;
               self.value={};
               self.results={};
               self.tb=[];
               self.fb=[];
           elseif nargin <3
               self.col=col;
               self.value=value;
               self.results={};
               self.tb=[];
               self.fb=[];
           elseif nargin <4
               self.col=col;
               self.value=value;
               self.results=results;
               self.tb=[];
               self.fb=[];
           elseif nargin <5
               self.col=col;
               self.value=value;
               self.results=results;
               self.tb=tb;
               self.fb=[];
           elseif nargin <6
               self.col=col;
               self.value=value;
               self.results=results;
               self.tb=tb;
               self.fb=fb;
           end
               
       end
   end
end 
