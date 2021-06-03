% This script processes both TLE and POE data and implements several of the
% transformations discussed in the thesis

% coupling (other functions mentioned) 
%            read_POE_v1
%            read_TLE_v1
%            invjday
%            TT2UTC
%            jday
%            coe2rv
%            twoline2rv
%            sgp4
%            teme2eci
%            rv2coe
%            rv2rsw            

%% Handle POE and TLE data

% Import the POE osculating elements
[p_POE, a_POE, ecc_POE, inc_POE, raan_POE, argp_POE, nu_POE, M_POE, epoch_POE] = read_POE_v1();

% Import the TLE data
[longstr1, longstr2, epoch_TLE] = read_TLE_v1();

%% POE TT to UTC conversion

len_POE = length(epoch_POE);
epoch_POE_UTC = zeros(len_POE,1);

% convert the POE time system from TT to UTC
for i=1:len_POE
    
    jd = floor(epoch_POE(i));
    jdfrac = epoch_POE(i) - jd;
    [year, mon, day, hr, minute, sec] = invjday (jd, jdfrac );
    t_TT = datetime(year, mon, day, hr, minute, sec);
    t_UTC(i) = TT2UTC(t_TT);
   
    [jd_UTC, jdfrac_UTC] = jday (t_UTC(i).Year, t_UTC(i).Month, t_UTC(i).Day, t_UTC(i).Hour, t_UTC(i).Minute, t_UTC(i).Second);
    epoch_POE_UTC(i) = jd_UTC + jdfrac_UTC;
end

% Remove POE data points before the first TLE epoch since the Vallado SGP4 libraries don't
% support backward propagation
epoch_before_TLE = find (epoch_POE_UTC < epoch_TLE(1)); % finds the POE epoch indices before the first TLE epoch

% POE osculating elements at epochs are ommited
p_POE (epoch_before_TLE) = [];
a_POE (epoch_before_TLE) = [];
ecc_POE (epoch_before_TLE) = [];
inc_POE (epoch_before_TLE) = [];
raan_POE (epoch_before_TLE) = [];
argp_POE (epoch_before_TLE) = [];
nu_POE (epoch_before_TLE) = [];
M_POE (epoch_before_TLE) = [];
epoch_POE_UTC (epoch_before_TLE) = [];
t_UTC(epoch_before_TLE) = [];

% update the length of POE data points
len_POE = length(epoch_POE_UTC);

% initialise the J2000 r and v matrices
reci_POE = zeros(3,len_POE);
veci_POE = zeros(3,len_POE);

% Compute the J2000 position and velocity
for i=1:len_POE
    
    [reci_POE(:,i), veci_POE(:,i)] = coe2rv ( p_POE(i), ecc_POE(i), inc_POE(i), raan_POE(i), argp_POE(i), nu_POE(i));
    
end

%% TLE Propagation

% Propagate TLE using SGP4 
len_TLE = length(epoch_TLE);

% Interval of propagation is set to 6 hours (360 minutes)
dt_min = 6 * 60; 

% Initialise r and v
satrec_cell = cell(len_TLE,1);
rteme_TLE = zeros(3,len_POE);
vteme_TLE = zeros(3,len_POE);

counter = 0;

% Propagate TLE 
for i=1:len_TLE
     
    [satrec_cell{i}] = twoline2rv (longstr1{i}, longstr2{i}, 'm', 'm', 'a', 72);

    if i == len_TLE 
        pos = find(epoch_POE_UTC >= epoch_TLE(i));
    else
        pos = find((epoch_POE_UTC < epoch_TLE(i+1)) & (epoch_POE_UTC >= epoch_TLE(i)));
    end
    
    for j = 1:length(pos)
        % Find the propagation interval from a given TLE in minutes
        tsince = (epoch_POE_UTC(pos(j)) - epoch_TLE(i)) * 24 * 60;
        
        % Find r and v in TEME frame
        [~, rteme_TLE(:,pos(j)), vteme_TLE(:,pos(j))] = sgp4(satrec_cell{i}, tsince);
         
    end
end

%% TEME to J2000 transformation

% Use the r, v in TEME to obtain osculating elements + r,v in J2000 

% Initialise TLE r and v in J2000 
reci_TLE = zeros(3,len_POE);
veci_TLE = zeros(3,len_POE);

% Initialise TLE osculating elements
p_TLE = zeros(len_POE,1);
a_TLE = zeros(len_POE,1);
ecc_TLE = zeros(len_POE,1);
inc_TLE = zeros(len_POE,1);
raan_TLE = zeros(len_POE,1);
argp_TLE = zeros(len_POE,1);
nu_TLE = zeros(len_POE,1);
M_TLE = zeros(len_POE,1);

% Assign ddpsi and ddeps values (EOP corrections) - from IERS's
% EDPCO4
ddpsi = -0.052195; % in arcseconds
ddeps = -0.003875; % in arcseconds
ddpsi = ddpsi * pi/(180 * 3600); % in rads
ddeps = ddeps * pi/(180 * 3600); % in rads


