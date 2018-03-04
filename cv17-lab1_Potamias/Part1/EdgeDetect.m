function [EdgePoints]= EdgeDetect(I,sigma,theta,LaplacType) 
%%% sigma=Standar Deviation . 
%%% hsize=Filter Core . 
%%% Gh , Logh=Filter Impulse Response of Gaussian & Laplassian of Gaussian

[Xsize,Ysize]=size(I);

hsize=[2*ceil(3*sigma)+1] ;
%%%%% Structure Element %%%%  
B=strel('disk',1,8);
%%% Gausian Smoothing %%%
Gh=fspecial('gaussian', hsize, sigma);   
Is=imfilter(I,Gh);
%% Laplacian Calculation %% 
%%% Laplassian Smoothing %%%

if(LaplacType==1)
    LoGh=fspecial('log', hsize, sigma);
    %%%%% Linear Smoothing %%%%%
    L=imfilter(I,LoGh);   % Linear 
else
    %%%%% UnLinear Smoothing %%%  
    L=imdilate(Is,B)+imerode(Is,B)-2*Is;
end
%% Zero Crossing %%
%%%% Image Sign Detect %%%% 
X= (L>=0); 

%%%%% Image Perigram Detect %%%
Y=imdilate(X,B)-imerode(X,B);

%%%% Rejection Zerocrossing Smooth Points %%%
[Grad]=imgradient(Is);  % Gradient of Is
MaxGrad=max(max(Grad)); % Max Gradient 
EdgePoints=zeros([Xsize Ysize]); 

for (i=1:Xsize)
   for (j=1:Ysize)
       if (Y(i,j)==1) && (Grad(i,j)>theta*MaxGrad)
           EdgePoints(i,j)=1;
       end
   end
end


