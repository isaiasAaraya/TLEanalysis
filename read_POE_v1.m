% coupling (other functions mentioned) - 'POE_READER' in python script
% 'POE_LAGEOS_v1.py'
                                        
% Define function to obtaine POE osculating elements from a python function 
function [p, a, ecc, inc, raan, argp, nu, m, epoch_POE] = read_POE_v1()

% Obtains the POE data and store them in correct variables
res = py.POE_LAGEOS_v1.POE_READER(); % Read from python script

res = cell(res);

% Assing the osculating elements 
ecc = cell2mat(cell(res{1}));
inc = cell2mat(cell(res{2}));
raan = cell2mat(cell(res{3}));
argp = cell2mat(cell(res{4}));
n = cell2mat(cell(res{5}));
m = cell2mat(cell(res{6}));
nu = cell2mat(cell(res{7})); 
a = cell2mat(cell(res{8}));
epoch_POE = cell2mat(cell(res{9})); 

% Calculate the semi-parameter using semi-major axis and eccentricity
p = a.*(1-ecc.^2);

end

