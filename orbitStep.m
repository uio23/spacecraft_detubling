function dydt = orbitStep(t, y, sat) %#ok<*INUSD>
% ORBITSTEP

    position = y(1:3);
    velocity = y(4:6);

    attitude = y(7:10)'; % Transpose to row vector for quatmultiply
    angular_velocity = y(11:13);

   
    % Position rate of change .r
    drdt = velocity;

    % Newtonian gravitational acceleration .v
    gravitational_acceleration = -(Constants.gravitational_parameter * position) / norm(position)^3;

    % Attitude rate of change .q
    angular_velocity_q = [0 angular_velocity']  / 2; % Convert into halved row vector quaternion
    dqdt = quatmultiply(attitude, angular_velocity_q)';

    % Euler's rotational acceleration .w
    angular_acceleration = sat.Inertia_Tensor^-1 * (sat.Torque' - cross(angular_velocity, sat.Inertia_Tensor * angular_velocity));


    dydt = [drdt;
            gravitational_acceleration;
            dqdt;
            angular_acceleration];
end
