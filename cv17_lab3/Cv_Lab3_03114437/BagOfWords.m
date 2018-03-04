function BoW = BagOfWords(Box1 ,Box2,Box3, Run1,Run2,Run3,Walk1,Walk2,Walk3)
    Bag= {Box1 ,Box2,Box3, Run1,Run2,Run3,Walk1,Walk2,Walk3};
    BagM=[Box1 ;Box2;Box3; Run1;Run2;Run3;Walk1;Walk2;Walk3];
    [idx, cluster]= kmeans(BagM, 30); % Create Clusters
    for i =1:9
        for j = 1:size(Bag{i},1)
             frame  = Bag{i}(j,:);
             [Xframe,~] = size(frame);
             [Xclaster,~] = size(cluster);
             %%% Euclid Distance
             dist(j,:) = (ones(Xclaster, 1) * sum((frame.^2)', 1))' + ones(Xframe, 1) * sum((cluster.^2)',1) - 2.*(frame*(cluster'));
        end
        [~,minima] = min(dist');
    %% 2.3 Histogram 
    histogram = histc(minima, 1:20);
    histogram = histogram ./ norm(histogram, 2);
    BoW(i,:) = histogram;
    end
     
end