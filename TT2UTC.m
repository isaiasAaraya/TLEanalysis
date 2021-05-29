% This function transform TT to UTC

function [t_UTC] = TT2UTC(t_TT)

% determine TAI - UTC = \Delta AT = dAT as published by at:
% "https://hpiers.obspm.fr/iers/bul/bulc/Leap_Second.dat"

if datetime(1972,1,1) <= t_TT && t_TT < datetime(1972,7,1)
    dAT =  10;
elseif datetime(1972,7,1) <= t_TT && t_TT < datetime(1973,1,1)
    dAT =  11; 
elseif datetime(1973,1,1) <= t_TT && t_TT < datetime(1974,1,1)
    dAT =  12;
elseif datetime(1974,1,1) <= t_TT && t_TT < datetime(1975,1,1)
    dAT =  13;
elseif datetime(1975,1,1) <= t_TT && t_TT < datetime(1976,1,1)
    dAT =  14;
elseif datetime(1976,1,1) <= t_TT && t_TT < datetime(1977,1,1)
    dAT =  15;
elseif datetime(1977,1,1) <= t_TT && t_TT < datetime(1978,1,1)
    dAT =  16;
elseif datetime(1978,1,1) <= t_TT && t_TT < datetime(1979,1,1)
    dAT =  17;
elseif datetime(1979,1,1) <= t_TT && t_TT < datetime(1980,1,1)
    dAT =  18;
elseif datetime(1980,1,1) <= t_TT && t_TT < datetime(1981,7,1)
    dAT =  19;
elseif datetime(1981,7,1) <= t_TT && t_TT < datetime(1982,7,1)
    dAT =  20;
elseif datetime(1982,7,1) <= t_TT && t_TT < datetime(1983,7,1)
    dAT =  21;
elseif datetime(1983,7,1) <= t_TT && t_TT < datetime(1985,7,1)
    dAT =  22;    
elseif datetime(1985,7,1) <= t_TT && t_TT < datetime(1988,1,1)
    dAT =  23;
elseif datetime(1988,1,1) <= t_TT && t_TT < datetime(1990,1,1)
    dAT =  24;
elseif datetime(1990,1,1) <= t_TT && t_TT < datetime(1991,1,1)
    dAT =  25;
elseif datetime(1991,1,1) <= t_TT && t_TT < datetime(1992,7,1)
    dAT =  26;
elseif datetime(1992,7,1) <= t_TT && t_TT < datetime(1993,7,1)
    dAT =  27;
elseif datetime(1993,7,1) <= t_TT && t_TT < datetime(1994,7,1)
    dAT =  28;
elseif datetime(1994,7,1) <= t_TT && t_TT < datetime(1996,1,1)    
    dAT =  29;
elseif datetime(1996,1,1) <= t_TT && t_TT < datetime(1997,7,1)
    dAT =  30;
elseif datetime(1997,7,1) <= t_TT && t_TT < datetime(1999,1,1)
    dAT =  31;    
elseif datetime(1999,1,1) <= t_TT && t_TT < datetime(2006,1,1)
    dAT =  32;
elseif datetime(2006,1,1) <= t_TT && t_TT < datetime(2009,1,1)
    dAT =  33;
elseif datetime(2009,1,1) <= t_TT && t_TT < datetime(2012,7,1)
    dAT =  34;
elseif datetime(2012,7,1) <= t_TT && t_TT < datetime(2015,7,1)
    dAT =  35;
elseif datetime(2015,7,1) <= t_TT && t_TT < datetime(2017,1,1)
    dAT =  36;
elseif datetime(2017,1,1) <= t_TT && t_TT < datetime('now') % ONLY valid until 28/12/2021
    dAT = 37;
end

% Compute UTC
t_UTC = t_TT - (dAT + 32.184)/86400;
end