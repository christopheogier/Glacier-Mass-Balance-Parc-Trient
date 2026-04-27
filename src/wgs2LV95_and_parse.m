%% Paths
base = 'C:/Users/christopher/Desktop/home/GitHub/Glacier-Mass-Balance-Parc-Trient/data/20260426_Trient/';

file_team1 = [base, 'coordinates_snowdepth_team1.txt'];
file_team2 = [base, 'coordinates_snowdepth_team2.txt'];

out_file = [base, 'coordinates_snowdepth_all_LV95.txt'];

%% =========================
%  TEAM 1: lat/lon -> LV95
%  columns: number lat lon h1 h2 h3
%% =========================
%% TEAM 1: lat/lon -> LV95

fid = fopen(file_team1, 'r');

C = textscan(fid, '%f %f %f %f %f %f', ...
    'Delimiter', {' ', '\t'}, ...
    'MultipleDelimsAsOne', true);

fclose(fid);

num1 = C{1};
lat  = C{2};
lon  = C{3};

h_team1 = [C{4}, C{5}, C{6}];

H = zeros(size(lat));

[N1, E1, ~] = jwgs2sgr(lat, lon, H);

team1_lv95 = [num1, round(E1), round(N1), h_team1];

%% =========================
%  TEAM 2: already LV95
%  columns: number E N h1 h2 h3
%% =========================

T2 = readmatrix(file_team2);

num2 = T2(:,1);
E2   = T2(:,2);
N2   = T2(:,3);

h_team2 = T2(:,4:end);

team2_lv95 = [num2, E2, N2, h_team2];

%% =========================
%  Make same number of columns
%% =========================

ncol = max(size(team1_lv95,2), size(team2_lv95,2));

team1_lv95(:,end+1:ncol) = NaN;
team2_lv95(:,end+1:ncol) = NaN;

%% =========================
%  Merge and save
%% =========================

all_lv95 = [team1_lv95; team2_lv95];

%% Compute mean of h1 h2 h3 (cols 4–6)
mean_h = mean(all_lv95(:,4:6), 2, 'omitnan');

all_lv95(:,7) = mean_h;

%% Add header
header = {'id','x','y','h1','h2','h3','h_mean'};

% Combine header + data
output = [header; num2cell(all_lv95)];

%% Save
writecell(output, out_file, 'Delimiter', 'tab');

disp(['Saved merged LV95 file: ', out_file])