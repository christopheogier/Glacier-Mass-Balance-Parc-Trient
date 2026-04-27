%% File paths
base = 'C:/Users/christopher/Desktop/home/GitHub/Glacier-Mass-Balance-Parc-Trient/data/20260426_Trient/';

files = {
    'Waypoints_25-APR-26.gpx'
    'Waypoints_26-APR-26.gpx'
};

out_file = [base, 'coordinates.txt'];

%% Initialize
all_coords = [];
counter = 1;

%% Loop over files
for f = 1:length(files)
    
    gpx_file = [base, files{f}];
    
    %% Read XML
    doc = xmlread(gpx_file);

    %% Waypoints
    pts = doc.getElementsByTagName('wpt');
    n = pts.getLength;

    %% Loop
    for i = 0:n-1
        node = pts.item(i);

        lat = str2double(char(node.getAttribute('lat')));
        lon = str2double(char(node.getAttribute('lon')));

        all_coords(end+1, :) = [counter, lat, lon];
        counter = counter + 1;
    end
end

%% Save single file
writematrix(all_coords, out_file, 'Delimiter', 'tab');

disp(['Saved ', num2str(size(all_coords,1)), ' total points to: ', out_file])