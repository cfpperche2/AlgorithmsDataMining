clc; clear; close all;

load fisheriris
X = meas;
Y = species;

% Numero de dados treinados, pode variar de 1 ate o tamanho maximo de X
dadosTreinados = 150;

% Variaveis auxiliares
acertoTotalTemp = [];
acertoLinha = [];
erroTotalTemp = [];
erroLinha = [];


% Laco para gerar os erros do algoritmo variando o numero de dados
% treinados de 1 ate n
for i = 1:dadosTreinados
    tic;
    ens = fitensemble(X,Y,'AdaBoostM2',i,'Tree');
    tempo(i) = toc;
    [numClasses,~] = size(ens.ClassNames);
    m = confusionmat(Y,ens.predict(X));
%     disp(m);
    [linha,coluna] = size(m);
        for ii = 1:linha
           for jj = 1:coluna
               if ii == jj
                  acertoTemp = m(ii,jj);
               end 
           end
           acertoLinha = horzcat(acertoLinha,acertoTemp);
           erroTemp = ens.NumObservations/numClasses - acertoTemp;
           erroLinha = horzcat(erroLinha,erroTemp);
        end
        acertoTotalTemp = vertcat(acertoTotalTemp,acertoLinha);
        erroTotalTemp = vertcat(erroTotalTemp,erroLinha);
        acertoLinha = []; erroLinha = [];
end

% Soma dos erros de cada iteracao, de 1 ate n
somaErros = sum(erroTotalTemp');
% soma dos acerto de cada iteracao, de 1 ate n
somaAcertos = sum(acertoTotalTemp');   

[tamanho,~] = size(X);
totalDados = tamanho * dadosTreinados;
totalErros = sum(somaErros);
totalAcertos = sum(somaAcertos);
porcentagemErros = 100 * totalErros/totalDados; 
porcentagemAcertos = 100 * totalAcertos/totalDados;
% Tempo em segundos
tempoTotal = (sum(tempo)/60);

% Display dos resultados
disp('###Resultado###');
fprintf (' Total de dados = %d \n',totalDados);
fprintf (' Total de erros = %d \n',totalErros);
fprintf (' Total de acertos = %d \n',totalAcertos);
fprintf (' Porcentagem de erros = %f porcento\n',porcentagemErros);
fprintf (' Porcentagem de acertos = %f porcento\n',porcentagemAcertos);
fprintf ('Tempo Total =')
disp(tempoTotal);



plot(1:dadosTreinados,somaErros,'r');
title('Erros Adaboost');
ylabel('Total de Erros');
xlabel('Conjunto de Treinamento');
grid on;
