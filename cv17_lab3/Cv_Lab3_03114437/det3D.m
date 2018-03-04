function Det = det3D(Axx,Axy,Axt,Ayy,Ayt,Att)
    A1 = Axx.*(Ayy.*Att - Ayt.^2);
    A2 = Axy.*(Axy.*Att - Axt.*Ayt);
    A3 = Axt.*(Axy.*Ayt - Axt.*Ayy);
    Det = A1+A3 - A2 ; 
end