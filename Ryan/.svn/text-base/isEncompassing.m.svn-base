function enc = isEncompassing( encompassing, encompassed )
%ISENCOMPASSING Indicates whether a box encompasses another
% 
% enc = isEncompassing( encompassing, encompassed )
% 
%   Indicates whether one box encompasses another.
% 
% ----------------------------- INPUT -----------------------------
% 
% --> encompassing - The box to check to see if is is encompassing the
% other box.  It should have the latitude and longitude limits of the box
% in a row vector in the following format:
% 
%   [ latLim1 latLim2 westLonLim eastLonLim ]
% 
% --> encompassed - The boxes to check whether the other box encompass.  It
% should have the longitude and latitude limits of each box on its own row
% in the same format as shown above.
% 
% ----------------------------- INPUT -----------------------------
% 
% --> enc - A boolean column vector indicating which boxes in encompassed
% are encompassed by encompassing box.  enc(i) indicates whether
% encompassing box encompasses the box at encompassed(i, :)
% 
% **Primarily used as an auxiliary function in getEncompassingMask**
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume we have allBoxSST and find SST boxes which are encompassed by
% % the east atlantic storm box
% eatlBox = [ 5 25 -45 -10 ];
% mask = isEncompassing( eatlBox, allBoxSST(:, 1:4) );
% encompassedSSTBoxes = allBoxSST(mask, :);
% 

numInnerBoxes = size(encompassed, 1);

if size(encompassing, 1) ~= 1
    error('There can only be one encompassing box')
end

outerlatlims = repmat( encompassing(1:2), numInnerBoxes, 1 ) ;
outerlonlims = repmat( encompassing(3:4), numInnerBoxes, 1 ) ;
innerlatlims = encompassed(:, 1:2);
innerlonlims = encompassed(:, 3:4);

outerWest = outerlonlims(1, 1);

outerlonlims = mod(outerlonlims - outerWest, 360);
innerlonlims = mod(innerlonlims - outerWest, 360);

encLats = ( max(outerlatlims(1, :)) >= max(innerlatlims, [], 2) ) &  ...
    ( min(outerlatlims(1, :)) <= min(innerlatlims, [], 2) );


orderedLons = [outerlonlims(:, 1) innerlonlims(:, 1) innerlonlims(:, 2) outerlonlims(:, 2)];
encLons = all( diff(orderedLons, [], 2) >= 0, 2);

enc = encLats & encLons;

end
