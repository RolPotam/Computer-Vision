function [RealEdgePoints]=RealEdgeDetect(I0,theta_real)
    %% Real Edge Points %% 
    %%%%% Structure Element %%%%  
    B=strel('disk',1,8);
    M=imdilate(I0,B)-imerode(I0,B);
    RealEdgePoints=M>theta_real;
end