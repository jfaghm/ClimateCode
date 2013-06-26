

% Load the collapsed data with a +/- 7 day, 1.6 degree SST negative requirement
load 7Day16threshold.mat
% Load the column labels for the data set
load collapsedLabels.mat

% Set up the location names, pressure levels, and times
locationNames = { 'middle', 'northwest', 'west', 'southwest', 'north', 'south', 'northeast', 'east', 'southeast'};
PL = { '200', '500', '700', '850' };
times = 18:-6:-36;

numPL = length(PL);
numTimeSteps = length(times);
numLocs = length(locationNames);

% Initialize arrays for the desired column names
uWindStrings = cell(numPL, numTimeSteps*numLocs); 
vWindStrings = cell(numPL, numTimeSteps*numLocs);

totalShearLabels = cell(1, numTimeSteps*numLocs);
uShearLabels = cell(1, numTimeSteps*numLocs);

% Populate the arrays with the desired columns
for p = 1:numPL
    pressure = PL{p};
    curCol = 0;
    for loc = 1:numLocs
        location = locationNames{loc};
        for time = times
            timeString = num2str(time, '%02d');
            curCol = curCol + 1;
            uWindStrings{p, curCol} = [ 'uWind (PL ' pressure ') (t=' timeString ') (loc:' location ')' ];
            vWindStrings{p, curCol} = [ 'vWind (PL ' pressure ') (t=' timeString ') (loc:' location ')' ];
            
            % Set up the labels for the shear data
            if p == 1
                totalShearLabels{curCol} = [ 'Vertical Shear (t=' timeString ') (loc: ' location ')' ];
                uShearLabels{curCol} = [ 'U Shear (t=' timeString ') (loc: ' location ')' ];
            end
            
        end
    end
end

% Initialize the logical masks for getting the desired columns
uWindMask = false(4, length(columnLabels));
vWindMask = false(4, length(columnLabels));

% Create the mask for each pressure level
for i = 1:4
    uWindMask(i, :) = ismember(columnLabels, uWindStrings(i, :));
    vWindMask(i, :) = ismember(columnLabels, vWindStrings(i, :));
end

% Initialize the data matrices
uWind = zeros(size(data, 1), 90, 4);
vWind = zeros(size(data, 1), 90, 4);

% Populate the data matrices with the data for each pressure level
for i = 1:4
    uWind(:, :, i) = data(:, uWindMask(i, :));
    vWind(:, :, i) = data(:, vWindMask(i, :));
end

% Initialize the windShear matrix
numShearLevels = nchoosek(numPL, 2);
totalWindShear = zeros( size(uWind, 1), numTimeSteps*numLocs, numShearLevels );
uWindShear = zeros(size(uWind, 1), numTimeSteps*numLocs, numShearLevels );
totalShearRowLabels = cell(numShearLevels, 1);
uShearRowLabels = cell(numShearLevels, 1);

% compute the total wind shear and u wind shear for each pressure difference
rowIndex = 0;
for lp = 1:4
    
    for hp = (lp+1):4
        rowIndex = rowIndex + 1;
        
        uDif = abs(uWind(:, :, lp) - uWind(:, :, hp));
        vDif = abs(vWind(:, :, lp) - vWind(:, :, hp));
        
        totalWindShear(:, :, rowIndex) = sqrt((uDif .^2) + (vDif .^2));
        uWindShear(:, :, rowIndex) = uDif;
        
        totalShearRowLabels{rowIndex} = [ PL{lp} '-' PL{hp} ' wind shear' ];
        uShearRowLabels{rowIndex} = [ PL{lp} '-' PL{hp} ' u wind shear' ];
        
    end
end

startIndices = [ 1 385:380:size(data, 2) ];
endIndices = 384:380:size(data, 2);

dataWithShear = cell(1, numLocs * 3);
% Iterate through each of the surrounding locations and put them in next to the rest of
% the data from that location
for loc = 1:numLocs
    
    uvShear = cell(1, size(totalWindShear, 3));
    uShear = cell(1, size(totalWindShear, 3));
    for pdif = 1:numShearLevels
        uvShear{pdif} = totalWindShear(:, ((loc-1)*numTimeSteps+1):(loc*numTimeSteps), pdif);
        uShear{pdif} = uWindShear(:, ((loc-1)*numTimeSteps+1):(loc*numTimeSteps), pdif);
    end
    uvShear = cell2mat(uvShear);
    uShear = cell2mat(uShear);
        
    dataWithShear{3*loc-2} = data(:, startIndices(i):endIndices(i));
    dataWithShear{3*loc-1} = uvShear;
    dataWithShear{3*loc} = uShear;
    
end
dataWithShear = cell2mat( [ {data(:, 1:4)} dataWithShear ] );

% Create the column labels for the shear data
totalShearLabels = cell(1,  numShearLevels * numTimeSteps * numLocs );
uShearLabels = cell(1, numShearLevels * numTimeSteps * numLocs );
lidx = 0;
for loc = 1:numLocs
    for pdif = 1:numShearLevels
        for time = times
            timeString = num2str(time);
            lidx = lidx + 1;
            totalShearLabels{lidx} = [ totalShearRowLabels{pdif} ' (t=' timeString ') (loc:' locationNames{loc} ')'];
            uShearLabels{lidx} = [ uShearRowLabels{pdif} ' (t=' timeString ') (loc:' locationNames{loc} ')'];
        end
    end
end

% Create a new column labels array
newColLabels = columnLabels(1:4);
labelIndex = 1;
for loc = 1:numLocs
    newColLabels = [ newColLabels columnLabels(startIndices(i):endIndices(i)) ...
        totalShearLabels( ((loc-1)*numShearLevels*numTimeSteps+1):(loc*numShearLevels*numTimeSteps) ) ...
        uShearLabels( ((loc-1)*numShearLevels*numTimeSteps+1):(loc*numShearLevels*numTimeSteps) )];
end


