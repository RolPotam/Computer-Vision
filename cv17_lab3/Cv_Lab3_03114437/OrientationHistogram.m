%function local_desc = OrientationHistogram(Gx,Gy,bins,cells,overlap,signed)
% basic hog function
% Gx,Gy : the input image
% bins : the number of bins
% cells : image segmentation. [cellsi cellsj] or one number for rectangular
% overlap : range : 0 - .5 for overlapping cells 
% signed : 0 for unsigned , 1 for signed
