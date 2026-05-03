function [bw, edges] = hpbw(angle_deg, gain_dB)
%HPBW Half-power beamwidth from a 1D cut.
%   [BW, EDGES] = hpbw(ANGLE_DEG, GAIN_DB) returns the -3 dB beamwidth
%   around the peak of the cut and the two crossing angles.  If the sweep
%   covers ~360 deg the function wraps around so a peak sitting at the
%   boundary (e.g. theta=0 or phi=0 for a boresight-up pattern) is handled
%   correctly.  Returns NaN if the cut never drops by 3 dB on both sides of
%   the peak.

    angle_deg = angle_deg(:);
    gain_dB   = gain_deg_clean(gain_dB(:));
    n = numel(gain_dB);
    bw = NaN; edges = [NaN NaN];
    if n < 3; return; end

    [pk, ipk] = max(gain_dB);
    if ~isfinite(pk); return; end
    target = pk - 3;

    % Decide whether the cut is circular (covers ~360 deg with no big gap).
    span = angle_deg(end) - angle_deg(1);
    dMed = median(abs(diff(angle_deg)));
    circular = abs(span - 360) < max(2*dMed, 5) || abs(span) > 359;

    if circular
        % Tile three copies so the peak has full context on both sides.
        aTile = [angle_deg - 360; angle_deg; angle_deg + 360];
        gTile = [gain_dB; gain_dB; gain_dB];
        ipkT  = ipk + n;   % peak index in the central copy
    else
        aTile = angle_deg; gTile = gain_dB; ipkT = ipk;
    end

    N = numel(gTile);
    iL = NaN;
    for k = ipkT:-1:2
        if gTile(k) >= target && gTile(k-1) < target
            iL = k - (gTile(k)-target)/(gTile(k)-gTile(k-1));
            break;
        end
    end
    iR = NaN;
    for k = ipkT:N-1
        if gTile(k) >= target && gTile(k+1) < target
            iR = k + (gTile(k)-target)/(gTile(k)-gTile(k+1));
            break;
        end
    end
    if isnan(iL) || isnan(iR); return; end
    aL = interp1(1:N, aTile, iL, 'linear');
    aR = interp1(1:N, aTile, iR, 'linear');
    bw = aR - aL;
    edges = [aL aR];
end

function g = gain_deg_clean(g)
    g = double(g);
    g(~isfinite(g)) = -Inf;
end
