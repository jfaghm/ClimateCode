prefix = '/export/scratch/haasken/EraInterimData/matfiles/';

vars = { 'uWind', 'vWind' };

pressureLevels = { '200', '500', '700', '850' };
numPL = length(pressureLevels);

for year = 1989:2010
    yearString = num2str(year);
    for var = 1:2
        currentVariable = vars{var};
        for p = 1:numPL
            filename = [prefix currentVariable pressureLevels{p} '_' yearString '.mat'];
            
            load(filename)
            
            data = eval([ currentVariable pressureLevels{p} ]);
            
            save(filename, 'data')
        end
    end
end


vars = {'sst', 'mslp'};

for year = 1989:2010
    yearString = num2str(year);
    for var = 1:2
        currentVariable = vars{var};
        filename = [prefix currentVariable yearString '.mat'];
        
        load(filename)
        
        data = eval(currentVariable);
        
        save(filename, 'data')
    end
end
