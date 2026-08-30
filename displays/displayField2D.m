% Create 2D planet figure and on it
% Display quiver plot of magnetic field 
% along the y axis with a step of pi/18 (so in x-z axis)


figure(Name=Constants.planet_name + " 2D", NumberTitle="off", WindowStyle="docked")


% Filter down magnetic field data to those rows where the position is along
% the y axis
y_bfield = bfield_data(bfield_data(:, 2) == 0, :);


q = quiver(y_bfield(:,1), y_bfield(:,3), y_bfield(:,4), y_bfield(:,6));
q.Color = "#D57E7E";

r = rectangle(Position=[-Constants.planet_rad, -Constants.planet_rad, Constants.planet_rad * 2, Constants.planet_rad * 2], Curvature=[1 1]);
r.EdgeColor = "#C6D57E";
r.FaceColor = "#A2CDCD";
r.FaceAlpha = 0.8;


xlabel('X-axis');
zlabel('Z-axis');
title("2D " + Constants.planet_name + " Dipole")