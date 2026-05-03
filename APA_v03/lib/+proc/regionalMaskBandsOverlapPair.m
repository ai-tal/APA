function tf = regionalMaskBandsOverlapPair(ta, pa, tb, pb)
%REGIONALMASKBANDSOVERLAPPAIR True if closed θ–φ rectangles overlap (positive area), θ in [0,180], φ in [0,360).

    tol = 1e-4;
    ta1 = ta(1); ta2 = ta(2);
    tb1 = tb(1); tb2 = tb(2);
    pa1 = pa(1); pa2 = pa(2);
    pb1 = pb(1); pb2 = pb(2);

    % Theta overlap (closed intervals, positive measure)
    if max(ta1, tb1) > min(ta2, tb2) + tol
        tf = false;
        return
    end

    tf = phiClosedBandsOverlap(pa1, pa2, pb1, pb2, tol);
end

function tf = phiClosedBandsOverlap(a1, a2, b1, b2, tol)
    ph = 0:0.25:359.75;
    m1 = phiSamplesInBand(ph, a1, a2);
    m2 = phiSamplesInBand(ph, b1, b2);
    tf = any(m1 & m2);
end

function m = phiSamplesInBand(ph, a1, a2)
    span = mod(a2 - a1 + 360, 360);
    if span <= 1e-6 || span >= 360 - 1e-6
        m = true(size(ph));
        return
    end
    if a1 <= a2
        m = ph >= (a1 - 1e-9) & ph <= (a2 + 1e-9);
    else
        m = ph >= (a1 - 1e-9) | ph <= (a2 + 1e-9);
    end
end
