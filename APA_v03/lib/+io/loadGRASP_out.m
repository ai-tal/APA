function P = loadGRASP_out(filePath)
%LOADGRASP_OUT GRASP *.out column feed / far-field table.

    txt = fileread(filePath);
    lines = splitlines(string(txt));
    M = zeros(0, 6);
    for k = 1:numel(lines)
        row = sscanf(char(lines(k)), '%f');
        if numel(row) >= 6
            M(end+1, :) = row(1:6)'; %#ok<AGROW>
        end
    end
    assert(size(M, 1) > 0, 'GRASP .out: no numeric rows.');

    th = M(:, 1);
    ph = M(:, 2);
    Eth = complex(M(:, 3), M(:, 4));
    Eph = complex(M(:, 5), M(:, 6));

    [Eth, Eph, thetaU, phiU] = io.gridFromThetaPhiColumns(th, ph, Eth, Eph);
    meta = struct('file', filePath, 'format', 'GRASP_out');
    P = io.patternStruct(meta, thetaU, phiU, Eth, Eph);
end
