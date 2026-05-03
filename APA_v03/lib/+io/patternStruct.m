function P = patternStruct(meta, thetaU, phiU, Eth, Eph)
%PATTERNSTRUCT Canonical antenna pattern struct for proc.processPattern.

    [Th, Ph] = ndgrid(thetaU(:), phiU(:));
    Eth = double(Eth);
    Eph = double(Eph);
    Gtheta_dB = 20 * log10(max(abs(Eth), sqrt(realmin)));
    Gphi_dB = 20 * log10(max(abs(Eph), sqrt(realmin)));

    P = struct();
    P.meta = meta;
    P.theta = Th;
    P.phi = Ph;
    P.Eth = Eth;
    P.Eph = Eph;
    P.Gtheta_dB = Gtheta_dB;
    P.Gphi_dB = Gphi_dB;
    P.phaseTheta_deg = rad2deg(angle(Eth));
    P.phasePhi_deg = rad2deg(angle(Eph));

    if ~isfield(meta, 'header')
        mg = max(max(Gtheta_dB(:)), max(Gphi_dB(:)));
        meta.header = struct('maximum_gain', mg);
        P.meta = meta;
    elseif isstruct(meta.header) && ~isfield(meta.header, 'maximum_gain')
        mg = max(max(Gtheta_dB(:)), max(Gphi_dB(:)));
        P.meta.header.maximum_gain = mg;
    end
end
