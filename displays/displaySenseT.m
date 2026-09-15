% Display the magnetic field measured by satellite during one full orbit,
% alongside the actual magnetic field at every timestamp


figure(Name="Magnetic Field TS", NumberTitle="off", WindowStyle="docked")

magnetic_magnitude = vecnorm(simulation{:, ["BX", "BY", "BZ"]}, 2, 2);
magnetic_magnitude_ts = timeseries(magnetic_magnitude, simulation.Time);
magnetic_magnitude_n = vecnorm(simulation{:, ["BX_noise", "BY_noise", "BZ_noise"]}, 2, 2);
magnetic_magnitude_ts_n = timeseries(magnetic_magnitude_n, simulation.Time);


plot(magnetic_magnitude_ts_n, 'LineWidth', 0.8)
hold on
plot(magnetic_magnitude_ts, 'LineWidth', 2)

title('Measured vs Theoretical B field at satellite position')
xlabel('Delta-time (seconds)')
ylabel('Magnetic field (T)')
legend('Measured','Theoretical')