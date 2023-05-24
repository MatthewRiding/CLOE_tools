clear
close all

% MATLAB script to generate the .txt files used to create custom array
% shapes in CLOE.

% Split periodic array (SPA):

% A phased array consisting of two apertures of the same size, separated by
% a gap to accommodate a weld cap/root between them.  FMC capture between
% the two apertures.  Each aperture is populated with a linear, periodic
% array with the same pitch used for both apertures.

width_single_aperture = 5*10^-3; %[m]
width_central_gap = 4.5*10^-3; %[m]
n_elements_single_aperture = 34;
pitch_constant = width_single_aperture / (n_elements_single_aperture - 1); %[m]

%% Generate Galvo movement .txt file:

% The format for the .txt file used to specify the movement of one of the
% galvo mirrors is as follows:

% A .txt file containing one row of numbers separated by commas. 
% The numbers are locations in micrometers relative to the starting point.
% 
% The first number specifies the distance the generation laser should be
% moved along the flat sample's surface (measured in micrometres) after the
% first A-scan has been captured at the starting position specified within
% the CLOE GUI.  For example, if the first number is 1000, this instructs
% the generation beam to move 1mm in the positive direction (galvo voltage
% increasing) after the capture of the first A-scan.  The second A-scan
% will be captured with the generation beam at this new location (1mm away
% from the starting point).

% The second number specifies the distance of the next generation point
% from the original starting point input in the CLOE GUI.  Continuing the
% example described above, if the second number is 2000, this instructs the
% galvo to move the generation beam by a further 1000 micrometers after the
% second A-scan has been captured, taking it to a new location that is 2000
% micrometers from the starting point.  The third A-scan will be captured
% here.

% Subsequent numbers in the row will all specify the distance of their
% associated generation point from the original starting point [in
% micrometers].

% The numbers required to scan the generation beam to five locations,
% spaced in a linear periodic array with a constant separation of 1mm
% between each element and its neighbours are as follows:

% 1000 2000 3000 4000

% Remember, the first A-scan is captured at an implied 'zero point'
% specified within the CLOE GUI.

% Distances from the starting position for the elements in aperture A:
distances_um_galvo_array_A_only = linspace(pitch_constant/10^-6, (pitch_constant/10^-6) * (n_elements_single_aperture - 1), (n_elements_single_aperture -1));

% Distance from the starting position associated with the first element in
% aperture B:
distance_um_galvo_array_B_start = max(distances_um_galvo_array_A_only) + (width_central_gap / 10^-6);

% Distaces from the starting position associated with the remaining
% elements in aperture B:
distances_um_galvo_array_B_remaining = linspace(distance_um_galvo_array_B_start + (pitch_constant / 10^-6), distance_um_galvo_array_B_start + ((pitch_constant/10^-6) * (n_elements_single_aperture - 1)), (n_elements_single_aperture - 1));

% Combine into a single row vector for the whole split periodic array (SPA):
distances_um_galvo_SPA = horzcat(distances_um_galvo_array_A_only, distance_um_galvo_array_B_start, distances_um_galvo_array_B_remaining);

figure(Position=[100 100 1000 600])
    subplot(1,2,1)
        plot(distances_um_galvo_SPA, Marker="square");
        xlabel('Element_number')
        xlim([0 n_elements_single_aperture*2])
        ylabel('Distances of array elements from galvo starting position [um]')
        title('Galvo distances')

%% Save Galvo distances to a .txt file:
file_name_string_galvo_distances = sprintf('galvo_distances_SPA_A_%g_gap_%g_NpA_%g', width_single_aperture/10^-3, width_central_gap/10^-3, n_elements_single_aperture);
file_name_string_galvo_distances = strrep(file_name_string_galvo_distances, '.', '_');
writematrix(distances_um_galvo_SPA, file_name_string_galvo_distances)

%% Generate the movement .txt file for the detection beam:

% The format for the .txt file used to specify the movement of the
% detection beam in one axis is as follows:

% A .txt file containing one row of numbers separated by commas.
% The numbers are movements (in micrometers) relative to the previous
% generation position.
% 
% The first number specifies the distance the detection laser should be
% moved along the flat sample's surface (measured in micrometres) after the
% first n A-scans (all generation locations) have been captured with the
% detection beam at the starting position specified within the CLOE GUI.
% For example, if the first number is 1000, this instructs the detection
% beam to move 1mm in the positive direction (thorlabs/PI stage location
% increasing) after the capture of the first n A-scans.  The next n A-scans
% will be captured with the detection beam at this new location (1mm away
% from the starting point).

% The second number specifies the distance of the next detection point from
% the previous detection point.  Continuing the example described above, if
% the second number is 2000, this instructs the galvo to move the
% generation beam by a further 2000 micrometers after the second batch of n
% A-scans have been captured, taking it to a new location that is 2000
% micrometers from the previous detection point.  The third batch of n
% A-scans will be captured here.

% Subsequent numbers in the row will all specify the distance of their
% associated generation point from the previous detection point [in
% micrometers].

% The numbers required to scan the generation beam to five locations,
% spaced in a linear periodic array with a constant separation of 1mm
% between each element and its neighbours are as follows:

% 1000 1000 1000 1000

% Remember, the first A-scan of each row of the FMC is captured at an
% implied 'zero point' specified within the CLOE GUI.

% Sequential movements for the elements in aperture A:
movements_um_detection_array_A_only = repmat(pitch_constant/10^-6, [1 (n_elements_single_aperture -1)]);

% Movement required to fly over the gap from the last element in aperture A
% to the first element in aperture B:
movement_um_detection_A_end_to_B_start = width_central_gap / 10^-6;

% Sequential movements for the remaining elements in aperture B:
movements_um_detection_array_B_remaining = movements_um_detection_array_A_only;

% Combine into a single row vector for the whole split periodic array (SPA):
movements_um_detection_SPA = horzcat(movements_um_detection_array_A_only, movement_um_detection_A_end_to_B_start, movements_um_detection_array_B_remaining);

    subplot(1,2,2)
        plot(movements_um_detection_SPA, Marker="square");
        xlabel('Movement number')
        xlim([0 n_elements_single_aperture*2])
        ylabel('Movement distance [\mum]')
        title('Detection beam movements')

%% Save the detection beam movements to a .txt file:
file_name_string_detection_movements = sprintf('detection_movements_SPA_A_%g_gap_%g_NpA_%g', width_single_aperture/10^-3, width_central_gap/10^-3, n_elements_single_aperture);
file_name_string_detection_movements = strrep(file_name_string_detection_movements, '.', '_');
writematrix(movements_um_detection_SPA, file_name_string_detection_movements)
