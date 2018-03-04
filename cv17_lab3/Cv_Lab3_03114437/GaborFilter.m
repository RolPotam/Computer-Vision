function Corner = GaborFilter(Im , sigma, sigma_t, theta)
    n = ceil(3*sigma)*2 + 1;
    t = ceil(3*sigma_t)*2+1;
    omega = 4/sigma_t;
    t_val = linspace(-2*sigma_t , 2*sigma_t , t); 
    % Gabor Filters (Even , Odd) 
    Hev = -cos(2*pi.*t_val*omega).*exp(-t_val.^2/(2*sigma_t^2));
    Hod = -sin(2*pi.*t_val*omega).*exp(-t_val.^2/(2*sigma_t^2));
    Hev_t(1,1,:) = Hev/norm(Hev,1); % Normalization with L1 norm
    Hod_t(1,1,:) = Hod/norm(Hod,1);
    % Gaussian Filter
    Gauss= fspecial('gaussian', n, sigma);
    % Gaussian Smoothing 
    G_smooth=imfilter(Im, Gauss, 'symmetric');
    % Gabor Filter Critiria 
    H_ev= convn(G_smooth, Hev_t,'valid'); 
    H_od= convn(G_smooth, Hod_t,'valid');
    H_total = H_ev.^2 + H_od.^2 ; %Total Squared Energy 
    %%% Gabor Filters Critia (Maxima) 
    Max = max(max(max(H_total)));
    SE = strel3d(3);
    Cond  = (H_total > theta*Max) & (H_total ==imdilate(H_total,SE));
    Corner = indicies(H_total,Im, Cond,sigma);
end