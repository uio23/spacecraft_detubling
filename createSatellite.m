% Create a Satellite object with the specified altitude and inclination
% and then perform an orbit of specified duration


clearvars ''
clc


% altitude = input("Altitude (in km): ");
% inclination = input("Orbit inclination (in deg): ");
% duration = input("Orbit duration (in sec): ");

altitude = 5000;
inclination = 10;

altitude = (altitude * 1000);
inclination = deg2rad(inclination);

[position, velocity] = circularOrbit(altitude, inclination);
inertia_tensor = [10, 0, 0;
                  0, 20, 0;
                  0, 0, 30];
angular_velocity = [0 0 pi/60];
torque = [0 0 0];

sat = Satellite(position, velocity, inertia_tensor, angular_velocity, torque);
%duration = sat.Period;
duration = 400;
simulation = sat.performOrbit(duration);

N = height(simulation);
magnetic_field = zeros(N, 3);
magnetic_field_noise = zeros(N, 3);

for i = 1:N
    position = simulation{i, ["X", "Y", "Z"]};

    magnetic_field(i,:) = dipoleField(position, Constants.dipole_moment);
    magnetic_field_noise(i,:) = magnetic_field(i,:) + sat.getNoise(magnetic_field(i,:));
end

simulation{:, ["BX", "BY", "BZ"]} = magnetic_field;
simulation{:, ["BX_noise", "BY_noise", "BZ_noise"]} = magnetic_field_noise;


