% Function for compute the sum squared error
function sse = compute_sse(x,centroids)
    numOfClusters = size(centroids,1);
	sizeX = size(x,1);
    theMin = realmax;
    sse=0;
    for j = 1:sizeX
        theMin = realmax;
        for i=1:numOfClusters
           theMin = min(theMin,euclidean_distance(centroids(i,:),x(j,:))^2);
        end
        sse= sse + theMin;
    end
end