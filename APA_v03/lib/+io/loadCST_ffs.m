function P = loadCST_ffs(filePath)
%LOADCST_FFS CST Microwave Studio far-field ASCII (*.ffs).

    M = readmatrix(filePath, 'NumHeaderLines', 1, 'FileType', 'text', 'Delimiter', '\t');
    assert(size(M, 2) >= 6, 'CST .ffs: expected at least 6 columns.');
    ph = M(:, 1);
    th = M(:, 2);
    Eth = complex(M(:, 3), M(:, 4));
    Eph = complex(M(:, 5), M(:, 6));

    [Eth, Eph, thetaU, phiU] = io.gridFromThetaPhiColumns(th, ph, Eth, Eph);
    meta = struct('file', filePath, 'format', 'CST_ffs');
    P = io.patternStruct(meta, thetaU, phiU, Eth, Eph);
end
