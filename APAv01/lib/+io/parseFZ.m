function P = parseFZ(filename)
%PARSEFZ Read an XGTD .fz / .uan far-zone gain pattern file.
%
%   P = parseFZ(FILENAME) returns the canonical pattern struct with fields
%   theta (1xNth, deg), phi (1xNph, deg), Eth (Nth x Nph complex V/m),
%   Eph (Nth x Nph complex V/m), and meta.
%
%   The file is a Remcom XGTD keyword-headed text file:
%       begin_<parameters>
%           format free
%           phi_min/phi_max/phi_inc
%           theta_min/theta_max/theta_inc
%           complex / mag_phase
%           pattern gain
%           magnitude dB
%           maximum_gain <dB>
%           polarization theta_phi
%       end_<parameters>
%   followed by 6 columns: theta, phi, |Eth|_dB, |Eph|_dB, ang(Eth)_deg,
%   ang(Eph)_deg.

    fid = fopen(filename,'r');
    if fid < 0
        error('parseFZ:open','Cannot open %s', filename);
    end
    cleaner = onCleanup(@() fclose(fid));

    H = struct('phi_min',0,'phi_max',360,'phi_inc',2, ...
               'theta_min',0,'theta_max',180,'theta_inc',2, ...
               'pattern','gain','magnitude','dB', ...
               'maximum_gain',0,'phase','degrees', ...
               'polarization','theta_phi','complex',true,'mag_phase',true, ...
               'frequency',NaN);

    inHdr = false;
    while true
        line = fgetl(fid);
        if ~ischar(line); error('parseFZ:eof','Header not closed.'); end
        line = strtrim(line);
        if isempty(line); continue; end
        if startsWith(line,'begin_<parameters>'); inHdr = true; continue; end
        if startsWith(line,'end_<parameters>');   break;             end
        if ~inHdr; continue; end
        toks = regexp(line,'\s+','split');
        key = toks{1};
        switch key
            case 'phi_min',      H.phi_min      = sscanf(toks{2},'%f');
            case 'phi_max',      H.phi_max      = sscanf(toks{2},'%f');
            case 'phi_inc',      H.phi_inc      = sscanf(toks{2},'%f');
            case 'theta_min',    H.theta_min    = sscanf(toks{2},'%f');
            case 'theta_max',    H.theta_max    = sscanf(toks{2},'%f');
            case 'theta_inc',    H.theta_inc    = sscanf(toks{2},'%f');
            case 'maximum_gain', H.maximum_gain = sscanf(toks{2},'%f');
            case 'frequency',    H.frequency    = sscanf(toks{2},'%f');
            case 'magnitude',    H.magnitude    = toks{2};
            case 'phase',        H.phase        = toks{2};
            case 'polarization', H.polarization = toks{2};
            case 'pattern',      H.pattern      = toks{2};
            case 'mag_phase',    H.mag_phase    = true;
            case 'real_imag',    H.mag_phase    = false;
            case 'complex',      H.complex      = true;
        end
    end

    raw = fscanf(fid,'%f');
    nCols = 6;
    if mod(numel(raw), nCols) ~= 0
        error('parseFZ:cols','Data block is not a multiple of %d columns (got %d).', nCols, numel(raw));
    end
    M = reshape(raw, nCols, []).';

    theta = (H.theta_min:H.theta_inc:H.theta_max);
    phi   = (H.phi_min:H.phi_inc:H.phi_max);
    Nth = numel(theta);
    Nph = numel(phi);
    if size(M,1) ~= Nth*Nph
        warning('parseFZ:size','Row count %d does not match Nth*Nph=%d; trimming/padding.', size(M,1), Nth*Nph);
        n = min(size(M,1), Nth*Nph);
        Mfull = zeros(Nth*Nph, nCols);
        Mfull(1:n,:) = M(1:n,:);
        M = Mfull;
    end

    th_col = M(:,1);
    ph_col = M(:,2);
    GthDB  = M(:,3);
    GphDB  = M(:,4);
    AthDeg = M(:,5);
    AphDeg = M(:,6);

    % Column 3 and 4 are the per-polarization GAIN in dB.  Per the Remcom /
    % XGTD convention they are interpreted as E-field amplitudes in dB so
    % that 20*log10(|Eth|) == column 3 and |Eth|^2+|Eph|^2 yields the total
    % antenna gain in dBi.
    Eth_v = 10.^(GthDB/20) .* exp(1i*AthDeg*pi/180);
    Eph_v = 10.^(GphDB/20) .* exp(1i*AphDeg*pi/180);

    % O(N) grid placement: instead of building an N x M distance matrix to
    % find the nearest theta/phi index for every sample, round each row's
    % (theta, phi) into integer grid coordinates directly.  This is what
    % drives the bulk of the load time on large patterns (181x361 ~ 65K).
    ti = round((th_col - H.theta_min) / H.theta_inc) + 1;
    pj = round((ph_col - H.phi_min)   / H.phi_inc)   + 1;
    valid = ti >= 1 & ti <= Nth & pj >= 1 & pj <= Nph;
    if ~all(valid)
        % Fall back to nearest-axis lookup for any out-of-grid stragglers.
        ti(~valid) = indexOf(th_col(~valid), theta);
        pj(~valid) = indexOf(ph_col(~valid), phi);
    end
    keyTP = sub2ind([Nth Nph], ti, pj);

    Eth = complex(zeros(Nth, Nph));
    Eph = complex(zeros(Nth, Nph));
    seen = false(Nth, Nph);
    Eth(keyTP) = Eth_v;
    Eph(keyTP) = Eph_v;
    seen(keyTP) = true;

    if ~all(seen(:))
        warning('parseFZ:gaps','%d grid points were missing in %s; filled with 0.', nnz(~seen), filename);
    end

    [~,name,ext] = fileparts(filename);
    P.theta = theta;
    P.phi   = phi;
    P.Eth   = Eth;
    P.Eph   = Eph;
    P.meta  = struct('source','parseFZ', ...
                     'file', filename, ...
                     'name', [name ext], ...
                     'format','fz', ...
                     'freq_Hz', H.frequency, ...
                     'R_ref_m', 1, ...
                     'maxGain_dB', H.maximum_gain, ...
                     'normalized', true, ...
                     'header', H);
    P = io.closePhiSeam(P);
end

function idx = indexOf(values, axis)
%INDEXOF Map each value in VALUES to its nearest index in AXIS.
    [~, idx] = min(abs(values(:) - axis(:).'),[],2);
end
