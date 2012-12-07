%returns the NINO index for a given month/year range
%NINO types:
% NINO1.2 = 1
% NINO3.4 = 2
% NINO3 = 3
% NINO4 = 4
function index = getNINO(start_year,end_year,start_month,end_month,type)
load monthly_nino_data.mat
switch type
    case 1
        data_column = 4;
    case 2
        data_column = 10;
    case 3
        data_column = 6;
    case 4 
        data_column = 8;
    otherwise
        error('NINO type must be 1,2,3, or 4');
end
        
    nino_data = data(data(:,1)>=start_year & data(:,1)<=end_year & data(:,2)>=start_month & data(:,2)<=end_month,[1 2 data_column]);
    years = unique(nino_data(:,1));
    index = zeros(1,length(years));
    for i =1:length(years)
       index(i) = mean(nino_data(nino_data(:,1)==years(i),3)); 
    end

