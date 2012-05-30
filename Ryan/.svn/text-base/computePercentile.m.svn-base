function percentile = computePercentile( randomResults, p, type )
% COMPUTEPERCENTILE Computes the specified percentile of random trials
% 
% percentile = computePercentile( randomResults, p, type )
% 
% -------------------------------- INPUT --------------------------------
%
% --> randomResults: The results of the randomized trials in a nxmxk matrix
% where n is the number of locations, m is the number of time series each
% of the n locations was compared against, and k is the number of trials.
% That means randomResults(i, j, k) = the result between location i and
% location j on trial k.
% 
% --> p: a value between 0 and 100 indicating the percentile to
% compute
% 
% --> type: either 'local' for computing independent percentile value of
% each row (location), or 'global' for computing a total percentile
% considering all rows at once.
%
% -------------------------------- OUTPUT --------------------------------
% 
% --> percentile: nxm matrix for local, and 1xm matrix for global
% 
% ----------------------------- EXAMPLE -----------------------------
% 
% The following example computes both the local and global percentiles for
% the results of a correlation randomization test:
% 
% % Example of getting the random results for correlation
% [ results, ~ ] = randomize(sstSeries, stormCounts, 100, rowCorr, 'bootstrap');
% % Now compute local and global 95th percentiles
% localp = computePercentile(results, 95, 'local');
% globalp = computePercentile(results, 95, 'global')
% 

switch type
    case 'local'
        % Simply call prctile to compute the percentile at each location
        percentile = prctile( randomResults, p, 3 );

    case 'global'
        
        percentile = NaN(1, size(randomResults, 2));
        
        for i = 1:size(randomResults, 2)
            
            currentResults = randomResults(:, :, i);
            percentile(i) = prctile( currentResults(:), p );
        
        end
        
    otherwise
        error('type not supported')
end
    
end

