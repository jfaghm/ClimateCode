function yearData = getYearData( headerInfo, variable )
%GETYEARDATA Gets the data for all storms in a year
%   

% grab the year being processed from the first storm
year = headerInfo(1, 2);

dataArray = loadData(year, variable);

yearData = getObsData(headerInfo, dataArray);

end