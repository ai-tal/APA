function P = closePhiSeam(P)
%CLOSEPHISEAM Ensure the pattern's phi axis closes the sphere at phi=360.
%
%   Many pattern files sample phi on [0, 360) leaving a seam in plots.  This
%   helper appends the phi=0 column at phi=360 (with wrap) when the sampled
%   axis nearly covers a full revolution but does not include the 360-deg
%   endpoint.  It is a no-op when the grid already closes (phi(end) == 360),
%   does not span ~360 deg, or does not start at 0.

    phi = P.phi(:).';
    if numel(phi) < 2; return; end
    if ~isfield(P,'theta') || ~isfield(P,'Eth') || ~isfield(P,'Eph'); return; end

    p0   = phi(1);
    pEnd = phi(end);
    span = pEnd - p0;
    dphi = median(diff(phi));
    if dphi <= 0; return; end

    % Case A: data covers (p0, p0+360) but last sample falls one step short.
    if abs(p0) < 1e-6 && (span + dphi - 360) > -1e-3 && abs(pEnd - 360) > 1e-3
        P.phi = [phi, 360];
        P.Eth = [P.Eth, P.Eth(:,1)];
        P.Eph = [P.Eph, P.Eph(:,1)];
        return;
    end

    % Case B: data covers the whole circle but endpoint is missing (span < 360
    % by exactly one step or phi runs like 0..358).
    if abs(p0) < 1e-6 && abs(360 - pEnd) < abs(dphi) + 1e-3 && abs(pEnd - 360) > 1e-3
        P.phi = [phi, 360];
        P.Eth = [P.Eth, P.Eth(:,1)];
        P.Eph = [P.Eph, P.Eph(:,1)];
        return;
    end

    % Case C: phi runs -180..180 and the -180 and +180 columns disagree; copy
    % -180 -> +180 when +180 is missing so the plot wraps cleanly.
    if abs(p0 + 180) < 1e-3 && pEnd < 180 - 1e-3
        P.phi = [phi, 180];
        P.Eth = [P.Eth, P.Eth(:,1)];
        P.Eph = [P.Eph, P.Eph(:,1)];
        return;
    end
end
