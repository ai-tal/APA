function plotCircular(ax, R, comp, ctrl)
%PLOTCIRCULAR Azimuthal projection of the full pattern: radius = theta (deg),
%angle = phi. Theta=0 (boresight) is at the center, theta=180 at the outer
%edge.  Decorated with concentric theta rings and radial phi spokes.
%   On subsequent refreshes the existing pcolor surface is reused so a
%   component / colormap change costs ~ms instead of a full rebuild.

    R = plt.downsampleForRender(R);
    [G, lbl, cmap, limOv] = plt.selectComponent(R, comp);
    [lims, ticks] = plt.pickLimits(ctrl, limOv);

    theta = R.theta(:);
    phi   = R.phi(:);
    [Tg, Pg] = ndgrid(theta, deg2rad(phi));
    % Phi = 0 at the TOP, increasing clockwise (standard antenna polar
    % convention).  Mapping: x = theta*sin(phi), y = theta*cos(phi).
    X = Tg .* sin(Pg);
    Y = Tg .* cos(Pg);

    % NOTE: do NOT call shading(ax,'interp') here.  pcolor handles
    % already get FaceColor='interp' inside upsertSurface, and shading()
    % on a uiaxes spawns a stray classic figure on every refresh after
    % the first one (it falls through to gcf when no figure is current).
    [h, isNew] = plt.upsertSurface(ax, 'pcolor', X, Y, [], G);

    if isNew
        % First-time decorations and styling.
        axis(ax,'equal'); axis(ax,'tight');
        rOut = max(theta);
        hold(ax,'on');
        ringVals = 30:30:max(theta);
        phiArc   = linspace(0, 2*pi, 361);
        for rv = ringVals
            plot(ax, rv*cos(phiArc), rv*sin(phiArc), ':', 'Color',[0.4 0.4 0.4], 'LineWidth',0.6, ...
                'HandleVisibility','off', 'HitTest','off', 'PickableParts','none', 'Tag','CirGrid');
            text(ax, 0, rv, sprintf(' %d\\circ', rv), 'Color',[0.2 0.2 0.2], 'FontSize',8, ...
                'HitTest','off','PickableParts','none','HandleVisibility','off', 'Tag','CirGrid');
        end
        for ph = 0:30:330
            xy = [sind(ph) cosd(ph)];
            plot(ax, [0 rOut*xy(1)], [0 rOut*xy(2)], ':', 'Color',[0.4 0.4 0.4], 'LineWidth',0.5, ...
                'HandleVisibility','off', 'HitTest','off', 'PickableParts','none', 'Tag','CirGrid');
            text(ax, 1.05*rOut*xy(1), 1.05*rOut*xy(2), ...
                 sprintf('\\phi=%d\\circ', ph), 'Color',[0.15 0.15 0.15], 'HorizontalAlignment','center','FontSize',8, ...
                'HitTest','off','PickableParts','none','HandleVisibility','off', 'Tag','CirGrid');
        end
        hold(ax,'off');
        axis(ax, 1.15*rOut*[-1 1 -1 1]);
        set(ax, 'XTick',[], 'YTick',[], 'Box','off', 'XColor','none', 'YColor','none');
        try ax.Color = 'none'; catch; end
        title(ax,'');
        try
            ax.Interactions = dataTipInteraction;
            tb = axtoolbar(ax,{'datacursor','restoreview'});
            tb.Visible = 'off';
        catch
        end
    end

    clim(ax, lims);
    colormap(ax, cmap);
    cb = colorbar(ax); cb.Label.String = lbl; cb.Ticks = ticks;

    % Peak marker is recreated each call so it tracks the active component.
    delete(findall(ax, 'Tag','PeakMarker'));
    if isfield(ctrl,'ShowPeakMarker') && ctrl.ShowPeakMarker
        hold(ax,'on');
        plt.addPeakMarker(ax, R, comp, 'circular');
        hold(ax,'off');
    end

    try; plt.attachDataTip(h, 'circular', R, comp); catch; end
end
