function P = loadPattern(filename, formatHint, opts)
%LOADPATTERN Dispatch to the right parser based on extension and Format hint.
%
%   formatHint values match the Format dropdown:
%       '1' = Eth/Eph mag-phase (dB, deg)        [default for .fz/.uan]
%       '2' = Eth/Eph Re/Im                       [default for .ffe/.ffd/.ffs]
%       '3' = Erh/Elh mag-phase (dB, deg)
%       '4' = Erh/Elh Re/Im                       [default for .out/.cut]
%       '5' = Gain pattern (magnitude only, dB)   [processed gain table]
%       'auto' = pick by extension
%
%   OPTS (optional struct) is forwarded to table-style parsers.  Useful
%   fields:
%       opts.gainCol - column index (>=3) selected as total gain for '5'.
%
%   The result is the canonical struct (theta, phi, Eth, Eph, meta).

    if nargin<2 || isempty(formatHint); formatHint = 'auto'; end
    if nargin<3 || isempty(opts); opts = struct(); end
    [~,~,ext] = fileparts(filename);
    ext = lower(ext);

    if strcmpi(formatHint,'auto')
        switch ext
            case {'.fz','.uan'};        formatHint = '1';
            case {'.ffe'};              formatHint = '2';
            case {'.ffd'};              formatHint = '2';
            case {'.ffs'};              formatHint = '2';
            case {'.out','.cut'};       formatHint = '4';
            otherwise;                  formatHint = '1';
        end
    end

    switch ext
        case {'.fz','.uan'}
            P = io.parseFZ(filename);
        case {'.ffe'}
            P = io.parseFFE(filename);
        case {'.ffd'}
            P = io.parseFFD(filename);
        case {'.ffs'}
            P = io.parseFFS(filename);
        case {'.out','.cut'}
            P = io.parseGRASPout(filename, true);
        case {'.csv','.txt','.dat'}
            P = io.parseGenericTable(filename, formatHint, opts);
        otherwise
            error('loadPattern:ext','Unsupported extension: %s',ext);
    end

    % If Format hint says CP and the parser delivered Eth/Eph, convert.
    if any(strcmp(formatHint,{'3','4'})) && ~ismember(ext,{'.out','.cut'})
        ER = P.Eth;
        EL = P.Eph;
        P.Eth =      (ER + EL)/sqrt(2);
        P.Eph =  1i*(ER - EL)/sqrt(2);
        P.meta.cp_converted = true;
    end

    P.meta.formatHint = formatHint;
end
