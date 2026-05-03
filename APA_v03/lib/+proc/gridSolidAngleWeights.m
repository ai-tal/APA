function W = gridSolidAngleWeights(Th, Ph)
%GRIDSOLIDANGLEWEIGHTS Ludwig θ–φ grid cell weights ~ sin(theta) dθ dφ (same as computeCoverage).

    thU = unique(Th(:), 'sorted');
    phU = unique(Ph(:), 'sorted');
    dth = mean(diff(deg2rad(thU)));
    dph = mean(diff(deg2rad(phU)));
    if isempty(dth) || isnan(dth)
        dth = deg2rad(1);
    end
    if isempty(dph) || isnan(dph)
        dph = deg2rad(1);
    end
    W = sin(deg2rad(Th)) * dth * dph;
    W = max(W, 0);
end
