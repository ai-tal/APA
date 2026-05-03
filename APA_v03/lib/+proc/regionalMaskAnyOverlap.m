function hasOv = regionalMaskAnyOverlap(tb, pb)
%REGIONALMASKANYOVERLAP True if any pair of θ–φ bands intersect with positive area.

    N = size(tb, 1);
    for i = 1:N
        for j = i + 1:N
            if proc.regionalMaskBandsOverlapPair(tb(i, :), pb(i, :), tb(j, :), pb(j, :))
                hasOv = true;
                return
            end
        end
    end
    hasOv = false;
end
