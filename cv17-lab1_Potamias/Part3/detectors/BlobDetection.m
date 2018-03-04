function [Blob]= BlobDetection(I0,sigma,theta)    
%%% Blobs Detection %%%
    hsizes=[2*ceil(3*sigma)+1,2*ceil(3*sigma)+1] ;
    Ghs=fspecial('gaussian', hsizes, sigma);
    %%%%% Gradient Is %%%%%
%     I0=im2double(I0);
%     Igr=rgb2gray(I0);
Igr=I0;
    [Xmax,Ymax]=size(Igr);

    
    %%%%% 2.3.1 - Hessian Matrix Calculation %%%%%
    for x=1:Xmax
        for y=1:Ymax
            %%% Gaussian Filter %%%%
            f(x,y)=(exp(-(x-Xmax/2)^2/(2*sigma^2)-(y-Ymax/2)^2/(2*sigma^2)))/(2*pi*sigma^2);
            %%% Gaussian Derivatives  %%%
            Dxx(x,y)=(((x-Xmax/2)^2/sigma^2 -1)*f(x,y))/sigma^2;
            Dyy(x,y)=(((y-Ymax/2)^2/sigma^2 -1)*f(x,y))/sigma^2;
            Dxy(x,y)=((x-Xmax/2)*(y-Ymax/2))/(sigma^4)*f(x,y);
        end
    end
    %%% 2.3.1 - Hessian Determinant %%%
     Lxx=imfilter(Igr,Dxx);
     Lxy=imfilter(Igr,Dxy);
     Lyy=imfilter(Igr,Dyy);
     R=Lxx.*Lyy-Lxy.^2;

%%%% 2.3.1 - Classic Way %%%% 
    % [Isdx, Isdy] = gradient(Is);
    % [Isdx2, Isdxdy] = gradient(Isdx);
    % [Isdydx, Isdy2] = gradient(Isdy);
    % R = Isdx2.*Isdy2 - Isdxdy.*Isdydx;
    
%%%%% 2.3.2 - Blob Points Calculation %%%%%
    Rmax=max(max(R));
    ns = ceil(3*sigma)*2+1;
    B_sq = strel('disk',ns);
    Cond= and(( R==imdilate(R,B_sq) ) ,(R>theta*Rmax)); % Corner Pixels (x,y)
    [BlobX, BlobY]=find(Cond); % (X,Y) indicies for corner Pixels
    SigmaMatrix=repmat(sigma, length(BlobX),1);
    Blob=[BlobY, BlobX, SigmaMatrix];

end
    