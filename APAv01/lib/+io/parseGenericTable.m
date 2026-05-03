function P = parseGenericTable(filename, formatHint, opts)
%PARSEGENERICTABLE Read a 4 / 6 / N column ASCII table per the Format hint.
%   Layouts (theta, phi always columns 1,2):
%       '1' Eth/Eph mag-phase: |Eth|_dB |Eph|_dB ang(Eth) ang(Eph)
%       '2' Eth/Eph Re/Im    : Re(Eth) Im(Eth) Re(Eph) Im(Eph)
%       '3' Erh/Elh mag-phase
%       '4' Erh/Elh Re/Im
%       '5' Gain pattern     : G_dB (single gain column)
%
%   For '5' (processed gain), OPTS.gainCol selects which data column (>=3)
%   holds the total gain in dB.  Default = 3.

    if nargin<3; opts = struct(); end
    if ~isfield(opts,'gainCol') || isempty(opts.gainCol); opts.gainCol = 3; end

    M = readmatrix(filename,'FileType','text');
    if isempty(M); error('parseGenericTable:nodata','No numeric data in %s',filename); end
    th_col = M(:,1);
    ph_col = M(:,2);
    rest   = M(:,3:end);
    theta = unique(th_col,'sorted').';
    phi   = unique(ph_col,'sorted').';
    nDataCols = size(M,2);

    switch formatHint
        case {'1','3'}
            magA = rest(:,1); magB = rest(:,2);
            phA  = rest(:,3); phB  = rest(:,4);
            A = sqrt(10.^(magA/10)) .* exp(1i*phA*pi/180);
            B = sqrt(10.^(magB/10)) .* exp(1i*phB*pi/180);
        case {'2','4'}
            A = rest(:,1) + 1i*rest(:,2);
            B = rest(:,3) + 1i*rest(:,4);
        case '5'
            gi = max(1, opts.gainCol - 2);   % rest(:,1) is column 3
            if gi > size(rest,2)
                error('parseGenericTable:gainCol', ...
                    'Requested gain column %d but file only has %d columns.', ...
                    opts.gainCol, nDataCols);
            end
            magA = rest(:,gi);
            A = sqrt(10.^(magA/10));
            B = zeros(size(A));
        otherwise
            error('parseGenericTable:fmt','Unknown formatHint %s',formatHint);
    end

    if any(strcmp(formatHint,{'3','4'}))
        Eth_v =      (A + B)/sqrt(2);
        Eph_v =  1i*(A - B)/sqrt(2);
    else
        Eth_v = A;
        Eph_v = B;
    end

    [Eth,Eph] = io.scatterToGrid(theta,phi,th_col,ph_col,Eth_v,Eph_v);

    [~,name,ext] = fileparts(filename);
    P.theta = theta;
    P.phi   = phi;
    P.Eth   = Eth;
    P.Eph   = Eph;
    P.meta  = struct('source','parseGenericTable','file',filename,'name',[name ext], ...
                     'format','generic','freq_Hz',NaN,'R_ref_m',1, ...
                     'maxGain_dB',NaN,'normalized',false, ...
                     'formatHint',formatHint, ...
                     'nDataCols',nDataCols, ...
                     'gainCol', opts.gainCol);
    P = io.closePhiSeam(P);
end
