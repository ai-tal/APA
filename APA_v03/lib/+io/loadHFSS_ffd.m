function P = loadHFSS_ffd(filePath)
%LOADHFSS_FFD HFSS full-wave *.ffd (theta/phi grid + complex ExHy-style pairs).

    fid = fopen(filePath, 'r');
    cleanup = onCleanup(@() fclose(fid));
    raw = {};
    while true
        line = fgetl(fid);
        if ~ischar(line), break; end
        raw{end+1} = line; %#ok<AGROW>
    end

    lines = string(raw);
    nums1 = sscanf(lines(1), '%f');
    nums2 = sscanf(lines(2), '%f');
    assert(numel(nums1) >= 3 && numel(nums2) >= 3);
    thMin = nums1(1); thMax = nums1(2); nTh = round(nums1(3));
    phMin = nums2(1); phMax = nums2(2); nPh = round(nums2(3));

    thetaU = linspace(thMin, thMax, nTh);
    phiU = linspace(phMin, phMax, nPh);

    % Skip header lines until numeric grid starts (first row with 4 floats)
    istart = 0;
    for k = 3:numel(lines)
        row = sscanf(lines(k), '%f');
        if numel(row) >= 4
            istart = k;
            break
        end
    end
    assert(istart > 0, 'HFSS .ffd: no numeric block found.');

    M = zeros(0, 4);
    for k = istart:numel(lines)
        row = sscanf(lines(k), '%f');
        if numel(row) >= 4
            M(end+1, :) = row(1:4)'; %#ok<AGROW>
        end
    end
    assert(size(M, 1) == nTh * nPh, ...
        'HFSS .ffd: expected %d rows, got %d.', nTh * nPh, size(M, 1));

    % Rows ordered with inner loop on theta (HFSS export convention).
    Eth = reshape(complex(M(:, 1), M(:, 2)), nTh, nPh);
    Eph = reshape(complex(M(:, 3), M(:, 4)), nTh, nPh);

    meta = struct('file', filePath, 'format', 'HFSS_ffd', ...
        'thetaGrid', [thMin thMax nTh], 'phiGrid', [phMin phMax nPh]);
    P = io.patternStruct(meta, thetaU, phiU, Eth, Eph);
end
