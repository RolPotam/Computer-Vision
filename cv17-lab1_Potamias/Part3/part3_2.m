clear all; close all; clc;
% add path of detectors, libsvm, descriptor 

addpath(genpath('libsvm-3.17'));
addpath(genpath('../detectors'));
addpath(genpath('../descriptors'));
addpath(genpath('../matching'));
addpath(genpath('../classification'));

%% Part 3.2.1 %%% 
%%%%%%%%%% SURF Descriptor %%%%%%%%
descriptor_func{1} = @(I,points) featuresSURF(I,points);
%%%%%%%%%% HOG Descriptor %%%%%%%%
descriptor_func{2} = @(I,points) featuresHOG(I,points);

%% Harris MultiScale Corner  Detection %%
%%% [MultiCorn]=MultiScaleCorner(I0, sigma ,N,s, rho , k , theta) %%%
detector_func{1} = @(I)MultiScaleCorner(I, 2 , 4, 1.5 , 2.5 , 0.05 , 0.005 );
%% MultiScale Blob Detection %%
%%% MultiBlob= MultiScaleBlob(I0,N,sigma , s ,theta ) %%%
detector_func{2} = @(I)MultiScaleBlob(I,4, 2, 1.5 , 0.005 );
%% MultiScale Detection Using Integral Images %%
%%% MutlitIntegralBlob=MultiScaleIntBlob(I0,N, sigma, s, theta) %%%
detector_func{3} = @(I)MultiScaleIntBlob(I,4, 2, 1.5 , 0.005 );
%% Part 3.2.1 - Feature Extraction %% 
for i=1:3
    %%% Feature Extractrion - Descriptor HOG%%%
    [FeatExt{i}]=FeatureExtraction(detector_func{i},descriptor_func{2});
        %%% Uncomment to change Descriptor %%%
%     %%% Feature Extractrion - Descriptor SURF%%%
%     [FeatExt{i}]=FeatureExtraction(detector_func{i},descriptor_func{1});

    for k=1:5   
        %%% Split Images to Train and Test %%%
        [train,label_train,test,label_test]=createTrainTest(FeatExt{i},k);
         %% Bag of Words
        [BOF_tr,BOF_ts]=BagOfWords(train,test);
         %% SVM classification
        [Press{i}(k,:),KMea] = svm(BOF_tr,label_train,BOF_ts,label_test);
        fprintf('Classification Accuracy: %f %%\n',Press{i}(k,:)*100);
    end
    fprintf('Starting New Feature Extraction Using other Detector ..... \n ' ) ;
end
