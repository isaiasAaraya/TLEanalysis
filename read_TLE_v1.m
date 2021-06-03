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

function [longstr1, longstr2, epoch_TLE] = read_TLE_v1()
% Read TLE data from file
fileID = fopen('input/TLE/LAGEOS1_TLE_9621.txt','r');

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
        
        j = j + 2;
    end
    i = i + 1;
    
end

% Close TLE file
fclose(fileID);

end






