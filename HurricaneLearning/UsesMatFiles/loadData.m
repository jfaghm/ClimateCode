function dataArray = loadData( year, filename)
%GETSSTDATA Loads the sst data for a year and its next and previous years.
%   Loads the sst data for input year as well as the next and previous
%   years and returns it in a cell array called data.  The first cell is
%   the previous year, the second cell is the input year, and the last
%   cell is the next year.  If the file for any year does not exist, that
%   cell is false;

persistent previousYearData;
persistent currentYearData;

yearString = num2str(year);
prevYearString = num2str(year - 1);
nextYearString = num2str(year + 1);

prefix = [ '/export/scratch/haasken/EraInterimData/matfiles/' filename ];

filenames = cell(1, 3);
filenames{1} = [prefix prevYearString '.mat'];
filenames{2} = [prefix yearString '.mat'];
filenames{3} = [prefix nextYearString '.mat'];

dataArray = cell(1, 3);
startIndex = 1;

% Check if the data for the previous year exists
if exist(filenames{1}, 'file')
    dataArray{1} = previousYearData;
    dataArray{2} = currentYearData;
    startIndex = 3;
end

for i = startIndex:3
    if exist(filenames{i}, 'file')
        load(filenames{i})
        dataArray{i} = data;
    end
end

previousYearData = dataArray{2};
currentYearData = dataArray{3};

end

