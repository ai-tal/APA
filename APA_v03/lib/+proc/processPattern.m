function R = processPattern(P, opts)
%PROCESSPATTERN Derive total gain, circular components, and axial ratio from loaded pattern.
%   R = proc.processPattern(P, opts)  opts is reserved (struct, may be empty).

    if nargin < 2
        opts = struct;
    end

    Eth = P.Eth;
    Eph = P.Eph;
    R.theta = P.theta;
    R.phi = P.phi;

    % Total power gain (dB) relative to same reference as Gtheta/Gphi columns
    pLin = abs(Eth).^2 + abs(Eph).^2;
    pLin = max(pLin, realmin);
    R.gainTotal_dB = 10 * log10(pLin);
    R.maxGain_dB = max(R.gainTotal_dB(:));

    % Ludwig-3 linear to circular (IEEE-style), same complex mapping as phased pol2circpol
    % [E_L; E_R] = (1/sqrt(2))*[1 -1j; 1 1j] * [Eθ; Eφ]
    sq2 = sqrt(2);
    E_L = (Eth - 1j * Eph) / sq2;
    E_R = (Eth + 1j * Eph) / sq2;

    plR = max(abs(E_R).^2, realmin);
    plL = max(abs(E_L).^2, realmin);
    R.gainLHCP_dB = 10 * log10(plL);
    R.gainRHCP_dB = 10 * log10(plR);

    % Axial ratio (dB): ratio of major to minor axis (>1 linear => positive dB)
    num = max(abs(E_R), abs(E_L));
    den = max(min(abs(E_R), abs(E_L)), sqrt(realmin));
    AR_lin = max(num ./ den, 1);
    R.axialRatio_dB = 20 * log10(AR_lin);

    R.phaseLHCP_deg = rad2deg(angle(E_L));
    R.phaseRHCP_deg = rad2deg(angle(E_R));

    R.opts = opts;

    % Retain linear gains for coverage sentinel handling
    R.Gtheta_dB = P.Gtheta_dB;
    R.Gphi_dB = P.Gphi_dB;
end
