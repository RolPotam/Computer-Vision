function [Corn]= Harris(I0, sigma , rho , k , theta )
    hsizes=[2*ceil(3*sigma)+1,2*ceil(3*sigma)+1] ;
    hsizer=[2*ceil(3*rho)+1,2*ceil(3*rho)+1] ;
    Ghr=fspecial('gaussian', hsizer,rho);
    Ghs=fspecial('gaussian', hsizes, sigma);

    %%%%% Gradient Is %%%%%
   % I0=im2double(I0);
   % Igr=rgb2gray(I0);
    Igr=I0;
    Is=imfilter(Igr,Ghs);
    [GradX, GradY]=gradient(Is);

    %%%%% 2.1.1 - J Vector %%%%%
    J1=imfilter(GradX.*GradX,Ghr);
    J2=imfilter(GradX.*GradY,Ghr);
    J3=imfilter(GradY.*GradY,Ghr);

    %%%% 2.1.2 - Singular Values  Lamda %%%
    Lamda_plus=0.5*(J1+J3+sqrt((J1-J3).^2 +4*J2.^2));
    Lamda_min=0.5*(J1+J3-sqrt((J1-J3).^2 +4*J2.^2));

    %%%% 2.1.3 - Cornerness Critirion %%%%
    R = Lamda_plus.*Lamda_min-k*(Lamda_plus+Lamda_min).^2;
    Rmax=max(max(R));
    ns = ceil(3*sigma)*2+1;
    B_sq = strel('disk',ns);
    Cond= ( R==imdilate(R,B_sq) )&(R>theta*Rmax); % Corner Pixels (x,y)
    [CornX, CornY]=find(Cond); % (X,Y) indicies for corner Pixels
    SigmaMatrix=repmat(sigma, length(CornX),1);
    Corn=[CornY, CornX, SigmaMatrix];
end
    