function [IntBlob]=IntImageBlob(Igr,sigma ,theta)
    %%%% Speed Up Process using Box Filters And Intergal Images %%%%

%%%% Transform RGB Image to Gray %%%
% I0=im2double ( I0 ) ;
% Igr=rgb2gray( I0) ; 
[Xmax,Ymax]=size(Igr); 

hsize=2*ceil(3*sigma)+1; 
%%% Box windows Sizes (Height, Length)%%%
Dxx_len=[4*floor(hsize/6)+1, 2*floor(hsize/6)+1];
Dxy_len=[2*floor(hsize/6)+1, 2*floor(hsize/6)+1];
Dyy_len=[2*floor(hsize/6)+1, 4*floor(hsize/6)+1];

%%% Image Zero - Padding %%%%
Igr=[zeros(Dxx_len(1),2*Dxx_len(1)+Ymax);zeros(Xmax,Dxx_len(1)) Igr zeros(Xmax,Dxx_len(1));zeros(Dxx_len(1),2*Dxx_len(1)+Ymax)];
[PadX,PadY]=size(Igr); 
%%%% 2.5.1 - Integral Image %%%%
IntIm1=integralImage(Igr) ; 
IntIm=IntIm1(2:PadX+1, 2:PadY+1);

%%%% 2.5.2 - Box Filters %%%%%

for i = 1: Xmax
    for j=1:Ymax
        %%% Dxx Box Filter Calculation %%%
        
        %%% X-axis Points Of Interest %%%%
        X_reg(1)=i+round(hsize/2)-floor (Dxx_len(1)/2); 
        X_end(1)=X_reg(1) + 2*floor(Dxx_len(1)/2);
        %%% Y-axis Points Of Interest %%%%
        Y_reg(1)=j+round(hsize/2)-floor(1.5*Dxx_len(2));
        Y_end(1)=j+round(hsize/2)-floor(Dxx_len(2)/2);
        
        %%%%%%%%% - Box 1 - %%%%%%%%%%%
        DxxSum1=IntIm(X_reg(1),Y_reg(1)) + IntIm(X_end(1),Y_end(1)-1) - IntIm(X_reg(1),Y_end(1)-1)-IntIm(X_end(1),Y_reg(1));
        DxxSum2=IntIm(X_reg(1),Y_end(1)) + IntIm(X_end(1),Y_end(1)+2*floor(Dxx_len(2)/2)) - IntIm(X_reg(1),Y_end(1)+2*floor(Dxx_len(2)/2)) - IntIm(X_end(1),Y_end(1));
        DxxSum3=IntIm(X_reg(1),Y_end(1)+2*floor(Dxx_len(2)/2)+1) + IntIm(X_end(1),Y_end(1)+2*floor(Dxx_len(2)/2)+Dxx_len(2)) - IntIm(X_reg(1),Y_end(1)+2*floor(Dxx_len(2)/2)+Dxx_len(2)) - IntIm(X_end(1), Y_end(1)+2*floor(Dxx_len(2)/2)+1);
        Lxx(i,j)=DxxSum1 - 2*DxxSum2 + DxxSum3;
        
        %%% Dyy Box Filter Calculation %%%
        
        %%% X-axis Points Of Interest %%%%
        X_reg(2)=i+round(hsize/2)-Dyy_len(1)- floor(Dyy_len(1)/2);
        X_end(2)=i+round(hsize/2)- floor(Dyy_len(1)/2) ;
        %%% Y-axis Points Of Interest %%%%
        Y_reg(2)=j+round(hsize/2)-floor(Dyy_len(2)/2);
        Y_end(2)=j+round(hsize/2)+floor(Dyy_len(2)/2);
               
        %%%%% - Box 2 - %%%%%%%%
        DyySum1=IntIm(X_reg(2), Y_reg(2)) + IntIm(X_end(2)-1 ,Y_end(2)) - IntIm(X_reg(2), Y_end(2)) - IntIm(X_end(2)-1, Y_reg(2));
        DyySum2=IntIm(X_end(2), Y_reg(2)) + IntIm(X_end(2)+2*floor(Dyy_len(1)/2),Y_end(2)) -IntIm(X_end(2),Y_end(2)) - IntIm(X_end(2)+2*floor(Dyy_len(1)/2),Y_reg(2));
        DyySum3=IntIm(X_end(2)+2*floor(Dyy_len(1)/2)+1, Y_reg(2)) + IntIm(X_end(2)+2*floor(Dyy_len(1)/2)+Dyy_len(1) ,Y_end(2)) - IntIm(X_end(2)+2*floor(Dyy_len(1)/2)+1, Y_end(2)) - IntIm(X_end(2)+2*floor(Dyy_len(1)/2)+Dyy_len(1), Y_reg(2));
        
        Lyy(i,j)=DyySum1-2*DyySum2 + DyySum3; 
        
       %%% Dxy Box Filter Calculation %%% 
       %%% X-axis Points Of Interest %%%%
       X_reg(3)=i+round(hsize/2)-Dxy_len(1); 
       X_end(3)=i+round(hsize/2);
       %%% Y-axis Points Of Interest %%%%
       Y_reg(3)=j+round(hsize/2)-Dxy_len(2);
       Y_end(3)=j+round(hsize/2);
       
       %%%%%% - Box 3 - %%%%%
       DxySum1=IntIm(X_reg(3), Y_reg(3))  + IntIm(X_end(3)-1,Y_end(3)-1) - IntIm(X_reg(3),Y_end(3)-1)-IntIm(X_end(3)-1,Y_reg(3));
       DxySum2=IntIm(X_reg(3), Y_end(3)+1)+ IntIm(X_end(3)-1,Y_end(3)+Dxy_len(2)) - IntIm(X_reg(3),Y_end(3)+Dxy_len(2))-IntIm(X_end(3)-1,Y_end(3)+1);
       DxySum3=IntIm(X_end(3)+1,Y_reg(3)) + IntIm(X_end(3)+Dxy_len(1),Y_end(3)-1) - IntIm(X_end(3)+1,Y_end(3)-1)-IntIm(X_end(3)+Dxy_len(1),Y_reg(3));
       DxySum4=IntIm(X_end(3)+1,Y_end(3)+1)+IntIm(X_end(3)+Dxy_len(1),Y_end(3)+Dxy_len(2)) - IntIm(X_end(3)+1,Y_end(3)+Dxy_len(2))-IntIm(X_end(3)+Dxy_len(1),Y_end(3)+1);
       
       Lxy(i,j)= DxySum1- DxySum2 - DxySum3+ DxySum4;
    
       %%% Edge Condition- Hessian Determinant- Harris Critiria %%%%
       R(i,j)=Lxx(i,j)*Lyy(i,j)-(0.9*Lxy(i,j))^2;
    end
end
  %%% Harris Dilation - Erosion Interest Points Conditions %%%
  Rmax=max(max(R));
  B_sq = strel('disk',hsize);
  Cond= and(( R==imdilate(R,B_sq) ) ,(R>theta*Rmax)); % Corner Pixels (x,y)
  [IntBlobX, IntBlobY]=find(Cond); % (X,Y) indicies for corner Pixels
  SigmaMatrix=repmat(sigma, length(IntBlobX),1);
  IntBlob=[IntBlobY, IntBlobX, SigmaMatrix]; %%return 

end