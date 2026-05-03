function v = sphToVec(tp)
%SPHTOVEC Convert [theta_deg, phi_deg] into a unit cartesian column vector.
    t = deg2rad(tp(1));
    p = deg2rad(tp(2));
    v = [sin(t)*cos(p); sin(t)*sin(p); cos(t)];
end
