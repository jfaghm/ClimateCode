function neighbors = getSurrounding( A, index, numNeighbors )
%GETSURROUNDING Gets the elements of A surrounding the element at index.
%   getSurrounding gets the elements of A surrounding the element at the
%   position given by index.  The matrix A is treated as if it is a
%   latitude and longitude grid of the earth, so it can be envisioned as a
%   ball with its right and left edges sealed together, and its top and
%   bottom sealed together to themselves.

% Get the dimensions of input matrix
[numRows numCols] = size(A);

%  compute the row from the given column major index
row = mod(index, numRows);
if row == 0 % takes care of the final row
    row = numRows;
end
% compute the column from the given index
col = ceil(index/numRows);

% Check input arguments
if nargin < 3
    if nargin == 2
        numNeighbors = 1;
    else
        error('getSurrounding needs at least 2 arguments.')
    end
end

% initialize the array of neighbors
neighbors = zeros(2*numNeighbors + 1);
% offset used to assign to neighbors matrix
offset = numNeighbors + 1;

% iterate from the left (West) to the right (East)
for horizontal = -numNeighbors:numNeighbors
    % iterate from the top (North) to the bottom (South)
    for vertical = -numNeighbors:numNeighbors
        % compute the current column
        newCol = col + horizontal;
        % check for need to wrap around globe
        if newCol < 1 || newCol > numCols
            % use modulus to wrap around
            newCol = mod(newCol, numCols);
            if newCol == 0 % take care of the last column
                newCol = numCols;
            end
        end
        % compute the current row
        newRow = row + vertical;
        % check if the new row wraps around the bottom of the globe
        if newRow > numRows
            newRow = numRows - mod(newRow, numRows) + 1;
            newCol = mod(floor(newCol - numCols/2), numCols);            
        elseif newRow < 1 % check if the new row wraps around the top
            newRow = 1 + mod(-newRow, numRows);
            newCol = mod(floor(newCol - numCols/2), numCols);            
        end
        if newRow > numRows
            newRow = mod(newRow, numRows);
        end
        if newCol == 0
            newCol = numCols;
        end
        neighbors(vertical+offset, horizontal+offset) = A(newRow, newCol);
    end
end

end

