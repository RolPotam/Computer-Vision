function C=Precision(D,T)
    card_D=sum(sum(D));
    card_T=sum(sum(T)); %Real Edges 
 
    [Xsize,Ysize]=size(D);
    Pr=0; % Tomi Synolwn
    for i=1:Xsize
        for j=1:Ysize
            if (D(i,j)==1 && T(i,j)==1)
              Pr=Pr+1  ; 
            end 
        end
    end
    Pr1=Pr/card_T;
    Pr2=Pr/card_D;
    C=mean([Pr1 Pr2]);
end


