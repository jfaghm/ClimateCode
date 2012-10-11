columnLabels = cell(1, size(dataSet{1}, 2));
variableNames = { 'sst', 'geopotential', 'temperature', 'spec_hum', 'vert_vel', ...
    'vorticity', 'divergence', 'rel_hum', 'uWind', 'vWind', 'mslp' };
locations = cell(1, size(dataSetCollapsed{1}, 2));
locIndex = 1;
count = 0;
for index = 5:length(locations)
    count = count+1;
    if count > 380
        count = 1;
        locIndex = locIndex + 1;
    end
    locations{index} = locationNames{locIndex};
end
pressureLevels = { '200', '500', '700', '850' };
index = 4;
for loc = 1:length(locationNames)
    location = locationNames{loc};
    for var = 1:length(variableNames)
        variableName = variableNames{var};
        if ismember(variableName, { 'sst', 'mslp' })
            for t = 18:-6:-36
                index = index + 1;
                columnLabels{index} =  [ variableName ' (t=' num2str(t, '%02d') ') ' '(loc:' location ')' ];
            end
        else
            for pres = 1:length(pressureLevels)
                for t = 18:-6:-36
                    index = index + 1;
                    columnLabels{index} = [ variableName ' (PL ' pressureLevels{pres} ') ', '(t=' num2str(t, '%02d') ') ' '(loc:' location ')'];
                end
            end
        end
    end
end
columnLabels = cell(1, 384);
columnLabels(1:4) = { 'stormOccurred', 'dayNumber', 'latitude (degrees north)', 'longitude (degrees north)' };
index = 4;
for var = 1:length(variableNames)
    variableName = variableNames{var};
    if ismember(variableName, { 'sst', 'mslp' })
        for t = 18:-6:-36
            index = index + 1;
            columnLabels{index} =  [ variableName ' (t=' num2str(t, '%02d') ')' ];
        end
    else
        for pres = 1:length(pressureLevels)
            for t = 18:-6:-36
                index = index + 1;
                columnLabels{index} = [ variableName ' (PL ' pressureLevels{pres} ')', ' (t=' num2str(t, '%02d') ')' ];
            end
        end
    end
end
