function P = parseFFS(filename)
%PARSEFFS Read a CST-style .ffs file (simplified 6-column tab-separated).
%   Header line:  Phi  Theta  Re(E-TH)  Im(E-TH)  Re(E-PH)  Im(E-PH)

    T = readmatrix(filename, 'NumHeaderLines',1, 'FileType','text');
    if size(T,2) < 6
        error('parseFFS:cols','Expected 6 columns, got %d',size(T,2));
    end
    ph_col = T(:,1);
    th_col = T(:,2);
    Eth_v  = T(:,3) + 1i*T(:,4);
    Eph_v  = T(:,5) + 1i*T(:,6);

    theta = unique(th_col,'sorted').';
    phi   = unique(ph_col,'sorted').';
    [Eth,Eph] = io.scatterToGrid(theta,phi,th_col,ph_col,Eth_v,Eph_v);

    [~,name,ext] = fileparts(filename);
    P.theta = theta;
    P.phi   = phi;
    P.Eth   = Eth;
    P.Eph   = Eph;
    P.meta  = struct('source','parseFFS','file',filename,'name',[name ext], ...
                     'format','ffs','freq_Hz',NaN,'R_ref_m',1, ...
                     'maxGain_dB',NaN,'normalized',false);
    P = io.closePhiSeam(P);
end
