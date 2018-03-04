function MultiBlob= MultiScaleBlob(I0,N,sigma , s ,theta ) 
    %%%% Transform RGB Image to Gray %%%
    Id=im2double(I0);
    Igr=rgb2gray(Id);
    
    MultiBlob=[];
   %%% Generate Parameters for Every Scale %%%
    for i=1:N
        sigmaN(i)=sigma*s^(i-1);
        hsize(i)=[2*ceil(3*sigmaN(i))+1];
        LoGh{i}=(sigmaN(i)^2)*abs(imfilter(Igr,fspecial('log', hsize(i), sigmaN(i)),'symmetric'));  
    end
   %%% Multi Blob Detection %%%%
    for i=1:N 
        [Blob]= BlobDetection(I0,sigmaN(i),theta);
        [SizeX,~]=size(Blob); 
 %%%% 2.2.2 - Corners Selection %%%%%
        if (i==1)
            for j=1:(SizeX)     
                if (LoGh{i}(Blob(j,2),Blob(j,1))>LoGh{i+1}(Blob(j,2),Blob(j,1)))
                    MultiBlob=[MultiBlob; Blob(j,:)];
                end
            end
            
        elseif (i==N)
             for j=1:(SizeX)     
                if (LoGh{i}(Blob(j,2),Blob(j,1))>LoGh{i-1}(Blob(j,2),Blob(j,1)))
                    MultiBlob=[MultiBlob; Blob(j,:)];
                end
             end
           
        else
            for j=1:(SizeX)     
                if (LoGh{i}(Blob(j,2),Blob(j,1))>LoGh{i-1}(Blob(j,2),Blob(j,1)))& (LoGh{i}(Blob(j,2),Blob(j,1))>LoGh{i+1}(Blob(j,2),Blob(j,1)))
                    MultiBlob=[MultiBlob; Blob(j,:)];
                end
             end
            
        end
    end

    
end