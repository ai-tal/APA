function P = parseFFE(filename)
%PARSEFFE Read a FEKO .ffe far-field file (single configuration / frequency).
%
%   Columns: Theta  Phi  Re(Eth)  Im(Eth)  Re(Eph)  Im(Eph) ...
%   Headers are lines beginning with '#' or '*'.

    fid = fopen(filename,'r');
    if fid<0; error('parseFFE:open','Cannot open %s',filename); end
    cleaner = onCleanup(@() fclose(fid));

    freq = NaN;
    Nth = NaN; Nph = NaN;
    data = [];
    while true
        line = fgetl(fid);
        if ~ischar(line); break; end
        s = strtrim(line);
        if isempty(s); continue; end
        if startsWith(s,'**'); continue; end
        if startsWith(s,'##'); continue; end
        if startsWith(s,'#')
            tok = regexp(s,'#Frequency\s*:\s*([\deE\+\-\.]+)','tokens','once');
            if ~isempty(tok); freq = str2double(tok{1}); end
            tok = regexp(s,'#No\.?\s*of\s*Theta\s*Samples\s*:\s*(\d+)','tokens','once');
            if ~isempty(tok); Nth = str2double(tok{1}); end
            tok = regexp(s,'#No\.?\s*of\s*Phi\s*Samples\s*:\s*(\d+)','tokens','once');
            if ~isempty(tok); Nph = str2double(tok{1}); end
            continue;
        end
        nums = sscanf(s,'%f');
        if isempty(nums); continue; end
        data(end+1,1:numel(nums)) = nums.'; %#ok<AGROW>
    end
    if isempty(data); error('parseFFE:nodata','No numeric data in %s',filename); end
    if size(data,2) < 6
        error('parseFFE:cols','Expected at least 6 columns, got %d',size(data,2));
    end

    th_col = data(:,1);
    ph_col = data(:,2);
    Eth_v  = data(:,3) + 1i*data(:,4);
    Eph_v  = data(:,5) + 1i*data(:,6);

    theta = unique(th_col,'sorted').';
    phi   = unique(ph_col,'sorted').';
    if ~isnan(Nth) && Nth ~= numel(theta)
        warning('parseFFE:Nth','Header Nth=%d but unique values=%d',Nth,numel(theta));
    end
    if ~isnan(Nph) && Nph ~= numel(phi)
        warning('parseFFE:Nph','Header Nph=%d but unique values=%d',Nph,numel(phi));
    end

    [Eth,Eph] = io.scatterToGrid(theta,phi,th_col,ph_col,Eth_v,Eph_v);

    [~,name,ext] = fileparts(filename);
    P.theta = theta;
    P.phi   = phi;
    P.Eth   = Eth;
    P.Eph   = Eph;
    P.meta  = struct('source','parseFFE','file',filename,'name',[name ext], ...
                     'format','ffe','freq_Hz',freq,'R_ref_m',1, ...
                     'maxGain_dB',NaN,'normalized',false);
    P = io.closePhiSeam(P);
end
