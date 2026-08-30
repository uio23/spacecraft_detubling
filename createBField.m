% Calculate the position and magnetic field vectors around the planet
% at specified polar and azimuth intervals


clearvars bfield_data


polar_step = deg2rad(input("What polar step angle do you want (in deg)? "));
azimuth_step = deg2rad(input("What azimuth step angle do you want (in deg)? "));


polar_angles = 0:polar_step:2*pi;
azimuthal_angles = 0:azimuth_step:2*pi;

points = combinations(polar_angles, azimuthal_angles);

bfield_data = zeros(height(points), 6);


% For every combination of polar and azimuth angle, calculate the position
% vector and the magnetic field at that point
for i = 1:height(points)
    phi = points{i,1};
    theta = points{i,2};

    % Calculate the point vector
    vector = [sin(theta)*cos(phi) sin(theta)*sin(phi) cos(theta)];
    vector = vector * (Constants.planet_rad);

    % Calculate the B field at that vector
    b_vector = dipoleField(vector, Constants.dipole_moment);

    bfield_data(i, :) = [vector b_vector];
end
