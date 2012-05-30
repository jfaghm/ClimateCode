function allCorrelations = rowCorr( A, B, ~ )
%ROWCORR Computes correlation between rows of input matrices
%
% allCorrelations = rowCorr( A, B )
% 
%   rowCorr computes the correlations between each pair of rows of the
%   input matrices.  This means that A and B must have the same number of
%   columns.
%
% -------------------------------- INPUT --------------------------------
%
% --> A - A matrix with a series on each row.
% --> B - A matrix with a series on each row.
% 
% A and B must have an equal number of columns, so that a correlation can
% be computed between each row.
%
% -------------------------------- OUTPUT --------------------------------
%
% --> allCorrelations - A matrix which contains the correlation between
% every possible pair of rows from A and B.  The entry allCorrelations(i, j) 
% contains the correlation between the ith row of A and jth row of B.
%
% Example:
% 
% % Compute the correlation between matrices A and B, in which every row is
% % either perfectly correlated or perfectly anticorrelated
%
% A = [ 1 2 3; ...
%       1 5 9; ...
%      10 8 6 ]; 
% B = [ 2   4   6; ...
%      .2  .4  .6; ...
%     -20 -30 -40; ...
%     100  50   0];
% C = rowCorr(A, B)
% C =
%
%            1            1           -1           -1
%            1            1           -1           -1
%           -1           -1            1            1
%

A1 = A - repmat(mean(A, 2), 1, size(A, 2));
B1 = B - repmat(mean(B, 2), 1, size(B, 2));

% Normalize the rows of each matrix
A2 = normalizeRows(A1);
B2 = normalizeRows(B1);

allCorrelations = A2 * B2';

end

