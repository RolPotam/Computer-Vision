function [disp_x, disp_y]=displ(d_x,d_y)
    en=d_x.^2 + d_y.^2;   % Energy 
    Max_en= max(max(en)); % Max Energy
    en=en/Max_en;

    thresh=0.4; 
    [idx,idy]= find(en > thresh); 
    disp_x=ceil(mean(mean(d_x(idx,idy))));
    disp_y=ceil(mean(mean(d_y(idx,idy))));

end

