% Display the generated satellite orbit in 3D with 
% the measured magnetic field vector at every point


hold on

q = quiver3(sat_data(:,1), sat_data(:,2), sat_data(:,3), sat_data(:,4), sat_data(:,5), sat_data(:,6));
q.Color = "#D57E7E";

title("Satellite orbit with measured magnetic field");

