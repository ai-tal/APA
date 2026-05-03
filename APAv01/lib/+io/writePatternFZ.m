function writePatternFZ(P, filename)
%WRITEPATTERNFZ Write a canonical pattern out as a Remcom .fz file.

    fid = fopen(filename,'w');
    if fid<0; error('writePatternFZ:open','Cannot open %s',filename); end
    cleaner = onCleanup(@() fclose(fid));

    GthLin = abs(P.Eth).^2;
    GphLin = abs(P.Eph).^2;
    sumLin = GthLin + GphLin;
    peakDB = 10*log10(max(sumLin(:)) + eps);

    fprintf(fid,'begin_<parameters> \n');
    fprintf(fid,'format free\n');
    fprintf(fid,'phi_min %.7f\n',   P.phi(1));
    fprintf(fid,'phi_max %.7f\n',   P.phi(end));
    fprintf(fid,'phi_inc %.7f\n',   mean(diff(P.phi)));
    fprintf(fid,'theta_min %.7f\n', P.theta(1));
    fprintf(fid,'theta_max %.7f\n', P.theta(end));
    fprintf(fid,'theta_inc %.7f\n', mean(diff(P.theta)));
    fprintf(fid,'complex\n');
    fprintf(fid,'mag_phase\n');
    fprintf(fid,'pattern gain\n');
    fprintf(fid,'magnitude dB\n');
    fprintf(fid,'maximum_gain %.5f\n', peakDB);
    fprintf(fid,'phase degrees\n');
    fprintf(fid,'direction degrees\n');
    fprintf(fid,'polarization theta_phi\n');
    fprintf(fid,'end_<parameters>\n');

    Nth = numel(P.theta);
    Nph = numel(P.phi);
    GthDB = 10*log10(GthLin + eps);
    GphDB = 10*log10(GphLin + eps);
    AthDeg = angle(P.Eth)*180/pi;
    AphDeg = angle(P.Eph)*180/pi;

    for it = 1:Nth
        for ip = 1:Nph
            fprintf(fid,'%g\t%g\t%.4f\t%.4f\t%.3f\t%.3f\n', ...
                P.theta(it), P.phi(ip), GthDB(it,ip), GphDB(it,ip), AthDeg(it,ip), AphDeg(it,ip));
        end
    end
end
