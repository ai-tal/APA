function P = parseFFD(filename)
%PARSEFFD Read an HFSS .ffd far-field file.
%   Header (3 lines):
%       theta_min  theta_max  Nth
%       phi_min    phi_max    Nph
%       Frequencies  Nf
%       Frequency  <Hz>             (per frequency block)
%   Data: 4 columns Re(Eth) Im(Eth) Re(Eph) Im(Eph).
%   HFSS emits PHI varying fastest (for each theta, all phi values).

    fid = fopen(filename,'r');
    if fid<0; error('parseFFD:open','Cannot open %s',filename); end
    cleaner = onCleanup(@() fclose(fid));

    h1 = sscanf(fgetl(fid),'%f %f %d');
    h2 = sscanf(fgetl(fid),'%f %f %d');
    line3 = strtrim(fgetl(fid));
    Nf = sscanf(regexprep(line3,'[A-Za-z_]+',''),'%d');
    line4 = strtrim(fgetl(fid));
    freq = sscanf(regexprep(line4,'[A-Za-z_]+',''),'%f');
    if isempty(Nf); Nf = 1; end
    if isempty(freq); freq = NaN; end

    th_min = h1(1); th_max = h1(2); Nth = h1(3);
    ph_min = h2(1); ph_max = h2(2); Nph = h2(3);

    block = Nth*Nph;
    raw = fscanf(fid,'%f',[4, block]).';

    theta = linspace(th_min, th_max, Nth);
    phi   = linspace(ph_min, ph_max, Nph);

    % HFSS ordering: phi varies fastest within each theta row.
    % reshape(col,Nph,Nth) fills columns (each theta) with Nph phi samples,
    % then we transpose so result is Nth x Nph.
    Eth = reshape(raw(:,1) + 1i*raw(:,2), Nph, Nth).';
    Eph = reshape(raw(:,3) + 1i*raw(:,4), Nph, Nth).';

    if ph_min < 0
        [phi, order] = sort(mod(phi,360));
        Eth = Eth(:,order);
        Eph = Eph(:,order);
        [phi, ia] = unique(phi);
        Eth = Eth(:,ia);
        Eph = Eph(:,ia);
    end

    [~,name,ext] = fileparts(filename);
    P.theta = theta;
    P.phi   = phi;
    P.Eth   = Eth;
    P.Eph   = Eph;
    P.meta  = struct('source','parseFFD','file',filename,'name',[name ext], ...
                     'format','ffd','freq_Hz',freq,'R_ref_m',1, ...
                     'maxGain_dB',NaN,'normalized',false, ...
                     'header',struct('Nf',Nf,'Nth',Nth,'Nph',Nph));
    P = io.closePhiSeam(P);
end
