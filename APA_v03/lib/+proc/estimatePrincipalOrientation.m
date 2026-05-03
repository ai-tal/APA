function [orientationLabel, metricBest, metricVec] = estimatePrincipalOrientation(P, R, varargin)
%ESTIMATEPRINCIPALORIENTATION Pick nearest cardinal axis (+/-X,+/-Y,+/-Z).
%   Cone gate uses spherical law of cosines (same angular metric as computeCoverage conical mode).
%   Score = weighted mean linear power inside cone using gridSolidAngleWeights (same cell weights as computeCoverage).

    p = inputParser;
    addParameter(p, 'ConeHalfAngle_deg', 35, @(x) isnumeric(x) && isscalar(x) && x > 5 && x < 89);
    parse(p, varargin{:});
    cone = p.Results.ConeHalfAngle_deg;

    Th = P.theta;
    Ph = P.phi;
    G = R.gainTotal_dB;
    assert(isequal(size(Th), size(G)), 'estimatePrincipalOrientation: grid mismatch.');

    lin = 10 .^ (G / 10);
    W = proc.gridSolidAngleWeights(Th, Ph);

    presets = {
        'Source: +Z (Zenith)',   0,   0;
        'Source: -Z (Deck)',   180,   0;
        'Source: +X (Fwd)',     90,   0;
        'Source: -X (Aft)',     90, 180;
        'Source: +Y (Stbd)',    90,  90;
        'Source: -Y (Port)',    90, 270};

    nPres = size(presets, 1);
    metricVec = zeros(nPres, 1);

    for k = 1:nPres
        thd = presets{k, 2};
        phd = presets{k, 3};
        Gamma_deg = proc.sphericalAngularSeparationDeg(Th, Ph, thd, phd);
        mask = Gamma_deg <= cone & isfinite(lin) & isfinite(W);
        ws = sum(W(mask), 'all');
        if ws <= 0 || nnz(mask) < 3
            metricVec(k) = 0;
        else
            metricVec(k) = sum(W(mask) .* lin(mask), 'all') / ws;
        end
    end

    [metricBest, ix] = max(metricVec);
    orientationLabel = presets{ix, 1};
end
