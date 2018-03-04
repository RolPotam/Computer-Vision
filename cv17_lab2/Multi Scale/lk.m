function [dx_i, dy_i]=lk( I1, I2, rho, epsilon, d_x0, d_y0)
    %%% Initial  - Lukas Kanade
    dx_i= d_x0;
    dy_i= d_y0;

    [x_0, y_0] = meshgrid( 1:size(I1,2), 1:size(I1, 1));
    n=2*ceil(2*rho)+1;
    Gs=fspecial('gaussian', [n n], rho);
    [I1x,I1y]=imgradientxy(I1);
    for j=1:10
        A1=interp2(  I1x,x_0 +dx_i, y_0+dy_i,'linear',0);
        A2=interp2(  I1y,x_0 +dx_i, y_0+dy_i,'linear',0);
        I1_n=interp2(I1 ,x_0 +dx_i, y_0+dy_i,'linear',0);
        Er= I2-I1_n;
        %%% U matrix Co-efficients
        u11=imfilter(A1.*A1,Gs,'symmetric')+epsilon;
        u12=imfilter(A1.*A2,Gs,'symmetric');
        u22=imfilter(A2.*A2,Gs,'symmetric')+epsilon;
        
        u1=imfilter(A1.*Er,Gs,'symmetric'); 
        u2=imfilter(A2.*Er,Gs,'symmetric');
        %%% U(x) - Matrix Calculation - Inverse %%%%
        det_1=u11.*u22-u12.*u12;
        u3=(u22.*u1-u12.*u2)./det_1;
        u4=(-u12.*u1+u11.*u2)./det_1;
        dx_i=dx_i+u3;
        dy_i=dy_i+u4;
    end
   dx_i= -dx_i;
   dy_i= -dy_i;
   
   subplot(1,3,3);
   d_x_r=imresize(dx_i,0.3);
   d_y_r=imresize(dy_i,0.3); 
   quiver(d_x_r,d_y_r); axis equal;  axis([0 14 0 20]) ; title('Quiver Plot'); 