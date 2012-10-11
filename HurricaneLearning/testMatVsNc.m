numTrials = 4;

ncTimes = zeros(numTrials, 21);
matTimes = zeros(numTrials, 21);

for trial = 1:numTrials
    
    cd /project/expeditions/haasken/MATLAB/Hurricane/LessModular/
    build_hurricane_data
    ncTimes(trial, :) = ncFileTime;
    
    cd /project/expeditions/haasken/MATLAB/Hurricane/UsesMatFiles/
    buildDataSet
    matTimes(trial, :) = matFileTime;


end