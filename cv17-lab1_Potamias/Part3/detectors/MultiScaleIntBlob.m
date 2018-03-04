function MutlitIntegralBlob=MultiScaleIntBlob(I0,N, sigma, s, theta)
%%%% Gray Scale Image %%%%
%     Id=im2double(I0);
%     Igr=rgb2gray(Id);
Igr=I0;    
   MutlitIntegralBlob=[];
   %%% Generate Parameters for Every Scale %%%
    for i=1:N
        sigmaN(i)=sigma*s^(i-1);
        hsize(i)=[2*ceil(3*sigmaN(i))+1];
        LoGh{i}=(sigmaN(i)^2)*abs(imfilter(Igr,fspecial('log', hsize(i), sigmaN(i)),'symmetric'));  
    end
    
    for i=1:N
        %%%% Blobs for Scale i using Integral Images %%%
        [IntBlob]=IntImageBlob(I0,sigmaN(i) ,theta);
       
        [SizeX, ~] = size(IntBlob); 
         %%%% Interest Points Selection %%%%%
         %%%% Maximaze Log(i,j) near Scales Critiria %%%%
        if (i==1)
            for j=1:(SizeX)     
                if (LoGh{i}(IntBlob(j,2),IntBlob(j,1))>LoGh{i+1}(IntBlob(j,2),IntBlob(j,1)))
                    MutlitIntegralBlob=[MutlitIntegralBlob; IntBlob(j,:)];
                end
            end
            
        elseif (i==N)
             for j=1:(SizeX)     
                if (LoGh{i}(IntBlob(j,2),IntBlob(j,1))>LoGh{i-1}(IntBlob(j,2),IntBlob(j,1)))
                    MutlitIntegralBlob=[MutlitIntegralBlob; IntBlob(j,:)];
                end
             end
           
        else
            for j=1:(SizeX)     
                if (LoGh{i}(IntBlob(j,2),IntBlob(j,1))>LoGh{i-1}(IntBlob(j,2),IntBlob(j,1)))& (LoGh{i}(IntBlob(j,2),IntBlob(j,1))>LoGh{i+1}(IntBlob(j,2),IntBlob(j,1)))
                    MutlitIntegralBlob=[MutlitIntegralBlob; IntBlob(j,:)];
                end
             end
            
        end
    end