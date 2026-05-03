function Gamma_deg = sphericalAngularSeparationDeg(Th, Ph, th0_deg, phi0_deg)
%SPHERICALANGULARSEPARATIONDEG Great-circle angle (deg) from each grid point to axis (th0,phi0).
%   Uses spherical law of cosines (no Cartesian intermediate arrays).

    Gamma_deg = acosd(min(max(cosd(Th) .* cosd(th0_deg) + sind(Th) .* sind(th0_deg) .* cosd(Ph - phi0_deg), -1), 1));
end
