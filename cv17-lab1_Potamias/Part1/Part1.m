%% Part 1.1 %%%
%%%% Read Image Normalize %%%
I0=imread('edgetest_17.png'); %Gray Image read
I0=im2double(I0);
%%%%% Kanonikopoisi Eikonas %%%%
Imax=max(max(I0));
I0=I0/Imax;

Imin=min(min(I0));

%%% Insert Image Noise %%% 
DI=Imax-Imin;
V1=DI/10; % PSNR=20
V2=DI/(sqrt(10)); %PSNR=10  
J1=imnoise(I0,'gaussian',0,V1.^2);
J2=imnoise(I0,'gaussian',0,V2.^2);
display(V1 , 'Standar Deviation for PSNR=20dB');
display(V2 , 'Standar Deviation for PSNR=10dB');


%% 1.2 Edge Points Estimating%% 
sigma= 1.5;
theta=0.2;
%%%% To change to PSNR=10dB uncomment %%%%
%%% Gaussian Filter %%%%
% [EdgePoints1]= EdgeDetect(J2,sigma,theta,1);
%%%% Laplacian of Gaussian Filter %%%%
% [EdgePoints2]= EdgeDetect(J2,sigma,theta,2);

%%% Gaussian Filter %%%%
[EdgePoints1]= EdgeDetect(J1,sigma,theta,1);
%%%% Laplacian of Gaussian Filter %%%%
[EdgePoints2]= EdgeDetect(J1,sigma,theta,2);

%% 1.3 Real Edge Points %%%
[RealEdgePoints]=RealEdgeDetect(I0,theta);

%%% 1.3.2 Results Precision %%%%
C1=Precision(EdgePoints1,RealEdgePoints); 
C2=Precision(EdgePoints2,RealEdgePoints); 

%%%%%% PLOTING %%%%%%%%%

% subplot(2,2,1);
% imshow(J1); title('Noise PSNR=20dB');
subplot(2,2,1) 
imshow(J2); title('Noise PSNR=10dB');

str2=['Precision= ', num2str(C1)];
subplot(2,2,3); imshow(EdgePoints1); title({'Edge Detect Gaussian Filter';str2});
str2=['Precision= ', num2str(C2)];
subplot(2,2,4); imshow(EdgePoints2); title({'Edge Detect Laplassian of Gaussian Filter';str2}); 
subplot(2,2,2); imshow(RealEdgePoints); title('Real Edge Points');

display(0.5*(C1+C2) , 'Average Edge Detection Precision ');

suptitle({['\sigma = ', num2str(sigma) ];['\theta = ' , num2str(theta)]}) ;


