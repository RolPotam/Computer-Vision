clear all; clc; close all ; 
I0=imread('sunflowers17.png');
%I0=imread( 'matrix17.png');

%% Parameters %%
sigma=2; % Scaling Factor
r=2.5;   % Scaling Factor
k=0.05;  % Harris Criteria Factor
theta=0.005; %Theta Edge Corner
s=1.5;   % MultiScale Coefficient
N=4;     % Number of Scales (MultiScale Analysis)

%% Part 2.1 %%
%%%%% Harris Edge Detection %%%%%
[Corn]= Harris(I0, sigma , r , k, theta );

%%% Ploting %%%
figure('Name','Harris Edge Detection'); str1=['\bf \sigma =' , num2str(sigma)];
subplot(1,2,1); 
interest_points_visualization(I0, Corn); 
title({'Harris Detection',str1});
%% Part 2.2 %%
%%%% Harris - Laplacian Method %%%%
%%%% MultiScale Corner Detection %%
[MultiCorn]=MultiScaleCorner(I0, sigma ,N,s, r , k , theta);

%%% Ploting %%%
subplot(1,2,2); 
interest_points_visualization(I0, MultiCorn);
title({'MultiScale Harris Detection',['\bf \sigma (i)= ',num2str(sigma), '* s^i']});
print -djpeg HarrisDetection.jpg
%% Part 2.3 %%
%%%% Blob Detection %%%%%%
%%%% One Scale sigma=2 %%%
[Blob]= BlobDetection(I0,sigma,theta);

%%% Ploting %%%
figure('Name','Blob Detection') ;
subplot(1,2,1);
interest_points_visualization(I0, Blob);
title({'Blob Detection',str1});
%% Part 2.4 %%
%%%% Multi Scale Blob Detection %%% 
[MultiBlob]= MultiScaleBlob(I0,N,sigma , s ,theta ) ;

%%% Ploting %%%
subplot(1,2,2); 
interest_points_visualization(I0, MultiBlob);
title({'MultiScale Blob Detection',['\bf \sigma (i)= ',num2str(sigma), '* s^i']});
print -djpeg BlobDetection.jpg

%% Part 2.5 %%
%%%% Speed Up Process using Box Filters And Intergal Images %%%%
i=1; figure('Name','Integral Image Interest Points'); 
for sigma_n=sigma:2.5:10
    %%%% Points Of Interest Using Integral Images %%%%%
    [IntBlob]=IntImageBlob(I0,sigma_n ,theta);
    %%% Ploting %%%
    subplot(2,2,i);
    interest_points_visualization(I0, IntBlob);
    str3=['\bf \sigma= ',num2str(sigma_n)]; title(str3);
    i=i+1;
end
print -djpeg IntegralImage.jpg
%% Part 2.5 - Multiple Scales - Integral Image %%
%%%%% Multi-Scale Interest Points Detection using Box Filters & Integral Images %%%
[MutlitIntegralBlob]=MultiScaleIntBlob(I0,5,sigma, s, theta);

%%%% Ploting %%%%
figure('Name','MultiScale Integral Image Points'); 
interest_points_visualization(I0, MutlitIntegralBlob);
print -djpeg Multi_Int_flow.jpg