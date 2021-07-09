function idx = findAngle(angles, angle)
% For a douple of values, it finds the position in which the vector has the
% same value as the duple.
    idx = find( sum(abs(angles-angle)')'<0.001);