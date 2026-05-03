function P = loadXGTD_magphase(filePath)
%LOADXGTD_MAGPHASE XGTD .fz / .uan far-field (gain dB + phase deg).

    txt = fileread(filePath);
    lines = splitlines(string(txt));

    i0 = find(contains(lines, 'begin_<parameters>'), 1);
    i1 = find(contains(lines, 'end_<parameters>'), 1);
    assert(~isempty(i0) && ~isempty(i1), 'Missing parameters block.');

    header = struct();
    for k = (i0+1):(i1-1)
        line = strtrim(lines(k));
        if line == ""
            continue
        end
        parts = regexp(line, '^\s*(\S+)\s+(.+)$', 'tokens', 'once');
        if isempty(parts), continue; end
        key = matlab.lang.makeValidName(parts{1});
        val = strtrim(parts{2});
        num = str2double(val);
        if ~isnan(num)
            header.(key) = num;
        else
            header.(key) = val;
        end
    end

    dataLines = lines((i1+1):end);
    mask = strlength(strtrim(dataLines)) > 0;
    dataLines = dataLines(mask);
    assert(~isempty(dataLines), 'No numeric data in file.');
    % Vectorized parse (tab/space-separated floats): avoids O(n²) grow + per-line sscanf.
    blob = char(strjoin(dataLines, newline));
    v = sscanf(blob, '%f');
    assert(mod(numel(v), 6) == 0, ...
        'Numeric body length must be divisible by 6 (%d values); corrupt XGTD body?', numel(v));
    M = reshape(v, 6, []).';

    th = M(:,1); ph = M(:,2);
    Gth = M(:,3); Gph = M(:,4); pth = M(:,5); pph = M(:,6);

    Eth_col = complexMagPhase(Gth, pth);
    Eph_col = complexMagPhase(Gph, pph);
    [Eth, Eph, thetaU, phiU] = io.gridFromThetaPhiColumns(th, ph, Eth_col, Eph_col);
    [GthM, GphM, ~, ~] = io.gridFromThetaPhiColumns(th, ph, Gth, Gph);
    [pthM, pphM, ~, ~] = io.gridFromThetaPhiColumns(th, ph, pth, pph);

    [Th, Ph] = ndgrid(thetaU, phiU);
    P = struct('meta', struct('file', filePath, 'header', header, 'format', 'XGTD_magphase'), ...
        'theta', Th, 'phi', Ph, 'Eth', Eth, 'Eph', Eph, ...
        'Gtheta_dB', GthM, 'Gphi_dB', GphM, ...
        'phaseTheta_deg', pthM, 'phasePhi_deg', pphM);
end

function z = complexMagPhase(Gdb, phDeg)
    mag = 10.^(Gdb(:) / 20);
    z = mag .* exp(1j * deg2rad(phDeg(:)));
end
