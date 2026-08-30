% Display the magnetic field measured by satellite during one full orbit,
% alongside the actual magnetic field at every timestamp


figure(Name="B Time Series", NumberTitle="off", WindowStyle="docked")


b_magnitudes = vecnorm(sat_data(:,4:6), 2, 2);
b_ts = timeseries(b_magnitudes, sat_data(:,7));
plot(b_ts)

hold on 

b_magnitudes = vecnorm(sat_data_no_noise(:,4:6), 2, 2);
b_no_noise_ts = timeseries(b_magnitudes, sat_data_no_noise(:,7));
plot(b_no_noise_ts)


title('Measured vs actual B field at satellite position')
xlabel('Delta-time (seconds)')
ylabel('Magnetic field (T)')
legend('Measured','Actual','Location','northwest')