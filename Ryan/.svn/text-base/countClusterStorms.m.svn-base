function clusterStormCounts = countClusterStorms(storms, startYear, endYear, clusterIndices)
%COUNTSTORMS Gets the storm counts for each year for each of the clusters
%
% clusterStormCounts = countClusterStorms(storms, startYear, endYear, clusterIndices)
% 
%   This function counts the number of storms per year in each of the
%   clusters given by clusterIndices.
%
% --------------------------------- INPUT ---------------------------------
%
% --> storms - A matrix containing the storm data.  The first column should
% contain the year of each storm.
% --> startYear - The beginning of the year range to consider.
% --> endYear - The end of the year range to consider.
% --> clusterIndices - The indices which indicate which cluster each storm
% belongs to.  The value of clusterIndices(i) indicates the cluster to
% which the storm at storms(i, :) belongs.  It is assumed that the
% clusterIndices are integers ranging from 1 to the number of clusters.
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> stormCounts - A 2D matrix with the storm counts for each cluster in
% its own row. The element at clusterStormCounts(i, j) is the number of
% storms in the ith cluster which took place in the jth year of the range
% [startYear:endYear].
% 
% ----------------------------- EXAMPLE -----------------------------
% 
% The following example clusters the storms based on location using
% matlab's built-in k-means clustering algorithm and then counts the number
% of storms per year in each cluster.
% 
% % Load the storm data
% load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
% % Cluster the storms into 4 location-based clusters
% clusters = kmeans(condensedHurDat(:, [ 6 7 ]), 4);
% % Count the number of storms in each cluster
% clusteredCounts = countClusterStorms(condensedHurDat, 1971, 2010, clusters)
% 

% Check the clusterIndices input for validity
if ( ~isvector(clusterIndices) )
    error('Input clusterIndices should be a nx1 or 1xn vector.');
elseif ( max(clusterIndices) ~= length(unique(clusterIndices)) )
    error('Input clusterIndices should range from 1 to the number of clusters.');
elseif ( size(storms, 1) ~= length(clusterIndices) )
    error('Length of clusterIndices should match the number of rows of storms');
end

% Set up the clusterStormCounts matrix
numClusters = max(clusterIndices);
numYears = endYear - startYear + 1;
clusterStormCounts = zeros(numClusters, numYears);

for i = 1:numClusters
    clusterStorms = storms( clusterIndices == i, : );
    
    for j = 1:numYears
        year = startYear + j - 1;
        sc = sum( clusterStorms(:, 1) == year );
        clusterStormCounts(i, j) = sc;
    end
    
end


end