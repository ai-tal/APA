function plotContour(ax, R, comp, ctrl)
%PLOTCONTOUR Filled contour of a pattern component (phi on X, theta on Y).
%   Uses pcolor for richer interpolated colours; the axes box + ticks are
%   kept on top so they remain visible over the surface.  On subsequent
%   refreshes the existing pcolor surface is re-used (CData-only update)
%   so a component switch costs ~tens of ms instead of a full rebuild.

    R = plt.downsampleForRender(R);
    [G, lbl, cmap, limOv] = plt.selectComponent(R, comp);
    [lims, ticks] = plt.pickLimits(ctrl, limOv);

    [h, isNew] = plt.upsertSurface(ax, 'pcolor', R.phi, R.theta, [], G);

    if isNew
        % First-time setup of static axes properties.
        set(ax, 'YDir','reverse', 'Box','on', 'Layer','top', ...
            'XColor',[0.2 0.2 0.2], 'YColor',[0.2 0.2 0.2], 'LineWidth',0.75);
        xlabel(ax,'\phi (deg)');
        ylabel(ax,'\theta (deg)');
        title(ax, '');
        try
            ax.Interactions = dataTipInteraction;
            tb = axtoolbar(ax,{'datacursor','restoreview'});
            tb.Visible = 'off';
        catch
        end
    end

    % These are cheap each call - axes limits/ticks need to follow the
    % data extents in case the user reloaded a different grid.
    phiHi   = max(R.phi(:));
    thetaHi = max(R.theta(:));
    xlim(ax, [min(R.phi(:))   max(phiHi, 360)]);
    ylim(ax, [min(R.theta(:)) max(thetaHi, 180)]);
    xticks(ax, 0:30:max(phiHi, 360));
    yticks(ax, 0:15:max(thetaHi, 180));

    % "Show grids" controls the native cartesian grid only.
    if isfield(ctrl,'ShowGrids') && ctrl.ShowGrids
        grid(ax,'on');
    else
        grid(ax,'off');
    end

    clim(ax, lims);
    colormap(ax, cmap);
    cb = colorbar(ax);          % returns existing colorbar if one exists
    cb.Ticks = ticks;
    cb.Label.String = lbl;

    % Peak marker: cheap; redrawn each call so it tracks the active comp.
    delete(findall(ax, 'Tag','PeakMarker'));
    if isfield(ctrl,'ShowPeakMarker') && ctrl.ShowPeakMarker
        hold(ax,'on');
        plt.addPeakMarker(ax, R, comp, 'contour');
        hold(ax,'off');
    end

    % Refresh the data tip rows (their captured matrices change with comp).
    try; plt.attachDataTip(h, 'contour', R, comp); catch; end
end
