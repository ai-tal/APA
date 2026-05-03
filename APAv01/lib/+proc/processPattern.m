function R = processPattern(P, params)
%PROCESSPATTERN Compute derived quantities from a canonical pattern.
%
%   R = processPattern(P, params) where params is a struct with optional
%   fields:
%       Loss_dB      additional loss to subtract from gain    (default 0)
%       Pt_W         transmit power in Watts                  (default 1)
%       Rw_dB        incident-wave AR for PLF                 (default 6)
%       R_m          range to compute |E| / PFD               (default 1)
%
%   Returns R with fields (each Nth x Nph unless noted):
%       theta, phi              copied from P
%       Eth, Eph                input complex E-field
%       G_th_dB, G_ph_dB        per-component gain
%       G_total_dB              total gain (dBi)
%       E_R, E_L                CP complex E-field
%       G_R_dB, G_L_dB          CP gain (dBic)
%       AR_dB                   axial ratio (dB, signed: + RHCP, - LHCP)
%       PLF_dB                  polarization loss factor against Rw
%       EIRP_dBW                EIRP per direction
%       PFD_Wm2                 power flux density at R
%       E_Vm                    |E| at R in V/m
%       maxGain_dB              peak total gain
%       maxGain_dir             [theta_peak, phi_peak] in deg
%       dominantPol             'RHCP' | 'LHCP' | 'Linear'
%       table                   row table (Nth*Nph rows, 13 columns) for the
%                               output table view

    if nargin<2; params = struct; end
    if ~isfield(params,'Loss_dB'); params.Loss_dB = 0;  end
    if ~isfield(params,'Pt_W');    params.Pt_W    = 1;  end
    if ~isfield(params,'Rw_dB');   params.Rw_dB   = 6;  end
    if ~isfield(params,'R_m');     params.R_m     = 1;  end

    Eth = P.Eth;
    Eph = P.Eph;

    GthLin = abs(Eth).^2;
    GphLin = abs(Eph).^2;
    Gtot   = GthLin + GphLin;

    R.theta      = P.theta;
    R.phi        = P.phi;
    R.Eth        = Eth;
    R.Eph        = Eph;
    R.G_th_dB    = 10*log10(GthLin + eps) - params.Loss_dB;
    R.G_ph_dB    = 10*log10(GphLin + eps) - params.Loss_dB;
    R.G_total_dB = 10*log10(Gtot   + eps) - params.Loss_dB;

    % Circular components (convention from reference script):
    %   E_RHCP = (E_theta + j*E_phi) / sqrt(2)
    %   E_LHCP = (E_theta - j*E_phi) / sqrt(2)
    s2 = sqrt(2);
    R.E_R   = (Eth + 1i*Eph)/s2;
    R.E_L   = (Eth - 1i*Eph)/s2;
    Rmag    = abs(R.E_R);
    Lmag    = abs(R.E_L);
    R.G_R_dB = 20*log10(Rmag + eps) - params.Loss_dB;
    R.G_L_dB = 20*log10(Lmag + eps) - params.Loss_dB;

    % Axial ratio as ratio of CP magnitudes, signed by dominant sense.
    %   AR = (|E_R| + |E_L|) / (|E_R| - |E_L|)
    %   AR > 0 => RHCP dominant, AR < 0 => LHCP dominant.
    denom = Rmag - Lmag;
    AR_lin = (Rmag + Lmag) ./ denom;
    AR_lin(abs(denom) < eps) = sqrt(10)/1e13;           % -> 250 dB (linear)
    R.AR_dB = 20.*log10(abs(AR_lin)) .* sign(AR_lin);

    % Polarization Loss Factor (dB) vs an incident wave with axial ratio
    % Rw_dB, worst-case orientation (dTau = 90 deg).  Matches reference
    % process_pattern.m formulation.
    Ra     = AR_lin;
    dominantRHCP = mean(Rmag(:)) > mean(Lmag(:));
    Rw_sign = 2*dominantRHCP - 1;                        % +1 RHCP, -1 LHCP
    Rw     = Rw_sign * 10.^(params.Rw_dB/20);
    dTau   = 90;
    R.PLF_dB = 10*log10(0.5 + ...
        (4*Ra.*Rw + (Ra.^2 - 1).*(Rw.^2 - 1).*cosd(2*dTau)) ./ ...
        (2*(Ra.^2 + 1).*(Rw.^2 + 1)));

    % EIRP, PFD, |E|.
    Pt_dBW = 10*log10(max(params.Pt_W, eps));
    R.EIRP_dBW = R.G_total_dB + Pt_dBW;
    EIRP_W = 10.^(R.EIRP_dBW/10);
    R.PFD_Wm2  = EIRP_W ./ (4*pi*params.R_m^2);
    R.E_Vm     = sqrt(60*params.Pt_W .* 10.^(R.G_total_dB/10)) ./ params.R_m;

    % Peak.
    [pkVal, idx] = max(R.G_total_dB(:));
    [it, ip] = ind2sub(size(R.G_total_dB), idx);
    R.maxGain_dB  = pkVal;
    R.maxGain_dir = [P.theta(it), P.phi(ip)];

    % Dominant polarization (average magnitudes across the whole sphere).
    if mean(Rmag(:)) > mean(Lmag(:))
        R.dominantPol = 'RHCP';
    elseif mean(Lmag(:)) > mean(Rmag(:))
        R.dominantPol = 'LHCP';
    else
        R.dominantPol = 'Linear';
    end
    halfPower = R.G_total_dB >= (pkVal - 3);
    if any(halfPower(:))
        meanAR_mainBeam = mean(R.AR_dB(halfPower));
        if abs(meanAR_mainBeam) > 40
            R.dominantPol = 'Linear';
        end
    end

    % Output table (one row per (theta, phi) sample).
    [Tg, Pg] = ndgrid(P.theta, P.phi);
    R.table = [Tg(:) Pg(:) R.G_total_dB(:) R.G_R_dB(:) R.G_L_dB(:) ...
               angle(R.E_R(:))*180/pi angle(R.E_L(:))*180/pi ...
               R.AR_dB(:) R.PLF_dB(:) R.G_th_dB(:) ...
               R.EIRP_dBW(:) R.PFD_Wm2(:) R.E_Vm(:)];

    % Useful summaries.
    R.maxGain_th_dB = max(R.G_th_dB(:));
    R.maxGain_ph_dB = max(R.G_ph_dB(:));
    R.maxE_th_Vm    = max(abs(Eth(:)));
    R.maxE_ph_Vm    = max(abs(Eph(:)));

    R.params = params;
    R.meta   = P.meta;
end
