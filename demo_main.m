%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main demo function for MICI two-class classifier fusion
%
%  This file is the demo code on noisy-or model, min-max model, and generalized-mean model.
%  Also include the noisy-or model code with updated ME optimization method 
%   (i.e. the measures are updated according to measure element usage count. Details please see related publications.)
%
%
% Written by: X. Du
% Latest revision: March 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Demo: load a demo 3-source data

disp('This demo takes approximately 20 seconds.')
prompt = 'Running this code will clear your workspace.Would you like to continue?[Y/n]';
str = input(prompt,'s');
if (str=='N') || (str=='n')
    ;
elseif (str=='Y') || (str=='y')
    
clear;close all;clc
addpath('util')

%%%%%%% If no mex file existed in the ./util folder, run the following two lines to compile mex file %%%%%%%
% mex computeci.c
% mex ismember_findrow_mex.c

%%  Two-class classifier Fusion demo
load('demo_data_cl.mat');

%%%%%%%  Training Stage: Learn measures given training Bags and Labels
[Parameters] = learnCIMeasureParams(); %user-set parameters
[measure_noisyor, initialMeasure_noisyor,Analysis_noisyor] = learnCIMeasure_noisyor(Bags, Labels, Parameters);%noisy-or model
[measure_noisyor_ME, initialMeasure_noisyor_ME,Analysis_noisyor_ME] = learnCIMeasure_noisyor_CountME1(Bags, Labels, Parameters); %noisy-or model, ME optimization
[measure_minmax, initialMeasure_minmax,Analysis_minmax] = learnCIMeasure_minmax(Bags, Labels, Parameters); %min-max model
[measure_genmean, initialMeasure_genmean,Analysis_genmean] = learnCIMeasure_softmax(Bags, Labels, Parameters); %generalized-mean model

%%%%%%%  Testing Stage: Given the learned measures above, compute fusion results
Ytrue = computeci(Bags,gtrue);  %true label
Yestimate_noisyor = computeci(Bags,measure_noisyor);  % learned measure by MICI noisy-or model
Yestimate_noisyor_ME = computeci(Bags,measure_noisyor_ME);% learned measure by MICI noisy-or model, with ME optimization
Yestimate_minmax = computeci(Bags,measure_minmax);  % learned measure by MICI min-max model
Yestimate_genmean = computeci(Bags,measure_genmean);  % learned measure by MICI generalized-mean model

%%%%%%% Plot true and estimated labels
figure(101);
subplot(1,2,1);scatter(X(:,1),X(:,2),[],Ytrue);title('True Labels');
subplot(1,2,2);scatter(X(:,1),X(:,2),[],Yestimate_noisyor);title('Fusion result: MICI noisy-or')

figure(102);
subplot(1,2,1);scatter(X(:,1),X(:,2),[],Ytrue);title('True Labels');
subplot(1,2,2);scatter(X(:,1),X(:,2),[],Yestimate_noisyor_ME);title('Fusion result: MICI noisy-or (ME)')

figure(103);
subplot(1,2,1);scatter(X(:,1),X(:,2),[],Ytrue);title('True Labels');
subplot(1,2,2);scatter(X(:,1),X(:,2),[],Yestimate_minmax);title('Fusion result: MICI min-max')

figure(104);
subplot(1,2,1);scatter(X(:,1),X(:,2),[],Ytrue);title('True Labels');
subplot(1,2,2);scatter(X(:,1),X(:,2),[],Yestimate_genmean);title('Fusion result: MICI generalized-mean')


%%  Regression demo

%%%%%%%  Training Stage: learn measure given InputBags and InputLabels
[Parameters] = learnCIMeasureParams();
[measure_reg, initialMeasure_reg,Analysis_reg] = learnCIMeasure_regression(Bags, Labels, Parameters);

%%%%%%%  Testing Stage:  Given the learned measures above, compute fusion results
Ytrue = computeci(Bags,gtrue);  %true label
Yestimate_reg = computeci(Bags,measure_reg);  % learned measure by MICI

%%%%%%% Plot true and estimated labels
figure(105);
subplot(1,2,1);scatter(X(:,1),X(:,2),[],Ytrue);title('True Labels');
subplot(1,2,2);scatter(X(:,1),X(:,2),[],Yestimate_reg);title('MICIR Fusion results')



end
