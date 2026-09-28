% Create a Satellite object with the specified altitude and inclination
% and then perform an orbit of specified duration


clearvars ''
clc


% altitude = input("Altitude (in km): ");
% inclination = input("Orbit inclination (in deg): ");
% duration = input("Orbit duration (in sec): ");

altitude = 5000 * 1000; % m
inclination = deg2rad(45); % Radians

% Calculate position and velocity for orbit parameters
[position, velocity] = circularOrbit(altitude, inclination);

% Define attitude characteristics
inertia_tensor = [10, 0, 0;
                  0, 10, 0;
                  0, 0, 10];
angular_velocity = [pi/600 pi/600 pi/600];
torque = [0 0 0];

% Crude K value for magnetorquer
k = 30000000;

sat = Satellite(position, velocity, inclination, inertia_tensor, angular_velocity, torque, k);

% Perform 1 orbits
duration = sat.Period * 1;
simulation = sat.performOrbit(duration);

% Sense magnetic field around orbit for statistics
N = height(simulation);
magnetic_field = zeros(N, 3);
magnetic_field_noise = zeros(N, 3);
for i = 1:N
    position = simulation{i, ["X", "Y", "Z"]};

    % Without and with noise
    magnetic_field(i,:) = dipoleField(position, Constants.dipole_moment);
    magnetic_field_noise(i,:) = magnetic_field(i,:) + sat.getNoise(magnetic_field(i,:));
end
simulation{:, ["BX", "BY", "BZ"]} = magnetic_field;
simulation{:, ["BX_noise", "BY_noise", "BZ_noise"]} = magnetic_field_noise;

% Define orbital period time boundaries
orbital_periods = sat.Period:sat.Period:simulation.Time(end);


