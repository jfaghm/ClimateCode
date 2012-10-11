function NTC = computeNTC( stormData, basePeriod, computePeriod, varargin )
% COMPUTENTC Computes net tropical cyclone activity
% 
% NTC = computeNTC( stormData, basePeriod, computePeriod )
% NTC = computeNTC( stormData, basePeriod, computePeriod, ParamName1, Value1, ... )
% 
% The formula for NTC is as follows:
% NTC = 100 * ((NS/Ave_NS) + (NSD/Ave_NSD) + (H/Ave_H) + (HD/Ave_HD) +
% (IH/Ave_IH) + (IHD/Ave_IHD)) / 6
% where
% NS = number of named storms (>= tropical storm), NSD = number of days with named storm
% present, H = number of hurricanes (category >= 1), HD = number of days
% with hurricane present, IH = number of intense hurricanes, IHD = number
% of days with intense hurricanes present.
% 
% -------------------- INPUT -------------------- 
% --> stormData: The HURDAT hurricane data set with the following columns: 
% Storm Number, Year, Month, Day, Hour (UTC), Latitude (degrees North),
% Longitude (degrees East), Hurricane Direction (degrees), Hurricane Speed
% (mph), Wind Speed (mph), Pressure (mbar), Type (see hurDatTypes)'
% 
% --> basePeriod: A vector, [startYear endYear], specifiying the period to
% use for averages
% 
% --> computePeriod: A vector, [startYear endYear], specifiying the period
% to compute the NTC for
% 
% -- Possible param/value pair arguments:
% 'countDuplicates' - indicates whether multiple storms present during the
% same period count as a single storm day or multiple storm days.  If true,
% multiple storms count as multiple days.  Otherwise, they count as single
% days.  Default is false.
% 'months' - a vector indicating the months over which to count storms.
% default is the entire year, i.e. 1:12
% 
% -------------------- OUTPUT --------------------
% --> NTC: A vector of length equal to the length of the year range
% specified in computePeriod.  NTC(i) is the net tropical cyclone activity
% computed for the ith year in the range.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% The following examples computes the NTC for the years 1971-2010, using the
% years 1950-2000 as a base period
% 
% % Load the complete HURDAT data set
% load /project/expeditions/haasken/data/stormData/atlanticStorms/HurDat_1851_2010.mat
% % Compute the NTC activity for all months, not counting duplicates
% NTC = computeNTC(hurDat, [ 1950 2000 ], [ 1971 2010 ])
% % Also compute the NTC activity for only Jun-Oct, counting duplicates
% NTC2 = computeNTC(hurDat, [1950 2000 ], [ 1971 2010 ], 'countDuplicates', true, 'months', 6:10)
% 


p = inputParser;
p.addRequired('stormData', @ismatrix);
p.addRequired('basePeriod', @(x)isvector(x) && length(x) == 2 && x(1) <= x(2));
p.addRequired('computePeriod', @(x)isvector(x) && length(x) == 2 && x(1) <= x(2));
p.addParamValue('countDuplicates', false, @islogical);
p.addParamValue('months', 1:12, @(x)isvector(x) && min(x) > 0 && max(x) <= 12);
p.FunctionName = 'computeNTC';
p.CaseSensitive = false;
p.parse(stormData, basePeriod, computePeriod, varargin{:});

countDuplicates = p.Results.countDuplicates;

% Take only the storms occurring in the given months
monthMask = ismember(stormData(:, 3), p.Results.months);
stormData = stormData(monthMask, :);

basePeriodStats = stormStats(stormData, basePeriod(1), basePeriod(2), countDuplicates);
aveStats = mean(basePeriodStats, 1);

stats = stormStats(stormData, computePeriod(1), computePeriod(2), countDuplicates);
NTC = stats ./ repmat(aveStats, size(stats, 1), 1);
NTC = mean(NTC, 2) * 100;


end