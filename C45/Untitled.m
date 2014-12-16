clear all; close all; clc;
load fisheriris
 X_train = meas;
 Y_train = grp2idx(species);
 
classes=3;

 %% EM
tic
em = gmdistribution.fit(X_train,classes);
toc
grupo = cluster(em,X_train);
grupo2 = grupo;
m = confusionmat(Y_train,grupo);
% Faz a compatibilidade das classes e dos numeros
for n=1:size(m,1)
   [~,b] = max(m(:,n));
   grupo(find(grupo2 == n)) = b; 
end
m = confusionmat(Y_train,grupo) %Matriz onde a linha é o numero da classe onde pertence de verdade e a coluna e o numero da classe onde foi classificada
total = sum(sum(m));
certo = sum(diag(m));
disp('Acerto:')
p = certo/total
 
 
%% C4.5
tic
tree = ClassificationTree.fit(X_train,Y_train,'SplitCriterion','deviance');
toc
m = confusionmat(Y_train,tree.predict(X_train))
total = sum(sum(m));
certo = sum(diag(m));
disp('Acerto:')
p = certo/total
disp('Critérios:')
tree.view
    
%% CART
clear tree;
tic
tree = ClassificationTree.fit(X_train,Y_train);
toc
m = confusionmat(Y_train,tree.predict(X_train))
total = sum(sum(m))
certo = sum(diag(m))
disp('Acerto:')
p = certo/total
disp('Critérios:')
tree.view