% Display the generated satellite orbit in 3D with 
% the measured magnetic field vector at every point


hold on

q = plot3(simulation.X, simulation.Y, simulation.Z);
q.Color = "#006199";

title("Satellite in orbit, with planetary magnetic field");

