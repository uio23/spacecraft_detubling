figure(Name="Position TS", NumberTitle="off", WindowStyle="docked")

position_ts = timeseries(simulation{:, ["X", "Y", "Z"]}, simulation.Time);
plot(position_ts)

title('Satellite position in orbit');
xlabel('Time');
ylabel('Posittion components')
legend('r_x','r_y','r_z')
