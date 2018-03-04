function se=strel3d(sesize)
sw=(sesize-1)/2; 
ses2=ceil(sesize/2);            
[y,x,z]=meshgrid(-sw:sw,-sw:sw,-sw:sw); 
m=sqrt(x.^2 + y.^2 + z.^2); 
b=(m <= m(ses2,ses2,sesize)); 
se=strel('arbitrary',b);

