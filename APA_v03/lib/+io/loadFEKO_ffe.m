function P = loadFEKO_ffe(filePath)
%LOADFEKO_FFE Altair FEKO far-field *.ffe (complex Etheta/Ephi).

    fid = fopen(filePath, 'r');
    cleanup = onCleanup(@() fclose(fid));
    M = zeros(0, 6);
    while true
        line = fgetl(fid);
        if ~ischar(line), break; end
        if startsWith(strtrim(line), '#') || startsWith(strtrim(line), '##')
            continue
        end
        if startsWith(strtrim(line), '**')
            continue
        end
        row = sscanf(line, '%f');
        if numel(row) >= 6
            % Theta, Phi, Re(Etheta), Im(Etheta), Re(Ephi), Im(Ephi), ...
            M(end+1, :) = row(1:6)'; %#ok<AGROW>
        end
    end
    assert(size(M, 1) > 0, 'FEKO .ffe: no numeric rows.');

    th = M(:, 1);
    ph = M(:, 2);
    Eth = complex(M(:, 3), M(:, 4));
    Eph = complex(M(:, 5), M(:, 6));

    [Eth, Eph, thetaU, phiU] = io.gridFromThetaPhiColumns(th, ph, Eth, Eph);
    meta = struct('file', filePath, 'format', 'FEKO_ffe');
    P = io.patternStruct(meta, thetaU, phiU, Eth, Eph);
end
