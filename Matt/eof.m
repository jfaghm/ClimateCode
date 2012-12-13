function [map, ts] = eof(data, i)
%main file
s1 = size(data, 1);
s2 = size(data, 2);
data = reshape(data, s1*s2, []);
[map,ts] = EOFAnalysis(data, i);
map = reshape(map, s1,s2);
end

%function to compute EOF
function [map,ts] = EOFAnalysis(Data, num_of_eof)
% load sstAtlanticBasin.mat;
% Data = sstAtlanticBasin;
%num_of_eof = 1; %number of eofs u want = 1

Data(isnan(Data))=-99.99;
oceanIndex = find(Data(:,1)~=-99.99);
F = Data(oceanIndex,:);
R = F'*F;
[C,L] = eig(R);

% generate PC and corressponding timeseries
for jj = 1:num_of_eof
    PCi= F* C(:,end - jj+1);
    ts = F'*PCi;
end

map = zeros(size(Data,1),1);
map(oceanIndex) = PCi;

end