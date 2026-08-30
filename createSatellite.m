% Create a Satellite object with the specified altitude and inclination
% and then perform an orbit with the specified number of timestamps,
% both with and without noise


clearvars sat sat_data_no_noise sat_data 


altitude = input("Enter altitude (in meters): ");
inclination = deg2rad(input("Enter inclination of the orbit (in deg): "));
n_timestamps = input("How many timestamps would you like in the orbit? ");


sat = Satellite(altitude, inclination);
sat_data = sat.performOrbit(n_timestamps, 1);
sat_data_no_noise = sat.performOrbit(n_timestamps, 0);