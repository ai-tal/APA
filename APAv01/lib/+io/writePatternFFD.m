function writePatternFFD(P, filename)
%WRITEPATTERNFFD Write pattern as HFSS .ffd (4-column Re/Im block).

    fid = fopen(filename,'w');
    if fid<0; error('writePatternFFD:open','Cannot open %s',filename); end
    cleaner = onCleanup(@() fclose(fid));

    Nth = numel(P.theta);
    Nph = numel(P.phi);
    freq = NaN;
    if isfield(P.meta,'freq_Hz') && isfinite(P.meta.freq_Hz); freq = P.meta.freq_Hz; end

    fprintf(fid, '%g %g %d\n', P.theta(1), P.theta(end), Nth);
    fprintf(fid, '%g %g %d\n', P.phi(1),   P.phi(end),   Nph);
    fprintf(fid, 'Frequencies 1\n');
    if isfinite(freq)
        fprintf(fid, 'Frequency %.10e\n', freq);
    else
        fprintf(fid, 'Frequency 0.0\n');
    end
    % HFSS order: theta varies fastest, then phi.
    for ip = 1:Nph
        for it = 1:Nth
            fprintf(fid, '%.9e\t%.9e\t%.9e\t%.9e\n', ...
                real(P.Eth(it,ip)), imag(P.Eth(it,ip)), ...
                real(P.Eph(it,ip)), imag(P.Eph(it,ip)));
        end
    end
end
