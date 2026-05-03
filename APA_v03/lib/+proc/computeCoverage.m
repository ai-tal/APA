function [thrVec, covPct] = computeCoverage(R, mode, opts)
%COMPUTECOVERAGE Solid-angle weighted fraction of region where gain >= threshold.
%   [THR, COV] = proc.computeCoverage(R, 'spherical', opts)
%   opts: thrMin, thrMax, thrStep (dB)
%
%   Conical: opts also needs coneTheta_deg, conePhi_deg, coneAlpha_deg (half-angle).

    if nargin < 3
        opts = struct;
    end

    gain = R.gainTotal_dB;
    Th = R.theta;
    Ph = R.phi;

    % Exclude XGTD “no signal” sentinels (both components at gain floor ~-250 dB)
    if isfield(R, 'Gtheta_dB') && isfield(R, 'Gphi_dB')
        s = -249.5;
        if isfield(opts, 'sentinelJoint_dB')
            s = opts.sentinelJoint_dB;
        end
        validPts = ~(R.Gtheta_dB <= s & R.Gphi_dB <= s);
    else
        validPts = true(size(gain));
    end

    W = proc.gridSolidAngleWeights(Th, Ph);

    switch lower(mode)
        case 'spherical'
            regionMask = true(size(Th));
        case 'conical'
            th0 = opts.coneTheta_deg;
            ph0 = opts.conePhi_deg;
            alDeg = opts.coneAlpha_deg;
            Gamma_deg = proc.sphericalAngularSeparationDeg(Th, Ph, th0, ph0);
            regionMask = Gamma_deg <= alDeg;
        case 'canonical'
            error('proc:computeCoverage:CanonicalNotImplemented', ...
                ['Canonical coverage is not implemented yet. ', ...
                 'Pass a mask or rule set in opts when available.']);
        otherwise
            error('proc:computeCoverage:UnknownMode', 'Unknown mode "%s".', mode);
    end

    regionMask = regionMask & validPts;

    Wtot = sum(W(regionMask), 'all');
    if Wtot <= 0
        Wtot = eps;
    end

    t0 = opts.thrMin;
    t1 = opts.thrMax;
    st = opts.thrStep;
    thrVec = (t0:st:t1).';
    if isempty(thrVec)
        thrVec = t0;
    end

    n = numel(thrVec);
    covPct = zeros(n, 1);
    for k = 1:n
        tau = thrVec(k);
        ok = (gain >= tau) & regionMask;
        covPct(k) = 100 * sum(W(ok), 'all') / Wtot;
    end
end
