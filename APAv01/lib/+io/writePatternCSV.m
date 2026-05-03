function writePatternCSV(P, filename)
%WRITEPATTERNCSV Write pattern as a 6-column CSV (theta,phi,|Eth|dB,|Eph|dB,angEth,angEph).

    [Tg, Pg] = ndgrid(P.theta, P.phi);
    T = table(Tg(:), Pg(:), ...
              20*log10(abs(P.Eth(:))+eps), 20*log10(abs(P.Eph(:))+eps), ...
              angle(P.Eth(:))*180/pi,      angle(P.Eph(:))*180/pi, ...
        'VariableNames', {'Theta_deg','Phi_deg','E_TH_dB','E_PH_dB','E_TH_phase_deg','E_PH_phase_deg'});
    writetable(T, filename);
end
