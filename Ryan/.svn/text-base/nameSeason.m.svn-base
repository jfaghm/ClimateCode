function seasonName = nameSeason( seasonMonths )
% NAMESEASON Creates a string naming the season specified by seasonMonths
% 
% seasonName = nameSeason( seasonMonths )

if length(seasonMonths) == 1
    seasonName = datestr([ 2000 seasonMonths 1 0 0 0 ], 'mmm');
else
    seasonName = [ datestr([ 2000 seasonMonths(1) 1 0 0 0], 'mmm') '-' ...
        datestr([2000 seasonMonths(end) 1 0 0 0 ], 'mmm') ];
end

end