% This function parses TLE data, returning each line as a string, alongside
% the corresponding epoch

% output    longstr1 - first line of a TLE
%           longstr2 - second line of a TLE
%           epoch_TLE - TLE epoch in UTC

% coupling (other functions mentioned)
%            twoline2rv
%            sgp4
%            teme2eci
%            rv2coe


function [longstr1, longstr2, epoch_TLE] = read_TLE_v2()
% Read TLE data from file
fileID = fopen('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/input/TLE/LAGEOS1_TLE_6y.txt','r');

 % tracks TLE lines (=1 if the line is not at the end of TLE, =0 if its the last line)
tle_checker = 1;
j = 0;
i = 1;

% If TLE is not fully parsed then save lines into a string
while tle_checker == 1
    
    if mod(j,2) == 0
        longstr1{i} = fgetl(fileID);
        longstr2{i} = fgetl(fileID);
        
        % If longstr1 is not a char, then break the loop and finish
        if ~isa(longstr1{i},'char')
            tle_checker = 0;
            longstr1{i} = [];
            longstr2{i} = [];
            break;
        end
        
        % Use SGP4 libraries to obtain the epoch in UTC
        [satrec{i}] = twoline2rv(longstr1{i}, longstr2{i}, 'm', 'm', 'a', 72);
        [satrec{i}, rteme(:,i), vteme(:,i)] = sgp4(satrec{i},0);
        epoch_TLE(i) = satrec{i}.jdsatepoch + satrec{i}.jdsatepochf;
        
        % TEME to ECI transformation
        % Find Julian century of TT from base epoch (J2000)
        JD_tt = (epoch_TLE(i)-2451545)/36525;
        
        % Assign ddpsi and ddeps values (EOP corrections) - from IERS's
        % EDPCO4
        ddpsi = -0.052195; % in arcseconds
        ddeps = -0.003875; % in arcseconds
        ddpsi = ddpsi * pi/(180 * 3600); % in rads
        ddeps = ddeps * pi/(180 * 3600); % in rads
        
        % Find r and v in ECI(J2000) using TEME r and v
        ateme = zeros(3,1);
        
        [reci(:,i), veci(:,i), aeci] = teme2eci ( rteme(:,i), vteme(:,i), ateme, JD_tt, ddpsi, ddeps);
        
        % Find osculating elements using the r and v in ECI 
        [p(i), a(i), ecc(i), inc(i), raan(i), argp(i), nu(i), m(i), arglat(i)] = rv2coe (reci(:,i)',veci(:,i)');
        
        
        j = j + 2;
    end
    
    i = i + 1;
    
end

fclose(fileID);

% save initial TLE data into the object.txt file to be used by thalassa
fileID = fopen('/Users/isaiasaraya/Desktop/FYP/TLEanalysis-master/thalassa-master/in/object.txt','w');
fprintf( fileID, '# THALASSA - OBJECT PARAMETERS \n');
fprintf( fileID, '# ============================================================================== \n');
fprintf( fileID, '# Initial epoch and orbital elements \n');
MJD = epoch_TLE(1) - 2400000.5;
fprintf( fileID, '%+.11f%sE+00; MJD  [UTC]\n', MJD, num2str(zeros(5-numel(num2str(floor(MJD))),1)));
fprintf( fileID, '%+.11f%sE+00; SMA  [km]\n', a(1), num2str(zeros(5-numel(num2str(floor(a(1)))),1)));
fprintf( fileID, '%+.11f%sE+00; ECC  [-]\n', ecc(1), num2str(zeros(5-numel(num2str(floor(ecc(1)))),1)));
fprintf( fileID, '%+.11f%sE+00; INC  [deg]\n', inc(1)*180/pi, num2str(zeros(5-numel(num2str(floor(inc(1)*180/pi))),1)));
fprintf( fileID, '%+.11f%sE+00; RAAN [deg]\n', raan(1)*180/pi, num2str(zeros(5-numel(num2str(floor(raan(1)*180/pi))),1)));
fprintf( fileID, '%+.11f%sE+00; AOP  [deg]\n', argp(1)*180/pi, num2str(zeros(5-numel(num2str(floor(argp(1)*180/pi))),1)));
fprintf( fileID, '%+.11f%sE+00; M    [deg]\n', m(1)*180/pi, num2str(zeros(5-numel(num2str(floor(m(1)*180/pi))),1)));
fprintf( fileID, '# Physical characteristics \n');
fprintf( fileID, '+406.9650000000000E+00; Mass [kg] \n');
fprintf( fileID, '+0.282700000000000E+00; Area (drag) [m^2] \n');
fprintf( fileID, '+0.282700000000000E+00; Area (SRP)  [m^2] \n');
fprintf( fileID, '+2.200000000000000E+00; CD   [-] \n');
fprintf( fileID, '+1.500000000000000E+00; CR   [-] \n');

% Close TLE file
fclose(fileID);


end


