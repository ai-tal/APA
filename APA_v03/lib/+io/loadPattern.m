function P = loadPattern(filePath, formatId)
%LOADPATTERN Load far-field pattern from multiple vendor formats.
%   P = io.loadPattern(FILEPATH)
%   P = io.loadPattern(FILEPATH, FORMATID)   FORMATID kept for compatibility:
%       '1' = magnitude (dB) + phase (deg) — used only for XGTD .fz / .uan.

    if nargin < 2 || isempty(formatId)
        formatId = 'auto';
    end

    assert(ischar(filePath) || isstring(filePath), 'FILEPATH must be text.');
    filePath = char(filePath);

    [~, ~, ext] = fileparts(filePath);
    ext = lower(ext);

    switch ext
        case {'.fz', '.uan'}
            if ~strcmp(formatId, 'auto') && ~strcmp(formatId, '1')
                warning('io:loadPattern:formatIgnored', ...
                    'FORMAT ID ''%s'' ignored for XGTD files (only ''1'' is defined).', formatId);
            end
            P = io.loadXGTD_magphase(filePath);
        case '.ffs'
            P = io.loadCST_ffs(filePath);
        case '.ffd'
            P = io.loadHFSS_ffd(filePath);
        case '.out'
            P = io.loadGRASP_out(filePath);
        case '.ffe'
            P = io.loadFFE_dispatch(filePath);
        otherwise
            error('io:loadPattern:unsupported', ...
                'Unsupported extension ''%s''. Use .fz, .uan, .ffs, .ffd, .ffe, or .out.', ext);
    end
end
