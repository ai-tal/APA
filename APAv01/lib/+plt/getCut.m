function [angle_deg, gainTotal_dB, gainR_dB, gainL_dB, axisLabel, fixedName, fixedValue] = getCut(R, cutType, cutValue)
%GETCUT Extract a 1D cut from the processed pattern as a FULL 360-deg sweep.
%
%   cutType = 'Phi Cut'  -> fix THETA at cutValue, sweep PHI 0..360.
%                           (i.e. a full phi cut at the chosen theta)
%   cutType = 'Theta Cut'-> fix PHI at cutValue, sweep THETA.
%                           Output is a full 360-deg cut: the first 0..180
%                           segment uses phi=cutValue, the 180..360 segment
%                           mirrors via phi=cutValue+180 so the user sees a
%                           continuous great-circle cut through zenith/nadir.

    switch cutType
        case 'Phi Cut'
            [~, it] = min(abs(R.theta - cutValue));
            angle_deg    = R.phi(:);
            gainTotal_dB = R.G_total_dB(it, :).';
            gainR_dB     = R.G_R_dB(    it, :).';
            gainL_dB     = R.G_L_dB(    it, :).';
            axisLabel    = sprintf('\\phi (\\circ)');
            fixedName    = '\theta';
            fixedValue   = R.theta(it);

        case 'Theta Cut'
            phi_a = mod(cutValue,     360);
            phi_b = mod(cutValue+180, 360);
            [~, ia] = min(abs(R.phi - phi_a));
            [~, ib] = min(abs(R.phi - phi_b));

            th    = R.theta(:);
            gTa   = R.G_total_dB(:, ia);
            gRa   = R.G_R_dB    (:, ia);
            gLa   = R.G_L_dB    (:, ia);

            % Mirror half (phi+180) is traversed from theta=180 back to 0
            % so the combined curve runs 0 -> 180 -> 360 continuously.
            gTb   = flipud(R.G_total_dB(:, ib));
            gRb   = flipud(R.G_R_dB    (:, ib));
            gLb   = flipud(R.G_L_dB    (:, ib));
            thB   = 360 - flipud(th);

            % Drop duplicate endpoints (theta=180 and wrap-around 360 == 0).
            if abs(thB(1) - th(end)) < 1e-6
                thB = thB(2:end);
                gTb = gTb(2:end); gRb = gRb(2:end); gLb = gLb(2:end);
            end

            angle_deg    = [th; thB];
            gainTotal_dB = [gTa; gTb];
            gainR_dB     = [gRa; gRb];
            gainL_dB     = [gLa; gLb];
            axisLabel    = sprintf('\\theta (\\circ)');
            fixedName    = '\phi';
            fixedValue   = R.phi(ia);

        otherwise
            error('getCut:type','Unknown cut type %s',cutType);
    end
end
