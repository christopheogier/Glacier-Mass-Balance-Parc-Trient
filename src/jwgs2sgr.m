function [N,E,h] = jwgs2sgr(PHI,L,H)
%
% function [N,E,h] = jwgs2sgr(PHI,L,H)
% Transformation according to
% Bundesamt für Landestopographie, p.11 (accuracy ~1m)
% To see: file:///C:/Users/CHRIST~2/AppData/Local/Temp/ch1903wgs84_e.pdf
% Bern: y = 2600000, x = 1200000 (LV95)
%
% Input ( -> output from jreadgga):
%   PHI latitude/northing  [decimal degrees]
%   L   longitude/easting  [decimal degrees]
%   H   orthometric height [m]
% Ouput:
%   N, E, z [m] swissgrid coordinates LV95 (N North, E East)
% Optionnal output:
%  x,y,z [m] swissgrid coordinates CH03 (x North, y East)
%
% Jan Walbrecker, 25.07.07
% ed. 08.10.07
% ed. 02.09.21 by Christophe Ogier to add LV95 ("new" swisscoordinates) option
% =========================================================================

% testparameter
% PHI = 46 + 2/60 + 38.87/3600;
% L = 8 + 43/60 + 49.79/3600;
% H = 650.6;

PHI = ((PHI*3600) - 169028.66)/10000;
L =   ((L*3600)   - 26782.5)  /10000;

y =   600072.37              ...
    + 211455.93 * L          ...
    -  10938.51 * L .* PHI    ...
    -     0.36  * L .* PHI.^2  ...
    -    44.54  * L.^3;
E = y + 2000000.00; %LV95
    
x =   200147.07                ...
    + 308807.95        * PHI   ...
    +   3745.25 * L.^2         ...
    +     76.63        .* PHI.^2 ...
    -    194.56 * L.^2 .* PHI    ...
    +    119.79        .* PHI.^3;
N = x + 1000000.00; %LV95

h =          H              ...
    -    49.55              ...
    +     2.73 * L          ...
    +     6.94     * PHI;

