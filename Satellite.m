classdef Satellite
    properties
        R
        Inclination
        Mean_Motion
        Period
        Inertia_Tensor
        Q
        Angular_Velocity
        Torque
        R0
        V0
    end

    methods
        function sat = Satellite(r0, v0, inertia_tensor, w0, t)
        % SATELLITE Create an instance of a satellite
        % 
        % @param altitude    Distance in meters from planet centre
        % @param inclination Angle in radians of the orbit's tilt
        %                    from the equator.
        % @param inertia_tensor
        % @param w0
        % @param t

            sat.R0 = r0;
            sat.V0 = v0;

            sat.Inertia_Tensor = inertia_tensor;
            sat.Angular_Velocity = w0;
            sat.Torque = t;

            sat.Mean_Motion = sqrt(Constants.gravitational_parameter / ...
                                   norm(r0)^3);
            sat.Period = 2*pi / sat.Mean_Motion;
            sat.Q = [1 0 0 0];
        end

        function simulation = performOrbit(sat, time)
        % PERFORMORBIT Produce the timeseries of position, attitude and magnetic
        %              field sense over the duration of one orbit of this
        %              satellite
        %
        % @param time Duration in seconds that the satellite should orbit
        %             for
        % @param apply_noise Boolean for whether to apply a noise 
        %                    to the magnetic field readings

            duration = [0 time];
            ode_opts = odeset('Reltol',1e-13,'AbsTol',1e-14);

            y0 = [sat.R0';
                  sat.V0';
                  sat.Q';
                  sat.Angular_Velocity'];
            
            [time, data] = ode113(@(t, y) orbitStep(t, y, sat), duration, y0, ode_opts);

            angular_velocities = data(:,11:13);

            kinetic_energy = dot(angular_velocities', sat.Inertia_Tensor * angular_velocities')' / 2;
            angular_momentum_mag = vecnorm(angular_velocities * sat.Inertia_Tensor, 2, 2);

            data = [time data kinetic_energy angular_momentum_mag];

            simulation = array2table(data, ...
                VariableNames=[ ...
                    "Time", ...
                    "X", "Y", "Z", ...
                    "VX", "VY", "VZ", ...
                    "Q0", "Q1", "Q2", "Q3", ...
                    "WX", "WY", "WZ", ...
                    "T", "L" ...
                ]);
        end

        function noise = getNoise(sat, b_actual)
            % GETNOISE Generate a small vector to simulate the noise in
            %          the satellite's magnetic field sensor

            % The magnitude of the noise is 5% of the actual field
            noise_mag = norm(b_actual) * 0.05;

            % A vector of 3 values between -/+ 1 with a magnitude of 1
            noise_vector = (rand(1,3) * 2 - 1);
            noise_vector = noise_vector / sum(abs(noise_vector));

            % Distribute the noise_magnitude by the proportions of the noise_vector
            noise = noise_vector * noise_mag;
        end
    end
end
