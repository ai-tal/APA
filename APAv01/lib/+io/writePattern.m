function writePattern(P, filename)
%WRITEPATTERN Dispatch to the correct writer based on the file extension.
    [~,~,ext] = fileparts(filename);
    switch lower(ext)
        case '.fz';  io.writePatternFZ (P, filename);
        case '.uan'; io.writePatternUAN(P, filename);
        case '.ffe'; io.writePatternFFE(P, filename);
        case '.ffd'; io.writePatternFFD(P, filename);
        case '.ffs'; io.writePatternFFS(P, filename);
        case {'.csv','.txt','.dat'}
            io.writePatternCSV(P, filename);
        case '.mat'
            save(filename, 'P');
        otherwise
            error('writePattern:ext','Unsupported export extension: %s', ext);
    end
end
