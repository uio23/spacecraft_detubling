function [r, v] = circularOrbit(altitude, inclination)
% CIRCULARORBIT Calculate position and velocity vectors for a satellite
%               to have the desired orbit altitude and inclination
%
% @param altitude     In meters
% @param inclination  In radians

    % Distance from planet center
    rx = Constants.planet_rad + altitude;
    % Start at ascending node (crossing equatorial plane)
    r = [rx 0 0];

    % Circular orbit speed
    v = sqrt(Constants.gravitational_parameter / norm(r));
    % Apply inclination
    v = v * [0 sin(inclination) cos(inclination)];
end