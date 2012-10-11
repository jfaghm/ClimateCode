function [ positiveAvg, negativeAvg ] = getAvgSSTPosNeg( dataSet, takeMean )
%COUNTPOSNEG Counts the number of positive and negative observations

if nargin < 2
    takeMean = true;
end

numPositives = 0;
numNegatives = 0;
positiveTempAcc = 0;
negativeTempAcc = 0;


numYears = length(dataSet);

for i = 1:numYears
    numPositives = numPositives + sum(dataSet{i}(:, 1));
    numNegatives = numNegatives + sum(~dataSet{i}(:, 1));
    numObs = size(dataSet{i}, 1);
    for j = 1:numObs
        
        if any(dataSet{i}(j, 5:14) < -8e33)
            if dataSet{i}(j, 1) == 1
                numPositives = numPositives - 1;
            else
                numNegatives = numNegatives - 1;
            end
            continue
        end

        if dataSet{i}(j, 1) == 1
            if takeMean
                positiveTempAcc = positiveTempAcc + mean(dataSet{i}(j, 5:14));
            else
                positiveTempAcc = positiveTempAcc + dataSet{i}(j, 5);
            end
        else
            if takeMean
                negativeTempAcc = negativeTempAcc + mean(dataSet{i}(j, 5:14));
            else
                negativeTempAcc = negativeTempAcc + dataSet{i}(j, 5);
            end
        end
    end
end

positiveAvg = positiveTempAcc/numPositives;
negativeAvg = negativeTempAcc/numNegatives;

end