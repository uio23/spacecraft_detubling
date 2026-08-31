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
    end

    methods
        function sat = Satellite(altitude, inclination, inertia_tensor)
        % SATELLITE Create an instance of a satellite
        % 
        % @param altitude The distance, in meters, of the satellite from
        %        the planet surface
        % @param inclination The angle, in degrees, of the orbit's tilt
        %        from the equator.
        
            sat.R = Constants.planet_rad + altitude;
            sat.Inclination = inclination;
            sat.Mean_Motion = sqrt(Constants.gravitational_parameter / sat.R^3);
            sat.Period = 2*pi / sat.Mean_Motion;

            sat.Inertia_Tensor = [
                10, 0, 0;
                0, 20, 0;
                0, 0, 30
                ];
            sat.Q = [1 0 0 0];
            sat.Angular_Velocity = [0; pi; pi/2];
            sat.Torque = [0; 0; 0];
        end

        function data = performOrbit(sat, n, apply_noise)
        % PERFORMORBIT Produce the timeseries of position and magnetic
        %              field sense over the duration of one orbit of this
        %              satellite
        %
        % @param n Number of timestamps to include in timeseries
        % @param apply_noise Whether to apply a noise 
        %                    to the magnetic field readings
        
            timestamps = linspace(0, sat.Period, n);

            duration = [0 40];
            % The satellite starts rotation at its current w and attitude
            y0 = [sat.Angular_Velocity; 
                  sat.Q']; % Transpose to make single column vector
            % From ode113 page
            tolerances = odeset('Reltol',1e-13,'AbsTol',1e-14);

            [t, y] = ode113(@(t, y) tumble(t,y,sat), duration, y0, tolerances);

            angular_velocities = y(:,1:3);
            attitudes = y(:,4:7)

            kinetic_energy = dot(angular_velocities', sat.Inertia_Tensor * angular_velocities') / 2;
            angular_momentum_mag = norm(sat.Inertia_Tensor * angular_velocities');

            plot(t, kinetic_energy,'-x');
            plot(t, angular_momentum_mag,'-x');

            figure
            plot(t,attitudes(:,2),'-o',t,attitudes(:,3),'-o',t,attitudes(:,4),'-o')
            title('Sat attitude over time');
            xlabel('Time');
            ylabel('Quaternion component')
            legend('q_x','q_y','q_z')


            orbit = arrayfun(@(t) sat.getPosition(t), timestamps, "UniformOutput",false);
            b_field = cell2mat(arrayfun(@(pos) sat.senseB(cell2mat(pos)', apply_noise), orbit, "UniformOutput",false)');
            orbit = cell2mat(orbit);


            data = [orbit' b_field timestamps'];
        end

        function pos = getPosition(sat, time)
        % GETPOSITION Calculate vector position of this satellite at a given
        %             time
        %
        % @param time Time to calculate position for
            
            % Fix floating point rounding error for 
            % when the angle is a multiple of 2*pi
            angle_travelled = mod(time * sat.Mean_Motion, 2*pi);

            % Using spherical coordinates
            pos_hat = [
                      cos(angle_travelled) 
                      sin(angle_travelled)*cos(sat.Inclination) 
                      sin(angle_travelled)*sin(sat.Inclination) 
                     ];
            pos = sat.R * pos_hat;
        end

        function b_field = senseB(sat, pos, apply_noise)
        % SENSEB Sense the magnetic field at given position
        %
        % @param pos The vector of the satellite position
        % @param apply_noise Whether noise should be applied to the sensed
        %                    magnetic field
 
            
            b_at_pos = dipoleField(pos, Constants.dipole_moment);
            % TODO add rotation to satellite
            b_field = 1 * b_at_pos;

            if (apply_noise)
                b_field = b_field + sat.getNoise(b_field);
            end
        end

        function noise = getNoise(sat, b_actual)
            % GETNOISE Generate a small vector to simulate the noise in
            %          the satellite's magnetic field sensor


            % The magnitude of the noise is 5% of the actual field
            noise_mag = norm(b_actual) * 0.05;

            % A vector of 3 values between -/+ 1 with a magnitude of 1
            noise_vector = (rand(1,3) * 2 - 1);
            noise_vector = noise_vector / sum(abs(noise_vector));

            % Distribute the noise_magnitude by the proportions of the
            % noise_vector
            noise = noise_vector * noise_mag;
        end
    end
end
