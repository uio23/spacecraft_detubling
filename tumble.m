function dydt = tumble(t, y, sat) %#ok<*INUSD>
    angular_velocity = y(1:3);
    attitude = y(4:7)'; % Transpose to row vector for quatmultiply

    % Euler's rotational equation
    angular_acceleration = sat.Inertia_Tensor^-1 * (sat.Torque - cross(angular_velocity, sat.Inertia_Tensor * angular_velocity));

    % Attitude rate of change
    angular_velocity_q = [0 angular_velocity']; % Convert into halved row vector quaternion
    dqdt = quatmultiply(attitude, angular_velocity_q) / 2;

    dydt = [angular_acceleration;
            dqdt']; % Return quaternion to column vector
end
