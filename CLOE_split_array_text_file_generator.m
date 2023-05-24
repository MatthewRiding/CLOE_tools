
% MATLAB script to generate the .txt files used to create custom array
% shapes in CLOE.

% Split periodic array:

% A phased array consisting of two apertures of the same size, separated by
% a gap to accommodate a weld cap/root between them.  FMC capture between
% the two apertures.  Each aperture is populated with a linear, periodic
% array with the same pitch used for both apertures.

width_single_aperture = 5*10^-3; %[mm]
width_central_gap = 4.5*10^-3; %[mm]
n_elements_single_aperture = 34;
pitch_constant = width_single_aperture / (n_elements_single_aperture - 1);