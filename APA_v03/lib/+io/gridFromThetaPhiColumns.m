function [Eth, Eph, thetaU, phiU] = gridFromThetaPhiColumns(th, ph, Eth_col, Eph_col)
%GRIDFROMTHETAPHICOLUMNS Map scattered θ/φ samples to full grids (Eth,Eph).
    th = round(double(th(:)), 9);
    ph = round(double(ph(:)), 9);
    Eth_col = Eth_col(:); Eph_col = Eph_col(:);
    assert(numel(th)==numel(Eth_col) && numel(th)==numel(Eph_col));

    thetaU = unique(th, 'sorted');
    phiU = unique(ph, 'sorted');
    nTh = numel(thetaU); nPh = numel(phiU);
    assert(numel(th) == nTh * nPh, ...
        'Expected full Cartesian θ×φ grid (got %d samples, %d×%d grid).', ...
        numel(th), nTh, nPh);

    [~, iTh] = ismember(th, thetaU);
    [~, iPh] = ismember(ph, phiU);
    Eth = nan(nTh, nPh);
    Eph = nan(nTh, nPh);
    linIdx = sub2ind([nTh, nPh], iTh(:), iPh(:));
    Eth(linIdx) = Eth_col(:);
    Eph(linIdx) = Eph_col(:);
    assert(~any(isnan(Eth(:))), 'Duplicate or missing (theta,phi) keys.');
end
