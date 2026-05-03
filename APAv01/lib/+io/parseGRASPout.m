function P = parseGRASPout(filename, asCP)
%PARSEGRASPOUT Read a GRASP .out / .cut TICRA-style file.
%   By default POL-1 / POL-2 are interpreted as RHCP / LHCP and converted to
%   Eth, Eph via:
%       Eth =      (E_R + E_L) / sqrt(2)
%       Eph =  1i*(E_R - E_L) / sqrt(2)
%   Pass asCP=false to interpret POL-1/POL-2 as Eth/Eph directly.

    if nargin<2 || isempty(asCP); asCP = true; end

    fid = fopen(filename,'r');
    if fid<0; error('parseGRASPout:open','Cannot open %s',filename); end
    cleaner = onCleanup(@() fclose(fid));

    % Skip up to 2 header lines (TICRA cut file has a free-text title and a
    % column header).
    headerLines = 0;
    pos = ftell(fid);
    for k = 1:5
        line = fgetl(fid);
        if ~ischar(line); break; end
        if any(isletter(line))
            headerLines = headerLines + 1;
            pos = ftell(fid);
        else
            fseek(fid, pos, 'bof');
            break;
        end
    end

    raw = fscanf(fid,'%f');
    nCols = 6;
    if mod(numel(raw),nCols)~=0
        % some cut files are 4-col; bail out
        error('parseGRASPout:cols','Unexpected column count in %s',filename);
    end
    M = reshape(raw,nCols,[]).';
    th_col = M(:,1);
    ph_col = M(:,2);
    P1     = M(:,3) + 1i*M(:,4);
    P2     = M(:,5) + 1i*M(:,6);

    if asCP
        Eth_v =      (P1 + P2)/sqrt(2);
        Eph_v =  1i*(P1 - P2)/sqrt(2);
    else
        Eth_v = P1;
        Eph_v = P2;
    end

    theta = unique(th_col,'sorted').';
    phi   = unique(ph_col,'sorted').';
    [Eth,Eph] = io.scatterToGrid(theta,phi,th_col,ph_col,Eth_v,Eph_v);

    [~,name,ext] = fileparts(filename);
    P.theta = theta;
    P.phi   = phi;
    P.Eth   = Eth;
    P.Eph   = Eph;
    P.meta  = struct('source','parseGRASPout','file',filename,'name',[name ext], ...
                     'format','out','freq_Hz',NaN,'R_ref_m',1, ...
                     'maxGain_dB',NaN,'normalized',false, ...
                     'asCP', asCP);
    P = io.closePhiSeam(P);
end
