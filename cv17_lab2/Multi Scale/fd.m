function Box= fd(I, mu ,cov)
%%% Gaussian Propability based on Skin Samples %%%

    testCb=reshape(I(:,:,2),[],1);
    testCr=reshape(I(:,:,3),[],1);
    testCbCr=[testCb, testCr];

    Prop=mvnpdf(testCbCr,mu,cov);
    Prop=Prop/max(Prop);
% UNCOMMEND TO SURF PROPABILITY FUNCTION 
%     figure; 
%     surf(reshape(Prop,442,381), 'EdgeColor', 'none');   
    
    %% Face Detection - Threshold 
    thresh=0.15;
    Prop_thr=Prop>thresh;
    Prop_thr=reshape(Prop_thr,442,381);
    %%% Image Morphological Filters %%%
    se=strel('disk',5);
    Prop_thr=imopen(Prop_thr,se);
    se=strel('disk',10);
    Prop_thr=imclose(Prop_thr,se);
    % UNCOMMEND TO PLOT THRESHOLDED IMAGE
    %figure; subplot(2,1,1);imshow(Prop_thr); title('Thresholded Image (0.1)');
    %subplot(2,1,2); imshow(Prop_thr); title('Opening-Closing Morphological Filters');
    %% Label Areas 
    Labels=bwlabel(Prop_thr,4);
    Properties=regionprops(Labels);
    %[x, y, width, height]=Properties(2).BoundingBox;
     [~,idx]=max([Properties(:).Area]);
     Box=Properties(idx).BoundingBox;
end

