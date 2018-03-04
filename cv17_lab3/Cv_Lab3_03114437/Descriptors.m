function [Hog, Hof, HogHof]=Descriptors(I , Corner ,sigma) 
    I= double(I); 
    rho =5;
    epsilon= 0.05;
    x = Corner(:,2);
    y = Corner(:,1);
    for i = 1:(size(Corner,1))
        t= Corner(i,4); %Current Frame
        %% 2.1 Lukas Kanade Optical Flow
        % Initial Condition - dx , dy %
        %d_x0=repmat(0.5,size(I1(:,:,t),1),size(I1(:,:,t),2));
        %d_y0=repmat(0.5,size(I1(:,:,t),1),size(I1(:,:,t),2));
        d_x0 = zeros(size(I(:,:,t),1), size(I(:,:,t),2));
        d_y0 = zeros(size(I(:,:,t),1), size(I(:,:,t),2));
        %% Lukas Kanade algorithm
        if t<size(I,3)
            [d_x(:,:,t), d_y(:,:,t), Ix(:,:,t) ,Iy(:,:,t)]=lk( I(:,:,t), I(:,:,t+1), rho, epsilon, d_x0, d_y0);  % Lukas Kanade Algorithm
        else
            [d_x(:,:,t), d_y(:,:,t), Ix(:,:,t) ,Iy(:,:,t)]=lk( I(:,:,t), I(:,:,t-1), rho, epsilon, d_x0, d_y0);  % Lukas Kanade Algorithm
        end
        
        if (x(i) > 2*sigma) &&(y(i) > 2*sigma) &&(x(i) + 2*sigma <= size(Ix, 1)) && (y(i) + 2*sigma <= size(Ix, 2))
            %% 2.2 4xScale  Bins 
             bin{1} = Ix( x(i)-2*sigma:x(i)+2*sigma,y(i)-2*sigma:y(i)+2*sigma, t); 
             bin{2} = Iy( x(i)-2*sigma:x(i)+2*sigma,y(i)-2*sigma:y(i)+2*sigma, t);
             bin{3} = d_x(x(i)-2*sigma:x(i)+2*sigma,y(i)-2*sigma:y(i)+2*sigma, t);
             bin{4} = d_y(x(i)-2*sigma:x(i)+2*sigma,y(i)-2*sigma:y(i)+2*sigma, t);
             %% Histograms
             Hog(i, :) = OrientationHistogram(bin{1}, bin{2}, 3, [4, 4]);
             Hof(i, :) = OrientationHistogram(bin{3}, bin{4}, 3, [4, 4]);
             HogHof(i, :) = [Hog(i, :)  Hof(i, :)];
         end
    end
end