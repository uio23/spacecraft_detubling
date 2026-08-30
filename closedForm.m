function b_mag = closedForm(r, lambda)
    lambda = mod(lambda, 2*pi);
    b_mag = Constants.b0 * ( Constants.planet_rad / r)^3 * sqrt(1 + 3 * cos(lambda)^2);
end