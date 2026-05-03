function Q = interpToCommonGrid(P, theta, phi)
%INTERPTOCOMMONGRID Resample pattern P onto common (theta, phi) grid.

    Q = P;
    Q.theta = theta(:).';
    Q.phi   = phi(:).';

    F_th = griddedInterpolant({P.theta(:), P.phi(:)}, P.Eth, 'linear','nearest');
    F_ph = griddedInterpolant({P.theta(:), P.phi(:)}, P.Eph, 'linear','nearest');
    [Tg, Pg] = ndgrid(theta(:), phi(:));
    Q.Eth = F_th(Tg, mod(Pg,360));
    Q.Eph = F_ph(Tg, mod(Pg,360));
end
