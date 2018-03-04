clear; clc;

% add path of detectors 
addpath(genpath('../detectors'));
addpath(genpath('../descriptors'));
%% Parameters %%
sigma=2;
rho = 2.5;
k = 0.05;
theta= 0.005;
N=4;
s = 1.5;
%%%%%% __________________3.1_Matching____________________%%%%%%%%%
%%%%%%%%%% SURF Descriptor %%%%%%%%
descriptor_func{1} = @(I,points) featuresSURF(I,points);
%%%%%%%%%% HOG Descriptor %%%%%%%%
descriptor_func{2} = @(I,points) featuresHOG(I,points);

%% Harris Corner Detection %%
%%% [Corn]= Harris(I0, sigma , rho , k , theta ) %%%%
detector_func = @(I)Harris(I, 2 , 2.5 , 0.05 , 0.005 );
%%%%%%%%%% SURF Descriptor %%%%%%%%
[scale_error{1}(1,:),theta_error{1}(1,:)] = evaluation(detector_func,descriptor_func{1});
%%%%%%%%%% HOG Descriptor %%%%%%%%
[scale_error{1}(2,:),theta_error{1}(2,:)] = evaluation(detector_func,descriptor_func{2});

%% Harris MultiScale Corner  Detection %%
%%% [MultiCorn]=MultiScaleCorner(I0, sigma ,N,s, rho , k , theta) %%%
detector_func = @(I)MultiScaleCorner(I, 2 , 4, 1.5 , 2.5 , 0.05 , 0.005 );
%%%%%%%%%% SURF Descriptor %%%%%%%%
[scale_error{2}(1,:),theta_error{2}(1,:)] = evaluation(detector_func,descriptor_func{1});
%%%%%%%%%% HOG Descriptor %%%%%%%%
[scale_error{2}(2,:),theta_error{2}(2,:)] = evaluation(detector_func,descriptor_func{2});

%% Blob Detection %%
%%% [Blob]= BlobDetection(I0,sigma,theta) %%%
detector_func = @(I)BlobDetection(I, 2 , 0.005 );
%%%%%%%%%% SURF Descriptor %%%%%%%%
[scale_error{3}(1,:),theta_error{3}(1,:)] = evaluation(detector_func,descriptor_func{1});
%%%%%%%%%% HOG Descriptor %%%%%%%%
[scale_error{3}(2,:),theta_error{3}(2,:)] = evaluation(detector_func,descriptor_func{2});

%% MultiScale Blob Detection %%
%%% MultiBlob= MultiScaleBlob(I0,N,sigma , s ,theta ) %%%
detector_func = @(I)MultiScaleBlob(I,4, 2, 1.5 , 0.005 );
%%%%%%%%%% SURF Descriptor %%%%%%%%
[scale_error{4}(1,:),theta_error{4}(1,:)] = evaluation(detector_func,descriptor_func{1});
%%%%%%%%%% HOG Descriptor %%%%%%%%
[scale_error{4}(2,:),theta_error{4}(2,:)] = evaluation(detector_func,descriptor_func{2});

%% MultiScale Detection Using Integral Images %%
%%% MutlitIntegralBlob=MultiScaleIntBlob(I0,N, sigma, s, theta) %%%
detector_func = @(I)MultiScaleIntBlob(I,4, 2, 1.5 , 0.005 );
%%%%%%%%%% SURF Descriptor %%%%%%%%
[scale_error{5}(1,:),theta_error{5}(1,:)] = evaluation(detector_func,descriptor_func{1});
%%%%%%%%%% HOG Descriptor %%%%%%%%
[scale_error{5}(2,:),theta_error{5}(2,:)] = evaluation(detector_func,descriptor_func{2});