for i = 1:len_POE
    
    % Set acceleration to zero
    ateme_TLE = zeros(3,1);
  
    % Find Julian century of TT from base epoch (J2000)
    JD_tt = (epoch_POE_UTC(i) - 2451545)/36525;
    
    % Find r and v in J2000
    [reci_TLE(:,i), veci_TLE(:,i), aeci_TLE] = teme2eci ( rteme_TLE(:,i), vteme_TLE(:,i), ateme_TLE, JD_tt, ddpsi, ddeps);
    
    % Find osculating elements using J2000 r and v
    [p_TLE(i), a_TLE(i), ecc_TLE(i), inc_TLE(i), raan_TLE(i), argp_TLE(i), nu_TLE(i), M_TLE(i)] = rv2coe (reci_TLE(:,i)',veci_TLE(:,i)');
       
end


%% J2000 to RSW transformation

% Initialise RSW r and v vectors
rrsw_POE = zeros(3,len_POE); 
vrsw_POE = zeros(3,len_POE);
rrsw_TLE = zeros(3,len_POE); 
vrsw_TLE = zeros(3,len_POE);
r_TLE  = zeros(1,len_POE);
r_POE  = zeros(1,len_POE);
v_TLE  = zeros(1,len_POE);
v_POE  = zeros(1,len_POE);

% Compute the RSW r and v using transformation matrix 'transmat'
for i = 1:len_POE
    % Transform from J2000 to RSW
   [rrsw_POE(:,i), vrsw_POE(:,i), transmat] = rv2rsw(reci_POE(:,i), veci_POE(:,i));
   rrsw_TLE(:,i) = transmat * reci_TLE(:,i);  
   vrsw_TLE(:,i) = transmat * veci_TLE(:,i);
   
   % Calculate position and velocity error magnitude
   r_err(i) = norm(rrsw_TLE(:,i)-rrsw_POE(:,i));
   v_err(i) = norm(vrsw_TLE(:,i)-vrsw_POE(:,i));

end

% Store the TLE and POE data as workspace
% Lageos-1
save('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/output_TLE_LAGEOS1.mat','p_TLE','a_TLE','ecc_TLE','inc_TLE','raan_TLE','argp_TLE','nu_TLE','M_TLE','epoch_TLE','reci_TLE','veci_TLE','rrsw_TLE','vrsw_TLE')
save('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/output_POE_LAGEOS1.mat','p_POE','a_POE','ecc_POE','inc_POE','raan_POE','argp_POE','nu_POE','M_POE','reci_POE','veci_POE','rrsw_POE','vrsw_POE')

%% Error Analysis

% Calculate the absolute diff in position RSW
rerr_r = abs(rrsw_POE(1,:) - rrsw_TLE(1,:));
serr_r = abs(rrsw_POE(2,:) - rrsw_TLE(2,:));
werr_r = abs(rrsw_POE(3,:) - rrsw_TLE(3,:));

% Calculate the absolute diff in velocity RSW
rerr_v = abs(vrsw_POE(1,:) - vrsw_TLE(1,:));
serr_v = abs(vrsw_POE(2,:) - vrsw_TLE(2,:));
werr_v = abs(vrsw_POE(3,:) - vrsw_TLE(3,:));

% Calculate the absolute diff in osculating elements
a_err = abs(a_POE' - a_TLE);

ecc_err = abs(ecc_POE' - ecc_TLE);

% If error is greater than pi, then adjust such that the error is 2pi -
% error
inc_err = abs(inc_POE' - inc_TLE);
inc_err(find(inc_err > pi)) = 2 * pi - inc_err(find(inc_err > pi));

argp_err = abs(argp_POE' - argp_TLE);
argp_err(find(argp_err > pi)) = 2 * pi - argp_err(find(argp_err > pi));

raan_err = abs(raan_POE' - raan_TLE);
raan_err(find(raan_err > pi)) = 2 * pi - raan_err(find(raan_err > pi));

nu_err = abs(nu_POE' - nu_TLE);
nu_err(find(nu_err > pi)) = 2 * pi - nu_err(find(nu_err > pi));

M_err = abs(M_POE' - M_TLE);
M_err(find(M_err > pi)) = 2 * pi - M_err(find(M_err > pi));

%% Exclude Outliers

% Outliers tolerance as multiple of mean of position error
cutoff = 5; 

outlier_loc = find(r_err > cutoff * mean(r_err));

% Update data length
epoch_POE_UTC(outlier_loc) = [];
len_POE = length(epoch_POE_UTC);

% Exclude outlier data in errors in r,v and osculating elements
rerr_r(outlier_loc) = [];
serr_r(outlier_loc) = [];
werr_r(outlier_loc) = [];
rerr_v(outlier_loc) = [];
serr_v(outlier_loc) = [];
werr_v(outlier_loc) = [];

a_err(outlier_loc) = [];
ecc_err(outlier_loc) = [];
inc_err(outlier_loc) = [];
argp_err(outlier_loc) = [];
raan_err(outlier_loc) = [];
nu_err(outlier_loc) = [];
M_err(outlier_loc) = [];
t_UTC(outlier_loc) = [];
r_err(outlier_loc) = [];
v_err(outlier_loc) = [];
% Save the error result as a workspace

% Lageos-1
save('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/output/output_error_LAGEOS1.mat','rerr_r','serr_r','werr_r','rerr_v','serr_v','werr_v','a_err','inc_err','ecc_err','nu_err','argp_err','raan_err','M_err','t_UTC','epoch_POE_UTC','r_err','v_err')

%% Analyse TLE Data

% find the time interval between publication
for i=1:length(epoch_TLE) - 1
    
    diff_tpub(i) =  epoch_TLE(i+1) - epoch_TLE(i);
    
end

diff_tpub = diff_tpub * 24;
