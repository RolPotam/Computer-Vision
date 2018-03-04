
nframes = 200; 
Box{1}= readVideo('./samples/boxing/person16_boxing_d4_uncomp.avi',nframes,0);
Box{2}= readVideo('./samples/boxing/person21_boxing_d1_uncomp.avi',nframes,0);
Box{3}= readVideo('./samples/boxing/person25_boxing_d4_uncomp.avi',nframes,0);
%%%%
Run{1}= readVideo('./samples/running/person09_running_d1_uncomp.avi',nframes,0);
Run{2}= readVideo('./samples/running/person15_running_d1_uncomp.avi',nframes,0);
Run{3}= readVideo('./samples/running/person23_running_d3_uncomp.avi',nframes,0);
%%%%
Walk{1}= readVideo('./samples/walking/person07_walking_d2_uncomp.avi',nframes,0);
Walk{2}= readVideo('./samples/walking/person14_walking_d2_uncomp.avi',nframes,0);
Walk{3}= readVideo('./samples/walking/person20_walking_d3_uncomp.avi',nframes,0);

%% 1.1 Harris Detection
sigma = 3;
sigma_t=2;
k = 0.03;
theta = 0.001;
%%% Box Videos 
for i =1:3 
    Im = Box{i};
    CornerB{i}= Harris(Im,sigma,sigma_t,k,theta);
    figure;
    showDetection(Im, CornerB{i});
end
k = 0.01;
theta = 0.001;
%%% Run Videos 
for i =1:3 
    Im = Run{i};
    CornerR{i}= Harris(Im,sigma,sigma_t,k,theta);
    figure;
    showDetection(Im, CornerR{i});
end
%%% Walk Videos 
for i =1:3 
    Im = Walk{i};
    CornerW{i}= Harris(Im,sigma,sigma_t,k,theta);
    figure;
    showDetection(Im, CornerW{i});
end

%% 1.2 Gabor Filter 
sigma =3; 
sigma_t= 2;
theta = 0.2; 
%%% Box Videos 
for i =1:3 
    Im = Box{i};
    CornerG_B{i} = GaborFilter(Im , sigma, sigma_t, theta);
    figure;
    showDetection(Im, CornerG_B{i});
end
%%% Run Videos 
theta = 0.4; 
for i =1:3 
    Im = Run{i};
    CornerG_R{i} = GaborFilter(Im , sigma, sigma_t, theta);
    figure;
    showDetection(Im, CornerG_R{i});
end
%%% Walk Videos 
theta = 0.2; 
for i =1:3 
    Im = Walk{i};
    CornerG_W{i} = GaborFilter(Im , sigma, sigma_t, theta);
    figure;
    showDetection(Im, CornerG_W{i});
end


%% Part 2.1- 2.2

%%%%%%% Harris Detection -Descriptors %%%%%%%%%%%
for i =1:3
    [HogB{1,i}, HofB{1,i}, HogHofB{1,i}]=Descriptors(Box{i} , CornerB{i} ,sigma);
end
for i =1:3
    [HogR{1,i}, HofR{1,i}, HogHofR{1,i}]=Descriptors(Run{i} , CornerR{i} ,sigma);
end
for i =1:3
    [HogW{1,i}, HofW{1,i}, HogHofW{1,i}]=Descriptors(Walk{i} , CornerW{i} ,sigma);
end
%%%%%%% Gabor Filter Detection- Descriptors %%%%%%%%%%%
for i =1:3
    [HogB{2,i}, HofB{2,i}, HogHofB{2,i}]=Descriptors(Box{i} , CornerG_B{i} ,sigma);
end
for i =1:3
    [HogR{2,i}, HofR{2,i}, HogHofR{2,i}]=Descriptors(Run{i} , CornerG_R{i} ,sigma);
end
for i =1:3
    [HogW{2,i}, HofW{2,i}, HogHofW{2,i}]=Descriptors(Walk{i} , CornerG_W{i} ,sigma);
end

%% 2.3 Bag of Visual Words
%%% Hof Descriptor Hist
HarrisBoW_Hof = BagOfWords(HofB{1,1},HofB{1,2},HofB{1,3},HofR{1,1},HofR{1,2},HofR{1,3},HofW{1,1},HofW{1,2},HofW{1,3});
GaborBoW_Hof  = BagOfWords(HofB{2,1},HofB{2,2},HofB{2,3},HofR{1,1},HofR{2,2},HofR{2,3},HofW{2,1},HofW{2,2},HofW{2,3});
%%% Hog Descriptor Hist
HarrisBoW_Hog = BagOfWords(HogB{1,1},HogB{1,2},HogB{1,3},HogR{1,1},HogR{1,2},HogR{1,3},HogW{1,1},HogW{1,2},HogW{1,3});
GaborBoW_Hog  = BagOfWords(HogB{2,1},HogB{2,2},HogB{2,3},HogR{1,1},HogR{2,2},HogR{2,3},HogW{2,1},HogW{2,2},HogW{2,3});
%%% Hog/Hof Descriptor Hist
HarrisBoW_HH = BagOfWords(HogHofB{1,1},HogHofB{1,2},HogHofB{1,3},HogHofR{1,1},HogHofR{1,2},HogHofR{1,3},HogHofW{1,1},HogHofW{1,2},HogHofW{1,3});
GaborBoW_HH  = BagOfWords(HogHofB{2,1},HogHofB{2,2},HogHofB{2,3},HogHofR{1,1},HogHofR{2,2},HogHofR{2,3},HogHofW{2,1},HogHofW{2,2},HogHofW{2,3});

%% 3 Dendrogram
%%% Harris Descriptor
HarrisHof_Den = linkage(HarrisBoW_Hof, 'average', '@distChiSq');
figure; title('Harris Descriptor');
subplot(3,1,1)
dendrogram(HarrisHof_Den); title('Harris-Hof Dendrogram');

HarrisHog_Den = linkage(HarrisBoW_Hog, 'average', '@distChiSq');
subplot(3,1,2);
dendrogram(HarrisHog_Den); title('Harris-Hog Dendrogram');

HarrisHH_Den = linkage(HarrisBoW_HH, 'average', '@distChiSq');
subplot(3,1,3);
dendrogram(HarrisHH_Den);title('Harris-Hog/Hof Dendrogram');

%%% Gabor Filter Descriptor 
GaborHof_Den = linkage(GaborBoW_Hof, 'average', '@distChiSq');
figure; subplot(3,1,1);
dendrogram(GaborHof_Den);title('Gabor-Hof Dendrogram');

GaborHog_Den = linkage(GaborBoW_Hog, 'average', '@distChiSq');
subplot(3,1,2);
dendrogram(GaborHog_Den); title('Gabor-Hog Dendrogram');

GaborHH_Den = linkage(GaborBoW_HH, 'average', '@distChiSq');
subplot(3,1,3);
dendrogram(GaborHH_Den);title('Gabor-Hog/Hof Dendrogram');