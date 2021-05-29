% This function reads THALASSA output from a text file and returns
% the osculating elements in arrays for processing

function [p, a, ecc, inc, raan, argp, nu, M, epoch_thalassa] = read_thalassa()

% Read THALASSA data
data = readtable('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/input/thalassa/orbels.dat');
data  = table2array(data);

% Assign the MJD and find the epoch in UTC
MJD = data(:,1);
epoch_thalassa = MJD + 2400000.5;

% Assign the orbital elements
a = data(:,2);
ecc = data(:,3);
inc = data(:,4) * pi/180;
raan = data(:,5) * pi/180;
argp = data(:,6) * pi/180;
M = data(:,7) * pi/180;
p = a.*(1-ecc.^2);

% Compute the true anomaly using the mean anomaly
for i = 1:length(M)
    
    [~ ,nu(i)] = newtonm ( ecc(i), M(i) );
    
end

end