function [G, label, cmap, limOverride, isAR] = selectComponent(R, name)
%SELECTCOMPONENT Pick a 2D matrix and colormap/limit hints from a processed result.
    isAR = false;
    cmap = jet(256);
    limOverride = [];                                 % empty = use ctrl.Cmin/Cmax
    switch name
        case 'Total Gain';     G = R.G_total_dB; label = 'G_{total} (dBi)';
        case 'RHCP Gain';      G = R.G_R_dB;     label = 'G_{RHCP} (dBic)';
        case {'LHCP  Gain','LHCP Gain'}
                               G = R.G_L_dB;     label = 'G_{LHCP} (dBic)';
        case 'Axial Ratio'
            G     = R.AR_dB;
            label = 'AR (dB)';
            cmap  = plt.thermCmap(255);
            isAR  = true;
            arMax = prctile(abs(G(:)), 98);
            if ~isfinite(arMax) || arMax < 3; arMax = 6; end
            arMax = min(arMax, 40);
            limOverride = [-arMax arMax];
        case 'Polarized Gain'; G = R.G_th_dB;    label = 'G_{\theta} (dBi)';
        otherwise;             G = R.G_total_dB; label = 'G_{total} (dBi)';
    end
end
