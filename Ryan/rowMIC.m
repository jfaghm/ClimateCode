function allMIC = rowMIC( A, B, message )
%ROWMIC Computes MIC between rows of input matrices
%
%   rowMIC computes the MIC between each pair of rows of the
%   input matrices.  This means that A and B must have the same number of
%   columns.
%
% -------------------------------- INPUT --------------------------------
%
% --> A - A matrix with a time series on each row.
% --> B - A matrix with a time series on each row.
% 
% A and B must have an equal number of columns, so that an MIC can
% be computed between each row of A and B.
%
% -------------------------------- OUTPUT --------------------------------
%
% --> allMIC - A matrix which contains the MIC between every possible pair
% of rows from A and B.  The entry allMIC(i, j) contains the MIC between
% the ith row of A and jth row of B.
% 
% EXAMPLE 1:
% x = 0:.01:10;
% A = [ x; x; x; x ];
% B = [ 5*x+10; x.^2 + 103; x.^3 - 5; sin(x) ];
% rowMIC(A, B)
% 
% ans =
% 
%     1.0000    1.0000    1.0000    1.0000
%     1.0000    1.0000    1.0000    1.0000
%     1.0000    1.0000    1.0000    1.0000
%     1.0000    1.0000    1.0000    1.0000
% 
% EXAMPLE 2:
% x = -4:0.01:4;
% y = sqrt( 16 - x.^2 );
% x = [ x x ];
% y = [ y -y ];
% rowMIC(x, y)
% 
% ans =
% 
%     0.6973

if nargin < 3
    message = '';
end

TEMP_FILE_NAME = ['ABTemp' message '.csv'];
SAVE_NAME = 'AB';

% Check that B is a vector and has the same number of columns as A
if length(size(B)) ~= 2
    error('B must be two-dimensional')
elseif length(size(A)) ~= 2
    error('A must be two-dimensional')
elseif size(B, 2) ~= size(A, 2)
    error('B must have the same number of columns as A')
end

% Give A and B and index column for identification
A = [ (1:size(A, 1))' A ];
B = [ (1:size(B, 1))' B ];
allMICSize = [ size(A, 1) size(B, 1) ];
% Remove any nan rows, so MINE doesn't get confused
A( any(isnan(A), 2), : ) = [];
B( any(isnan(B), 2), : ) = [];
% Concatenate A and B to write to a csv file
concatenated = [ A; B ];
dlmwrite(TEMP_FILE_NAME, concatenated)

% Call the java program to compute MIC and store results in a text file
commandString = [ 'java -jar /project/expeditions/haasken/CorrCode/MICStudy/MINE.jar ' ... 
    TEMP_FILE_NAME ' -pairsBetween ' num2str(size(A, 1)) ...
    ' id=' SAVE_NAME ...
    ' > /dev/null' ]; % Don't display output
system( commandString );

% Now process the output file to create a heat map of MIC
resultFile = [ TEMP_FILE_NAME ',' SAVE_NAME ',Results.csv' ];
statusFile = [ TEMP_FILE_NAME ',' SAVE_NAME ',Status.txt' ];
% Open the file
fid = fopen(resultFile);
% Use textscan to read the output file appropriately
% First remove the column headings (8 total)
% ---------- HEADINGS -----------
% X var,Y var,MIC (strength),MIC-p^2 (nonlinearity),
% MAS (non-monotonicity),MEV (functionality),MCN (complexity),
% Linear regression (p)
columnHeadings = textscan(fid, '%s %s %s %s %s %s %s %s', 1, 'Delimiter', ',');
% Now read the rest of the file and convert to a double matrix
results = textscan(fid, '%f32 %f32 %f32 %f32 %f32 %f32 %f32 %f32', 'Delimiter', ',');
results = cell2mat(results);
fclose(fid);

% Compute the proper indices into the matrix using the x var and y var
% headings as row and column indices, respectively
indices = sub2ind( allMICSize, results(:, 1), results(:, 2) );

% Put the resulting MIC into a matrix where allMIC(i, j) is the MIC between
% row i of A and row j of B
allMIC = nan( allMICSize );
allMIC(indices) = results(:, 3);

% Remove all the temporary txt and csv files created by MINE
delete( TEMP_FILE_NAME, resultFile, statusFile );

end