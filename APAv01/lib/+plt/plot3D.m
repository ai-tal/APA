function plot3D(ax, R, comp, ctrl)
%PLOT3D Radial-deformed 3D pattern (radius proportional to gain above floor),
%with XYZ body-axis helpers and principal-plane circles.
%   Reuses an existing surf handle on subsequent refreshes for fast updates.

    R = plt.downsampleForRender(R);
    [G, lbl, cmap, limOv] = plt.selectComponent(R, comp);
    [lims, ticks] = plt.pickLimits(ctrl, limOv);

    floorDB = lims(1);
    Gclip = max(G - floorDB, 0);
    rmax  = max(Gclip(:) + eps);
    Gn    = Gclip / rmax;

    [Tg, Pg] = ndgrid(deg2rad(R.theta), deg2rad(R.phi));
    X = Gn .* sin(Tg).*cos(Pg);
    Y = Gn .* sin(Tg).*sin(Pg);
    Z = Gn .* cos(Tg);

    [h, isNew] = plt.upsertSurface(ax, 'surf', X, Y, Z, G);

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
        plt.addPeakMarker(ax, R, comp, '3d');
        hold(ax,'off');
    end

    % "Show grids" overlays a custom lat/long net directly on the
    % deformed pattern surface so the grid hugs the pattern shape.
    % Helpers (XYZ arrows, equator, zero-meridian) are always shown.
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

    try plt.attachDataTip(h, '3d', R, comp); catch; end
end
