% coupling (other functions mentioned) 
%            LAGEOS1_TLE
%            LAGEOS1_POE
%            invjday
%            TT2UTC
%            jday
%            Interpolate_lin
%            coe2rv
%            rv2rsw

clear
clc
close all

%% Handle thalassa and TLE data

% retrieve the thalassa osculating elements
[p_th, a_th, ecc_th, inc_th, raan_th, argp_th, nu_th, M_th, epoch_th] = read_thalassa();


% retrieve the TLE data
[longstr1, longstr2, epoch_TLE] = read_TLE_v2();

len_th = length(epoch_th);

%% Analyse TLE Data
% Propagate using SGP4 
len_TLE = length(epoch_TLE);

dt_min = 36; % interval of propagation in minutes

satrec_cell = cell(len_TLE, 1);
rteme_TLE = zeros(3, len_th);
vteme_TLE = zeros(3, len_th);

counter = 0;

for i = 1:len_TLE - 1
     
    [satrec_cell{i}] = twoline2rv (longstr1{i}, longstr2{i}, 'm', 'm', 'a', 72);

    if i == 1
        pos = find(epoch_th < epoch_TLE(i+1));
    else
        pos = find((epoch_th < epoch_TLE(i+1)) & (epoch_th >= epoch_TLE(i)));
    end
    
    
    for j = 1:length(pos)
        
        tsince = (epoch_th(pos(j)) - epoch_TLE(i)) * 1440; % time since TLE epoch in mins
        
        epoch_TLE_prop(pos(j)) = epoch_TLE(i) + tsince/1440;
        
        [~, rteme_TLE(:, pos(j)), vteme_TLE(:, pos(j))] = sgp4(satrec_cell{i}, tsince);
         
    end
    
end

if ~isempty(pos)
    rteme_TLE (:,pos(end)+1:end) = [];
    vteme_TLE (:,pos(end)+1:end) = [];
    epoch_th (pos(end)+1:end) = [];
    epoch_TLE_prop (pos(end)+1:end) = [];
    
    % Update thalassa elements
    p_th (pos(end)+1:end) = [];
    a_th (pos(end)+1:end) = []; 
    ecc_th (pos(end)+1:end) = [];
    inc_th (pos(end)+1:end) = [];
    raan_th (pos(end)+1:end) = [];
    argp_th (pos(end)+1:end) = [];
    nu_th (pos(end)+1:end) = [];
    M_th (pos(end)+1:end) = [];
end

% update len_th
len_th = length(epoch_th);

% use the r, v in TEME to obtain osculating elements + r,v in ECI 

% Initialise
reci_TLE = zeros(3,len_th);
veci_TLE = zeros(3,len_th);

p_TLE = zeros(len_th,1);
a_TLE = zeros(len_th,1);
ecc_TLE = zeros(len_th,1);
inc_TLE = zeros(len_th,1);
raan_TLE = zeros(len_th,1);
argp_TLE = zeros(len_th,1);
nu_TLE = zeros(len_th,1);
M_TLE = zeros(len_th,1);

% Assign ddpsi and ddeps values (EOP corrections) - from IERS's
% EDPCO4
ddpsi = -0.052195; % in arcseconds
ddeps = -0.003875; % in arcseconds
ddpsi = ddpsi * pi/(180 * 3600); % in rads
ddeps = ddeps * pi/(180 * 3600); % in rads

for i = 1:len_th
    
    % Find r and v in ECI
    ateme_TLE = zeros(3,1);
    
    % TEME to ECI transformation
    % Find Julian century of TT from base epoch (J2000)
    JD_tt = (epoch_th(i) - 2451545)/36525;
    
    [reci_TLE(:,i), veci_TLE(:,i), aeci_TLE] = teme2eci ( rteme_TLE(:,i), vteme_TLE(:,i), ateme_TLE, JD_tt, ddpsi, ddeps);
    
    % Find osculating elements using ECI r,v
    [p_TLE(i), a_TLE(i), ecc_TLE(i), inc_TLE(i), raan_TLE(i), argp_TLE(i), nu_TLE(i), M_TLE(i)] = rv2coe (reci_TLE(:,i)',veci_TLE(:,i)');
       
end

%% Analyse thalassa data

% initialise the r and v matrices
reci_th = zeros(3,len_th);
veci_th = zeros(3,len_th);

