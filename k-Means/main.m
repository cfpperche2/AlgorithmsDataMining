%% (C) Copyright 2012. All rights reserved. Sotiris L Karavarsamis.
% Contact author at sokar@aiia.csd.auth.gr
% 
% This is an implementation of the k-means algorithm straight from the
% pseudocode description based on the book 'Introduction to Information
% Retrieval' by Manning, Schutze, Raghavan.
%{
Para simplificar a explicação de como o algoritmo funciona vou apresentar o algoritmo K-Means em cinco passos:

PASSO 01: Fornecer
valores para os centróides.

Neste passo os k centróides devem receber valores iniciais. No início do algoritmo geralmente escolhe-se os k primeiros pontos da tabela. Também é importante colocar todos os pontos em um centróide qualquer para que o algoritmo possa iniciar seu processamento.

PASSO 02: Gerar
uma matriz de distância entre cada ponto e os centróides.

Neste passo, a distância entre cada ponto e os centróides é calculada. A parte mais ‘pesada’ de cálculos ocorre neste passo pois se temos N pontos e k centróides teremos que calcular  N x k distâncias neste passo.

PASSO 03: Colocar
cada ponto nas classes de acordo com a sua distância do centróide
da classe.

Aqui, os pontos são classificados de acordo com sua distância dos centróides de cada classe. A classificação funciona assim: o centróide que está mais perto deste ponto vai ‘incorporá-lo’, ou seja, o ponto vai pertencer à classe representada pelo centróide que está mais perto do ponto. É importante dizer que o algoritmo termina se nenhum ponto ‘mudar’ de classe, ou seja, se nenhum ponto for ‘incorporado’ a uma classe diferente da que ele estava antes deste passo.

PASSO 04: Calcular
os novos centróides para cada classe.

Neste momento, os valores das coordenadas dos centróides são refinados. Para cada classe que possui mais de um ponto o novo valor dos centróides é calculado fazendo-se a média de cada atributo de todos os pontos que pertencem a esta classe.

PASSO 05: Repetir
até a convergência.

O algoritmo volta para o PASSO 02 repetindo iterativamente o refinamento do cálculo das coordenadas dos centróides.
%}

clc; close all; clear all;

%% ================= Part 1: Find Closest Centroids ====================
%  To help you implement K-Means, we have divided the learning algorithm 
%  into two functions -- findClosestCentroids and computeCentroids. In this
%  part, you shoudl complete the code in the findClosestCentroids function. 
%
fprintf('Finding closest centroids.\n\n');

% Settings for running K-Means
% Coefficients
C = [1 1];
% Samples
S = 1000;
% Centroids
K = 3; 
% Max iterations
max_iters = 10;

% Load an example dataset that we will be using
X = generateDataset(C,S);

% Run K-Means algorithm. The 'true' at the end tells our function to plot
% the progress of K-Means
[centroids, idx] = runKMeans(X, K, max_iters, true);
fprintf('\nK-Means Done.\n\n');
