
load('atlantic_storms_1851_2010.mat')
load('atlantic_storms_1870_2009.mat')

hurDat = hurDat(hurDat(:, 2) >= 1870, :);

numStorms = size(hurricanes, 1);

for i = 1:numStorms
    if ~ismember(hurricanes(i, [1:3 6:7]), hurDat(:, [2:4 6:7]), 'rows')
        fprintf('Unable to find storm from old data set which took place on %02d/%02d/%d.\n', ...
            hurricanes(i, 2), hurricanes(i, 3), hurricanes(i, 1))
        [~, possibleMatch] = ismember(hurricanes(i, 1:3), hurDat(:, 2:4), 'rows');
        if possibleMatch
            fprintf('Old data set Location: %.2f, %.2f.  New data set loc: %.2f, %.2f.\n', ...
                hurricanes(i, 6), hurricanes(i, 7), hurDat(possibleMatch, 6), hurDat(possibleMatch, 7))
            distance = sum((hurricanes(i, 6:7) - hurDat(possibleMatch, 6:7)).^2)^0.5;
            if  distance < 5
                fprintf('Distance between is %.2f.\n', distance)
            end
        end
        fprintf('\n')
    end
end

[~, I, ~] = unique(hurDat(:, 1), 'first');
uHurDat = hurDat(I, :);

numStorms = size(uHurDat, 1);

for i = 1:numStorms
    if ~ismember(uHurDat(i, [2:4 6:7]), hurricanes(:, [1:3 6:7]), 'rows')
        fprintf('Unable to find storm from new data set which took place on %02d/%02d/%d.\n', ...
            uHurDat(i, 3), uHurDat(i, 4), uHurDat(i, 2))
        [~, possibleMatch] = ismember(uHurDat(i, 2:4), hurricanes(:, 1:3), 'rows');
        if possibleMatch
            fprintf('New data set loc: %.2f, %.2f.  Old data set Location: %.2f, %.2f.\n', ...
                uHurDat(i, 6), uHurDat(i, 7), hurricanes(possibleMatch, 6), hurricanes(possibleMatch, 7))
            distance = sum((uHurDat(i, 6:7) - hurricanes(possibleMatch, 6:7)).^2)^0.5;
            if  distance < 5
                fprintf('Distance between is %.2f.\n', distance)
            end
        end
        fprintf('\n')
    end
end