% nu_thh = nu_th;
nu_th(find(nu_th < 0)) = nu_th(find(nu_th < 0)) + 2 * pi;
for i=1:len_th
    
    [reci_th(:,i), veci_th(:,i)] = coe2rv ( p_th(i), ecc_th(i), inc_th(i), raan_th(i), argp_th(i), nu_th(i));
    
end

%% General Data Analysis

% Find the dates
for i=1:len_th
    
    jd = floor(epoch_th(i));
    jdfrac = epoch_th(i) - jd;
    [year, mon, day, hr, minute, sec] = invjday (jd, jdfrac );
    t_UTC(i) = datetime(year, mon, day, hr, minute, sec);
end

% Transforming to RSW frame from ECI
rrsw_th = zeros(3, len_th); 
vrsw_th = zeros(3, len_th);
rrsw_TLE = zeros(3, len_th); 
vrsw_TLE = zeros(3, len_th);

for i = 1:len_th
    
   % Transform from J2000 to RSW
   [rrsw_th(:, i), vrsw_th(:,i), transmat] = rv2rsw(reci_th(:,i), veci_th(:,i));
   rrsw_TLE(:, i) = transmat * reci_TLE(:,i);  
   vrsw_TLE(:, i) = transmat * veci_TLE(:,i);
   
   % Calculate position and velocity error magnitude
   r_err(i) = norm(rrsw_TLE(:,i)-rrsw_th(:,i));
   v_err(i) = norm(vrsw_TLE(:,i)-vrsw_th(:,i));
   
end

% save TLE and thalassa data
save('output/data_TLE_LAGEOS1.mat','p_TLE','a_TLE','ecc_TLE','inc_TLE','raan_TLE','argp_TLE','nu_TLE','M_TLE','epoch_TLE','reci_TLE','veci_TLE','rrsw_TLE','vrsw_TLE')
save('output/data_thalassa_LAGEOS1.mat','p_th','a_th','ecc_th','inc_th','raan_th','argp_th','nu_th','M_th','epoch_th','t_UTC','reci_th','veci_th','rrsw_th','vrsw_th')

%% Error Analysis

% Calculate the absolute diff in position XYZ

xerr = abs(reci_th(1,:) - reci_TLE(1,:));
yerr = abs(reci_th(2,:) - reci_TLE(2,:));
zerr = abs(reci_th(3,:) - reci_TLE(3,:));

% Calculate the absolute diff in position RSW
rerr_r = abs(rrsw_th(1,:) - rrsw_TLE(1,:));
serr_r = abs(rrsw_th(2,:) - rrsw_TLE(2,:));
werr_r = abs(rrsw_th(3,:) - rrsw_TLE(3,:));

% Calculate the absolute diff in velocity RSW
rerr_v = abs(vrsw_th(1,:) - vrsw_TLE(1,:));
serr_v = abs(vrsw_th(2,:) - vrsw_TLE(2,:));
werr_v = abs(vrsw_th(3,:) - vrsw_TLE(3,:));

% calculate the absolute diff in velocity osculating elements
a_err = abs(a_th - a_TLE);

ecc_err = abs(ecc_th - ecc_TLE);

% if error is greater than pi, then adjust such that the error is the
% smallest difference
inc_err = abs(inc_th - inc_TLE);
inc_err(find(inc_err > pi)) = 2*pi - inc_err(find(inc_err > pi));

argp_err = abs(argp_th - argp_TLE);
argp_err(find(argp_err > pi)) = 2*pi - argp_err(find(argp_err > pi));

raan_err = abs(raan_th - raan_TLE);
raan_err(find(raan_err > pi)) = 2*pi - raan_err(find(raan_err > pi));

nu_err = abs(nu_th' - nu_TLE);
nu_err(find(nu_err > pi)) = 2*pi - nu_err(find(nu_err > pi));

M_err = abs(M_th - M_TLE);
M_err(find(M_err > pi)) = 2*pi - M_err(find(M_err > pi));

%% Analyse TLE Data

% find the time interval between publication
for i=1:length(epoch_TLE) - 1
    diff_tpub(i) =  epoch_TLE(i+1) - epoch_TLE(i);
end

diff_tpub = diff_tpub * 24;
save('output/errs_LAGEOS1.mat','rerr_r','serr_r','werr_r','rerr_v','serr_v','werr_v','a_err','inc_err','ecc_err','nu_err','argp_err','raan_err','M_err','r_err','v_err')
