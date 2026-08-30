classdef Constants
    properties (Constant)
        mu0 = 4*pi*10^(-7);
        G = 6.674 * 10^(-11);

        planet_mass = 5.972 * 10^24; % kg
        planet_rad = 6371000; % m
        planet_name = "Earth";
        gravitational_parameter = Constants.G * Constants.planet_mass;

        b0 =  3.12 * 10^-5;
        dipole_moment_mag = (4 * pi * Constants.b0 * Constants.planet_rad^3) / Constants.mu0;
        % [x, y, z] where up is positive
        dipole_moment = [0, 0, Constants.dipole_moment_mag];

    end
end