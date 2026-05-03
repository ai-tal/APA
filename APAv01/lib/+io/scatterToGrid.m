function [Eth,Eph] = scatterToGrid(theta,phi,th_col,ph_col,Eth_v,Eph_v)
%SCATTERTOGRID Place scattered (th,ph) -> (Eth,Eph) samples on a (theta,phi) mesh.

    Nth = numel(theta);
    Nph = numel(phi);
    Eth = zeros(Nth,Nph);
    Eph = zeros(Nth,Nph);
    seen = false(Nth,Nph);

    [~, ti] = min(abs(th_col(:) - theta(:).'),[],2);
    [~, pi_] = min(abs(ph_col(:) - phi(:).'),[],2);
    idx = sub2ind([Nth Nph], ti, pi_);
    Eth(idx) = Eth_v;
    Eph(idx) = Eph_v;
    seen(idx) = true;

    if any(~seen(:))
        % Wrap-around handling: copy phi=0 to phi=360 if missing.
        if abs(phi(end)-360)<1e-6 && abs(phi(1))<1e-6 && all(~seen(:,end))
            Eth(:,end) = Eth(:,1);
            Eph(:,end) = Eph(:,1);
            seen(:,end) = true;
        end
    end
end
