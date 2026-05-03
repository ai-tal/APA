function writePatternFFE(P, filename)
%WRITEPATTERNFFE Write pattern in a simplified FEKO .ffe format (Re/Im E-fields).

    fid = fopen(filename,'w');
    if fid<0; error('writePatternFFE:open','Cannot open %s',filename); end
    cleaner = onCleanup(@() fclose(fid));

    freq = NaN;
    if isfield(P.meta,'freq_Hz') && isfinite(P.meta.freq_Hz); freq = P.meta.freq_Hz; end

    fprintf(fid, '##File Type: Far field\n');
    fprintf(fid, '##File Format: 6\n');
    fprintf(fid, '##Source: APA_v01 export\n');
    fprintf(fid, '##Date: %s\n\n\n', datestr(now,'yyyy-mm-dd HH:MM:SS'));
    fprintf(fid, '#Configuration Name: APA_export\n');
    fprintf(fid, '#Request Name: FarField1\n');
    if isfinite(freq)
        fprintf(fid,'#Frequency: %.8e\n', freq);
    end
    fprintf(fid, '#Coordinate System: Spherical\n');
    fprintf(fid, '#No. of Theta Samples: %d\n', numel(P.theta));
    fprintf(fid, '#No. of Phi Samples: %d\n',   numel(P.phi));
    fprintf(fid, '#Result Type: Directivity\n');
    fprintf(fid, '#No. of Header Lines: 1\n');
    fprintf(fid, '#    "Theta"   "Phi"   "Re(Etheta)"   "Im(Etheta)"   "Re(Ephi)"   "Im(Ephi)"   "Directivity(Theta)"   "Directivity(Phi)"   "Directivity(Total)"\n');

    Nth = numel(P.theta);
    Nph = numel(P.phi);
    G_th_dB = 20*log10(abs(P.Eth) + eps);
    G_ph_dB = 20*log10(abs(P.Eph) + eps);
    G_tot_dB= 10*log10(abs(P.Eth).^2 + abs(P.Eph).^2 + eps);
    for ip = 1:Nph
        for it = 1:Nth
            fprintf(fid, ' %.8e  %.8e  %.8e  %.8e  %.8e  %.8e  %.8e  %.8e  %.8e\n', ...
                P.theta(it), P.phi(ip), ...
                real(P.Eth(it,ip)), imag(P.Eth(it,ip)), ...
                real(P.Eph(it,ip)), imag(P.Eph(it,ip)), ...
                G_th_dB(it,ip), G_ph_dB(it,ip), G_tot_dB(it,ip));
        end
    end
end
