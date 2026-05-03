function plotSpherical(ax, R, comp, ctrl)
%PLOTSPHERICAL Gain painted on a unit sphere (no radial deformation).
%   Reuses an existing surf handle on subsequent refreshes (CData-only
%   update) so a component switch is essentially instant.

    R = plt.downsampleForRender(R);
    [G, lbl, cmap, limOv] = plt.selectComponent(R, comp);
    [lims, ticks] = plt.pickLimits(ctrl, limOv);

    [Tg, Pg] = ndgrid(deg2rad(R.theta), deg2rad(R.phi));
    X = sin(Tg).*cos(Pg);
    Y = sin(Tg).*sin(Pg);
    Z = cos(Tg);

    [h, isNew] = plt.upsertSurface(ax, 'sphere', X, Y, Z, G);

    if isNew
        title(ax,'');
        plt.add3DHelpers(ax, 1.0);
        plt.enableRotate3D(ax);
    end
    plt.lock3DCameraBox(ax, 1.3);

    clim(ax, lims);
    colormap(ax, cmap);
    cb = colorbar(ax); cb.Label.String = lbl; cb.Ticks = ticks;

    view(ax, ctrl.Az, ctrl.El);

    delete(findall(ax, 'Tag','PeakMarker'));
    if isfield(ctrl,'ShowPeakMarker') && ctrl.ShowPeakMarker
        hold(ax,'on');
        plt.addPeakMarker(ax, R, comp, 'spherical');
        hold(ax,'off');
    end

    % "Show grids" overlays a custom lat/long net directly on the surface
    % (so the user sees grid lines hugging the pattern).  Helpers (XYZ
    % arrows, equator, zero-meridian) are always shown regardless; the
    % MATLAB native axes box stays hidden so the plot reads as a 3D
    % radiation pattern, not a cartesian plot.
    axis(ax,'off'); ax.Box = 'off';
    if isfield(ctrl,'ShowGrids') && ctrl.ShowGrids
        plt.addPatternGrid(ax, X, Y, Z);
    else
        delete(findall(ax,'Tag','PatternGrid'));
    end

    if isfield(ctrl,'viewChangedCb') && ~isempty(ctrl.viewChangedCb)
        plt.bindViewListener(ax, ctrl.viewChangedCb);
    end

    azElTarget = gobjects(0);
    if isfield(ctrl,'AzElLabel') && ~isempty(ctrl.AzElLabel)
        azElTarget = ctrl.AzElLabel;
    end
    plt.addAzElIndicator(ax, azElTarget);

    try; plt.attachDataTip(h, 'spherical', R, comp); catch; end
end
