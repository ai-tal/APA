function writePatternFFS(P, filename)
%WRITEPATTERNFFS Write pattern as CST-style .ffs (6 columns: Phi Theta Re/Im E).

    fid = fopen(filename,'w');
    if fid<0; error('writePatternFFS:open','Cannot open %s',filename); end
    cleaner = onCleanup(@() fclose(fid));

    fprintf(fid, '// Phi[deg] Theta[deg] Re(E_TH) Im(E_TH) Re(E_PH) Im(E_PH)\n');
    Nth = numel(P.theta);
    Nph = numel(P.phi);
    for ip = 1:Nph
        for it = 1:Nth
            fprintf(fid, '%g\t%g\t%.9e\t%.9e\t%.9e\t%.9e\n', ...
                P.phi(ip), P.theta(it), ...
                real(P.Eth(it,ip)), imag(P.Eth(it,ip)), ...
                real(P.Eph(it,ip)), imag(P.Eph(it,ip)));
        end
    end
end
