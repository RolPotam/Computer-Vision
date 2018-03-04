function Corner = indicies(H,Im, Cond,sigma)
    [x, y, t] = ind2sub(size(H), find(Cond==1)); %Make Indicies to (i,j,k) Format
    Ind = [y x sigma*ones(length(x), 1) t];
    index = (size(Im) - size(H))/2; %Find Time Difference from Convolution and fix it. 
    index = [index(1) index(2) 0 index(3)];
    Corner = bsxfun(@plus, index, Ind); 
end