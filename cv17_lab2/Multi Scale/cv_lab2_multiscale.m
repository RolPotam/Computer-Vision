clear all; close all ; 
clc; 
tic

epsilon=0.06;
rho=2.2;
%% Part 1 
%%%% Skin Samples to Y-Cb-Cr %%%%
load('skinSamplesRGB');
skinCbCr=im2double(rgb2ycbcr(skinSamplesRGB));
SkinCb=reshape(skinCbCr(:,:,2),1,[]);
SkinCr=reshape(skinCbCr(:,:,3),1,[]);

%%%% Mean And Covariance Calculation %%%%%
meanSkin(:,1)=mean(SkinCb);
meanSkin(:,2)=mean(SkinCr);
covSkin=cov(SkinCb,SkinCr);

%%%% Add test-frames to path %%%%
addpath(genpath('/Users/mac/Desktop/ECE/Computer Vision/cv17_lab2_Potamias_03114437/GreekSignLanguage/GSLframes'));
%%% Gaussian Propability based on Skin Samples %%%
testImage=im2double(rgb2ycbcr(imread('1.png')));
%% Bounding Box
Box = fd(testImage, meanSkin ,covSkin);
% figure;  
% hold on;
% imshow('1.png');
% rectangle('Position',[Box(1),Box(2),Box(3),Box(4)],'EdgeColor','r');
% title( '1st Frame Bounding Box');
% hold off

%% Part 2 
%% Multi- Scale Lukas Kanade
ScaleNum= 3; 
pixel=3;
mu=ceil(3*pixel)*2+1;
Gauss_m=fspecial('gaussian',mu,pixel);
I1= testImage(round(Box(2)):round(Box(2)+Box(4)),round(Box(1)):round(Box(1)+Box(3)));
I1= pyramid_resize (I1 , Gauss_m , ScaleNum);
x=Box(1);
y=Box(2);
w=Box(3);
h=Box(4);

for i=2:72
    Istr=int2str(i);
    ImName=strcat(Istr,'.png');
    subplot(1,3,1); 
    testImage=im2double(rgb2gray(imread(ImName)));
    I2 = testImage(round(y):round(y+h),round(x):round(x+w));
    imshow(I2); title('Current Head Region');
    d_x0=0;
    d_y0=0;
    I2 = pyramid_resize(I2, Gauss_m , ScaleNum);
    [d_x, d_y]=lk_multiscale(I1,I2, rho, epsilon, ScaleNum ,d_x0,d_y0);
    [disp_x, disp_y]=displ(d_x,d_y); 
    
    subplot(1,3,2); 
    imshow(ImName); hold on;
    x=x-disp_x;
    y=y-disp_y;
    
    rectangle('Position',[x,y,w,h],'EdgeColor','g', 'LineWidth', 2);
    title('Bounding Box');
    % Save Images 
    print  ([ 'frame', num2str(i), '.jpeg'] , '-djpeg');
    hold off;
    pause(0.01);
    I1=I2; %% Move to next Image 
end
toc