% This script checks whether model data contains any -1 values or fill values

numYears = size(model_data, 2);

validData = true(1, numYears);
for i = 1:numYears
    if size(find(model_data{i} < -8e33), 1) > 0 || ismember(-1, model_data{i})
        validData(i) = false;
    end
end

if sum(validData, 2) == numYears
    fprintf('Data is valid.\n')
else
    fprintf('Data is invalid.\n')
    for i = 1:numYears
        if ~validData(i)
           fprintf('Data for year number %d is invalid.\n', i);
        end
    end
end