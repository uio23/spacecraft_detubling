%
figure(Name="Attitude TS", NumberTitle="off", WindowStyle="docked")

attitude_ts = timeseries(simulation{:, ["Q1", "Q2", "Q3"]}, simulation.Time);
plot(attitude_ts)

title('Satellite attitude components over time');
xlabel('Time (s)');
ylabel('Quaternion Components')
xline(orbital_periods, '--', 'Orbital period');
legend('q_x','q_y','q_z')


figure(Name="L Mag TS", NumberTitle="off", WindowStyle="docked")

l_mag_ts = timeseries(simulation{:, "L"}, simulation.Time);
plot(l_mag_ts)

title('Angular momentum magnitude over time');
xlabel('Time (s)');
ylabel('Angular Momentum (kg m^2/s)')
xline(orbital_periods,"--",'Orbital period');
legend('|L|');


figure(Name="Rot Kin TS", NumberTitle="off", WindowStyle="docked")

k_ts = timeseries(simulation{:, "T"}, simulation.Time);
plot(k_ts)

title('Rotational kinetic energy over time');
xlabel('Time (s)');
ylabel('Rotational Kinetic Energy (J)');
xline(orbital_periods,"--",'Orbital period');
legend('T');