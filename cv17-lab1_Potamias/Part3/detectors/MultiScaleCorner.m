function [MultiCorn]=MultiScaleCorner(I0, sigma ,N,s, rho , k , theta)
%% 2.2 MultiScale Corner Detection %%
%%% Image to Gray Scale %%%%
%     I_double=im2double(I0);
%     Igr=rgb2gray(I_double);
Igr=I0;
%%%%% 2.2.1 -Generate Scales Values For Corner Detection %%%%%
    MultiCorn=[];
    for i=1:N
        sigmaN(i)=sigma*s^(i-1);
        rhoN(i)=rho*s^(i-1); 
        hsize(i)=[2*ceil(3*sigmaN(i))+1];
%%%%% Normalized Laplacian of Gaussian for Scale i %%%%%
        LoGh{i}=(sigmaN(i)^2)*abs(imfilter(Igr,fspecial('log', hsize(i), sigmaN(i)),'symmetric'));  
    end
 %%%% Harris Corner Detection for Scale i %%%%
    for i=1:N 
        [Corn]= Harris(I0, sigmaN(i) , rhoN(i) , k , theta );
        [SizeX,~]=size(Corn); 
 %%%% 2.2.2 - Corners Selection %%%%%
        if (i==1)
            for j=1:(SizeX)     
                if (LoGh{i}(Corn(j,2),Corn(j,1))>LoGh{i+1}(Corn(j,2),Corn(j,1)))
                    MultiCorn=[MultiCorn; Corn(j,:)];
                end
            end
            
        elseif (i==N)
             for j=1:(SizeX)     
                if (LoGh{i}(Corn(j,2),Corn(j,1))>LoGh{i-1}(Corn(j,2),Corn(j,1)))
                    MultiCorn=[MultiCorn; Corn(j,:)];
                end
             end
           
        else
            for j=1:(SizeX)     
                if (LoGh{i}(Corn(j,2),Corn(j,1))>LoGh{i-1}(Corn(j,2),Corn(j,1)))&& (LoGh{i}(Corn(j,2),Corn(j,1))>LoGh{i+1}(Corn(j,2),Corn(j,1)))
                    MultiCorn=[MultiCorn; Corn(j,:)];
                end
             end
            
        end
    end

    