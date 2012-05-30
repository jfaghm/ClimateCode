function [corrGrid micGrid] = CorrAndMICGrid( data, series )

f = flattenData(data);
correlations = rowCorr(f, series);
mic = rowMIC(f, series);

numRows = size(data, 1);
numCols = size(data, 2);

corrGrid = reshape(correlations, numRows, numCols);
micGrid = reshape(mic, numRows, numCols);

end
