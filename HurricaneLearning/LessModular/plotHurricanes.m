% This script accumulates data for each hurricane in vectors and creates
% scatter plots of these variables

% location where model_data is stored
dataPath = '/project/expeditions/haasken/MATLAB/Hurricane/LessModular/';

% make a plots folder to put the plots in if it does not exist
if ~exist('plots', 'dir')
    mkdir('plots')
end
    
% Loads the data for each hurricane in a cell array of matrices called
% model_data
load([dataPath, 'model_data.mat'])

% Calculate the number of years and observations in model_data, useful for
% preallocation of the vectors to be plotted
numYears = size(model_data, 2);  

numObs = 0;
for i = 1:numYears
    numObs = numObs + size(model_data{i}, 1);
end

% ---------------------------------------------------------------
% Below are variables which affect how the graphs are displayed
% ---------------------------------------------------------------

showLegend = false;
positiveMarker = '+';
negativeMarker = 'o';
pauseAfterGraph = false;

% This variable is an array of the file types to save to (e.g. 'm', 'bmp',
% 'jpg', 'fig')
fileTypes = { 'fig', 'jpg' };
numFileTypes = size(fileTypes, 2);

% This variable indicates which pressure levels are wanted for each of the
% variables along with the appropriate offsets
pressureLevels = {'200', 0; '500', 10; '700', 20; '850' 30};
numPL = size(pressureLevels, 1);

% This 3-column cell array indicates which variables will be plotted
% against day number along with their units and column in the model_data matrices
% Each row contains [ variable name, units, starting column in model_data ]
variables = { 'Sea Surface Temperature', '(K)', 5; 'U Wind', '(m s^-^1)', 15; ...
    'V Wind', '(m s^-^1)', 55; 'Mean Sea Level Pressure', '(Pa)', 95; ... 
    'Temperature', '(K)', 105; 'Specific Humidity', '(kg kg^-^1)', 145; ...
    'Vorticity', '(s^-^1)', 185; 'Divergence', '(s^-^1)', 225; ...
    'Relative Humidity', '(%)', 265; 'Latitude', '(\circN)', 3; ...
    'Longitude', '(\circE)', 4 };
numVariables = size(variables, 1);

% Get whether a storm occurred and the day number for each observation
storm = true(1, numObs);
dayNumbers = zeros(1, numObs);
obsTaken = 0;
for i = 1:numYears
    yearData = model_data{i};
    yearSize = size(yearData, 1);
    for j = 1:yearSize
        obsTaken = obsTaken + 1;
        % set the storm flag for this observation
        storm(obsTaken) = yearData(j, 1);
        % set the day number for this observation
        dayNumbers(obsTaken) = yearData(j, 2);
    end
end

% Get the data for each variable for each observation in model_data
varData = zeros(numVariables, numObs);
for i = 1:numVariables
    % Check if it is a variable without pressure levels
    if ~ismember(variables{i, 1}, {'Sea Surface Temperature', 'Mean Sea Level Pressure', ...
            'Latitude', 'Longitude' })
        % iterate through each pressure level
        for p = 1:numPL
            % compute starting column for this pressure level
            varCol = variables{i, 3} + pressureLevels{p, 2};
            obsTaken = 0;  % tracks position in varData
            for j = 1:numYears
                yearData = model_data{j};
                yearSize = size(yearData, 1);
                for k = 1:yearSize
                    obsTaken = obsTaken + 1;
                    % accumulate each observation in varData
                    varData(i, obsTaken) = yearData(k, varCol);
                end
            end
            
            % get all the locations where there is a fill value
            % set filled values to NaN to preserve the scale of the graph
            varData(varData < -8e33) = NaN;
            
            % --------------------------------------------------
            % this is the code that creates the scatter plots
            % --------------------------------------------------
           
            % plot positives with a positiveMarker
            scatter(dayNumbers(storm), varData(i, storm), positiveMarker);
            hold on % keeps the positives on the figure
            % plot negatives with a negativeMarker
            scatter(dayNumbers(~storm), varData(i, ~storm), negativeMarker);
            % set the title, axis labels, and legend of the plot
            title([variables{i, 1} ' vs. Day Number'])
            xlabel('Day Number')
            ylabel([variables{i, 1}, ' ', variables{i, 2} ' at ' ...
                pressureLevels{p, 1}, ' mbar'])
            if showLegend
                legend('Positive', 'Negative', 'Location', 'EastOutside')
            else
                legend('Positive', 'Negative')
                legend('hide')
            end
            
            % finally, save the graph
            saveName = ['plots/', variables{i, 1}, 'PL', pressureLevels{p, 1}];
            saveName = saveName(~isspace(saveName));
            
            % save as each file type in fileTypes
            for x = 1:numFileTypes
                saveas(gcf, saveName, fileTypes{x})
            end
            
            % allows the next plot to overwrite the previous one
            hold off
            
            if pauseAfterGraph
                pause
            end            
        end
    else
        % compute starting column for this pressure level
        varCol = variables{i, 3};
        obsTaken = 0;  % tracks position in varData
        for j = 1:numYears
            yearData = model_data{j};
            yearSize = size(yearData, 1);
            for k = 1:yearSize
                obsTaken = obsTaken + 1;
                % accumulate each observation in varData
                varData(i, obsTaken) = yearData(k, varCol);
            end
        end
        
        % get all the locations where there is a fill value
        % set filled values to NaN to preserve the scale of the graph
        varData(varData < -8e33) = NaN;
        
        % --------------------------------------------------
        % this is the code that creates the scatter plots
        % --------------------------------------------------
        
        % plot positives with a positiveMarker
        scatter(dayNumbers(storm), varData(i, storm), positiveMarker);
        hold on % keeps the positives on the figure
        % plot negatives with a negativeMarker
        scatter(dayNumbers(~storm), varData(i, ~storm), negativeMarker);
        % set the title, axis labels, and legend of the plot
        title([variables{i, 1} ' vs. Day Number'])
        xlabel('Day Number')
        ylabel([variables{i, 1}, ' ', variables{i, 2}])
        
        if showLegend
            legend('Positive', 'Negative', 'Location', 'EastOutside')
        else
            legend('Positive', 'Negative')
            legend('hide')
        end
        
        % finally, save the graph
        saveName = ['plots/', variables{i, 1}];
        saveName = saveName(~isspace(saveName));
        
        % save as each file type in fileTypes
        for x = 1:numFileTypes
            saveas(gcf, saveName, fileTypes{x})
        end
        
        % allows the next plot to overwrite the previous one
        hold off
        
        if pauseAfterGraph
            pause
        end    
    end
end

close(gcf)
