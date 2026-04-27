%% File path
file = 'C:/Users/christopher/Desktop/home/GitHub/Glacier-Mass-Balance-Parc-Trient/data/20260426_Trient/snowpit.txt';

%% Read all lines
lines = readlines(file);

% Remove empty lines
lines = strip(lines);
lines(lines == "") = [];

% Keep only lines that start with a number
is_data = ~cellfun(@isempty, regexp(cellstr(lines), '^\d+', 'once'));
data_lines = lines(is_data);

% Convert to numbers
data = sscanf(join(data_lines, newline), '%f %f', [2 Inf])';

h = data(:,1);   % cm
m = data(:,2);   % g

disp(data)

%% Extract coordinates from header
coord_line = lines(contains(lines, 'coordinates'));

vals = sscanf(coord_line, 'coordinates: %f %f');
lat0 = vals(1);
lon0 = vals(2);

% Convert to LV95
[N0, E0, ~] = jwgs2sgr(lat0, lon0, 0);

%% Parameters
tare = 1030;      % g
diameter = 94;    % mm

%% Convert units
h_m = h / 100;                 % cm -> m
r = (diameter / 1000) / 2;     % mm -> m

%% Density
V = pi * r^2 .* h_m;           % m3
m_snow = (m - tare) / 1000;    % kg
rho = m_snow ./ V;             % kg/m3

%% Depth profile
depth_top = [0; cumsum(h_m(1:end-1))];
depth_bottom = cumsum(h_m);

%% Mean density (thickness-weighted)
rho_mean = sum(rho .* h_m) / sum(h_m);

%% Plot
figure; hold on

% Density bars
for i = 1:length(h_m)
    plot([rho(i) rho(i)], [depth_top(i) depth_bottom(i)], ...
        'k', 'LineWidth', 4)
end

% Mean density line
plot([rho_mean rho_mean], [0 max(depth_bottom)], ...
    'k--', 'LineWidth', 2)

% Ice lens (thicker visual: 5 cm)
ice_depth = 0.35;        % m
ice_thickness = 0.05;    % m (visual, not physical)

x_min = min(rho) - 20;
x_max = max(rho) + 20;

patch( ...
    [x_min x_max x_max x_min], ...
    [ice_depth ice_depth ice_depth+ice_thickness ice_depth+ice_thickness], ...
    [0.5 0.5 0.5], ...
    'FaceAlpha', 0.3, ...
    'EdgeColor', 'none' ...
);

% Ice lens label
text(x_max, ice_depth + ice_thickness/2, ' ice lens', ...
    'VerticalAlignment', 'middle', ...
    'HorizontalAlignment', 'right')

% Mean density label
text(rho_mean, 0.2, sprintf('Mean = %.0f kg m^{-3}', rho_mean), ...
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'bottom')

%% Formatting
set(gca, 'YDir', 'reverse')
xlabel('Density (kg m^{-3})')
ylabel('Depth (m)')
title(sprintf('Snow density profile (%d, %d)', round(E0), round(N0)))
grid on

xlim([x_min x_max])
ylim([0 max(depth_bottom)])

out_fig = 'C:/Users/christopher/Desktop/home/GitHub/Glacier-Mass-Balance-Parc-Trient/data/20260426_Trient/snow_density_profile.png';

saveas(gcf, out_fig);