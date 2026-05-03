function [lims, ticks] = pickLimits(ctrl, limOverride)
%PICKLIMITS Produce [cmin cmax] and tick vector given the plot controls and
%optional component-specific override (for axial ratio etc.).
    if nargin>=2 && ~isempty(limOverride)
        lims = limOverride;
        span = diff(lims);
        if span > 20
            ticks = linspace(lims(1), lims(2), 9);
        else
            ticks = linspace(lims(1), lims(2), 7);
        end
    else
        lims  = [ctrl.Cmin ctrl.Cmax];
        step  = max(ctrl.Cstep, 1);
        ticks = ctrl.Cmin:step:ctrl.Cmax;
    end
end
