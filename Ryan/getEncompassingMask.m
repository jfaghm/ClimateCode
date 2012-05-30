function encMask = getEncompassingMask( outer, inner )
%GETENCOMPASSINGMASK Determine which outer boxes encompass which inner boxes
%
%   encMask = getEncompassingMask( outer, inner )
%
%   Gets a mask indicating which outer boxes are encompassing which inner
%   boxes or, alternatively, which inner boxes are inside of which outer
%   boxes.
%
% ------------------------------INPUT------------------------------
% 
% --> outer - A 2D matrix where each row is the latlims and lonlims of
% a rectangular region of the earth.
% --> inner - A 2D matrix where each row is the latlims and lonlims of
% a rectangular region of the earth.
% 
% Each row should be
%
% ------------------------------OUTPUT------------------------------
%
% --> encMask - A logical mask which has the same number of rows as outer
% and the number of columns equal to the number of rows of inner.  This
% means that each row represents one outer box, and each column represents
% one inner box.  Each entry of encMask, encMask(i, j) is true if the box
% at outer(i, :) encompasses the box at inner(j, :).
%
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example determines which storm boxes encompass which sst boxes
% % and computes correlations between them, masking out non-encompassing
% % pairs.  Assumes that we have allBoxStorms and allBoxSST (see
% % getAllBoxStormCounts and getAllBoxData for more info)
% encMask = getEncompassingMask( allBoxStorms(:, 1:4), allBoxSST(:, 1:4)); 
% allCorrelations = rowCorr( allBoxStorms(:, 5:end), allBoxSST(:, 5:end) );
% allCorrelations(encMask) = NaN;
% % Now all entries of allCorrelations which correspond to a storm box not
% % encompassing an sst box are NaN
% 

numOuterBoxes = size(outer, 1);
numInnerBoxes = size(inner, 1);

encMask = true(numOuterBoxes, numInnerBoxes);

try
    matlabpool('open', 8)
    poolOpened = true;
catch
    poolOpened = false;
end
    
parfor i = 1:numOuterBoxes
    
    outerBox = outer(i, :);
    
    currOuterBoxMask = isEncompassing(outerBox, inner);
    
    encMask(i, :) = currOuterBoxMask';

end

if poolOpened
    matlabpool('close')
end

    
end