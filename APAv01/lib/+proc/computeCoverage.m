function [thr, cov, mask] = computeCoverage(P_or_R, mode, params)
%COMPUTECOVERAGE Solid-angle weighted coverage of a gain pattern.
%
%   [THR, COV] = computeCoverage(R, mode, params) where R is either a
%   processed result from proc.processPattern (uses R.G_total_dB) or a
%   canonical pattern struct (Eth/Eph) from which G_total_dB is derived.
%
%   mode = 'spherical' | 'conical'
%   params struct fields:
%       thrMin, thrMax, thrStep   threshold sweep (dB)     required
%       coneTheta_deg             cone center theta        (conical)
%       conePhi_deg               cone center phi          (conical)
%       coneAlpha_deg             cone half-angle          (conical)
%
%   Returns THR (vector of thresholds) and COV (coverage % per threshold).
%   MASK (Nth x Nph logical) marks the integration region.

    if isfield(P_or_R,'G_total_dB')
        G_dB = P_or_R.G_total_dB;
        theta = P_or_R.theta;
        phi   = P_or_R.phi;
    else
        G_dB = 10*log10(abs(P_or_R.Eth).^2 + abs(P_or_R.Eph).^2 + eps);
        theta = P_or_R.theta;
        phi   = P_or_R.phi;
    end

    thr = (params.thrMin:params.thrStep:params.thrMax).';

    th = deg2rad(theta(:));
    ph = deg2rad(phi(:));
    dth = mean(diff(th));
    dph = mean(diff(ph));
    [Tg, Pg] = ndgrid(th, ph);
    W = sin(Tg) .* dth .* dph;

    switch lower(mode)
        case 'spherical'
            mask = true(size(Tg));
        case 'conical'
            t0 = deg2rad(params.coneTheta_deg);
            p0 = deg2rad(params.conePhi_deg);
            a  = deg2rad(params.coneAlpha_deg);
            cosD = cos(Tg).*cos(t0) + sin(Tg).*sin(t0).*cos(Pg - p0);
            mask = cosD >= cos(a);
        otherwise
            error('computeCoverage:mode','Unknown mode %s',mode);
    end

    Atot = sum(W(mask));
    cov = zeros(size(thr));
    for k = 1:numel(thr)
        cov(k) = 100 * sum(W(mask & (G_dB >= thr(k)))) / max(Atot, eps);
    end
end
