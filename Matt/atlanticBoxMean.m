function [ dataMean] = atlanticBoxMean( data, lat, lon )
%This function spatially averages the data variable inside the main
%development region (5 to 20 degrees latitude, -70 to -15 degrees
%longitude)  
%   Input: Some two dimensional data, that data's latitudes and longitudes
%   Ouput: Spatial average inside the main development region

if ~all(lon > 0)
    lon(lon >= 180) = lon(lon >= 180) - 360;
end

subset = data(lat >= 5 & lat <= 20, lon >= -70 & lon <= -15);
dataMean = nanmean(subset(:));




