figure(Name="Attitude TS", NumberTitle="off", WindowStyle="docked")

attitude_ts = timeseries(simulation{:, ["Q1", "Q2", "Q3"]}, simulation.Time);
plot(attitude_ts)

title('Satellite attitude');
xlabel('Time');
ylabel('Quaternion components')
legend('q_x','q_y','q_z')


figure(Name="Extra attitude vals", NumberTitle="off", WindowStyle="docked")

extra_ts = timeseries(simulation{:, ["T", "L"]}, simulation.Time);
plot(extra_ts)

title('Rotational kinetic energy and Angular momentum magnitude');
xlabel('Time');
legend('T','|L|')