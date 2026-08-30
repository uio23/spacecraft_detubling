classdef Tests < matlab.unittest.TestCase
    properties
        Tolerance = 10^-15;
        Sat
        N_Timestamps
    end

    methods (TestClassSetup)
        function createSatellite(testCase)
            altitude = input("Enter altitude (in meters): ");
            inclination = deg2rad(input("Enter inclination of the orbit (in deg): "));
            testCase.N_Timestamps = input("How many timestamps would you like in the orbit? ");

            testCase.Sat = Satellite(altitude, inclination);
        end
    end

    methods (Test)
        function B_mag_at_pole(testCase)
            B_mag = norm(dipoleField([0, 0, Constants.planet_rad], Constants.dipole_moment));
            B_mag_cf = closedForm(Constants.planet_rad, 0);

            testCase.verifyEqual(B_mag, B_mag_cf, "B at pole is not equal to closed form result", AbsTol=testCase.Tolerance);
        end
        function B_mag_at_equator(testCase)
            B_mag = norm(dipoleField([Constants.planet_rad, 0, 0], Constants.dipole_moment));
            B_mag_cf = closedForm(Constants.planet_rad, pi/2);

            testCase.verifyEqual(B_mag, B_mag_cf, "B at equator pole is not equal to closed form result", AbsTol=testCase.Tolerance);
        end
        function B_mag_pole_to_equator_ratio(testCase)
            pole = norm(dipoleField([0, 0, Constants.planet_rad], Constants.dipole_moment));
            equator = norm(dipoleField([Constants.planet_rad, 0, 0], Constants.dipole_moment));
            ratio = pole/equator;

            testCase.verifyEqual(ratio, 2, "B at poll is not double that at equator", AbsTol=testCase.Tolerance);
        end
        function orbit_periodicity(testCase)
            t_0 = testCase.Sat.getPosition(0);
            t_T = testCase.Sat.getPosition(testCase.Sat.Period);

            testCase.verifyEqual(t_T, t_0, "Orbit not closed. Position at t=0 is not equal to position at t=T", AbsTol=testCase.Tolerance);
        end
        function magnetic_periodicity(testCase)
            t_0 = testCase.Sat.senseB(testCase.Sat.getPosition(0), 0);
            t_T = testCase.Sat.senseB(testCase.Sat.getPosition(testCase.Sat.Period), 0);

            testCase.verifyEqual(t_T, t_0, "Orbit not closed. B field at t=0 is not equal to that at t=T", AbsTol=testCase.Tolerance);
        end
        function B_mag_stays_in_bounds(testCase)
            % B field weakest at equator
            predicted_min = closedForm(testCase.Sat.R, pi/2);
            % Offset from equator by orbital inclination, downwards
            predicted_max = closedForm(testCase.Sat.R, pi/2 - testCase.Sat.Inclination);

            data = testCase.Sat.performOrbit(testCase.N_Timestamps, 0);
            b_magnitudes = vecnorm(data(:,4:6), 2, 2);
            recorded_min = min(b_magnitudes);
            recorded_max = max(b_magnitudes);

            testCase.verifyEqual(recorded_min, predicted_min, "Predicted minimum B field does not match recorded", AbsTol=testCase.Tolerance);
            testCase.verifyEqual(recorded_max, predicted_max,"Predicted maximum B field does not match recorded", AbsTol=testCase.Tolerance);
        end
    end
end
