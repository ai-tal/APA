function plotFilledPolar(parentGrid, R, comp, cutType, ctrl)
%PLOTFILLEDPOLAR Balanis-style filled polar cut.
%
%   The outer curve is the selected component's 1D cut (r = gain(angle))
%   and the interior of that curve is filled with a Gouraud-shaded gradient
%   that matches the gain value at each angle (as shown in Balanis,
%   "Antenna Theory").  The plot lives on a cartesian uiaxes so we can mix
%   pcolor/patch/line primitives; polar tick rings + angular spokes are
%   added as decorations.
%
%   cutType controls which axis is swept:
%       'Phi Cut'   -> fix theta at ctrl.Phi, sweep phi on [0, 360]
%       'Theta Cut' -> fix phi at ctrl.Theta, sweep theta on [0, 360]
%                      (mirrored at phi+180 to form a great-circle cut)

    delete(allchild(parentGrid));
    try
        parentGrid.RowHeight    = {'1x'};
        parentGrid.ColumnWidth  = {'1x'};
    catch; end
    ax = uiaxes(parentGrid);
    ax.Layout.Row = 1; ax.Layout.Column = 1;

    [~, lbl, cmap, limOv] = plt.selectComponent(R, comp);
    [lims, ticks] = plt.pickLimits(ctrl, limOv);

    % Pick the cut sample angle (same defaults used elsewhere in Tab 1).
    if isfield(ctrl,'CutValue') && ~isempty(ctrl.CutValue)
        cutValue = ctrl.CutValue;
    else
        cutValue = 0;
    end

    [a_deg, gT, gR, gL] = plt.getCut(R, cutType, cutValue);

    % Use the same component as the big plots by routing selectComponent for
    % the 1D cut.  Default to the Total-gain cut when the component is not a
    % CP channel.
    switch comp
        case 'RHCP',                curve_dB = gR;
        case 'LHCP',                curve_dB = gL;
        otherwise,                  curve_dB = gT;
    end

    % Keep the radial axis monotonically positive and map it onto the
    % [0, 1] unit disk so the colorbar stays in dB.
    rmin = lims(1);
    rmax = lims(2);
    rClip = max(min(curve_dB(:), rmax), rmin);
    Rnorm = (rClip - rmin) / max(rmax - rmin, eps);

    aRad = deg2rad(a_deg(:));
    % Close the curve if it is almost a full revolution.
    if abs(mod(a_deg(end) - a_deg(1), 360)) < 1
        aRad  = [aRad; aRad(1) + 2*pi];
        Rnorm = [Rnorm; Rnorm(1)];
        curve_dB = [curve_dB(:); curve_dB(1)];
    end

    Xp = Rnorm .* cos(aRad - pi/2);  % put 0 deg at top
    Yp = Rnorm .* sin(aRad - pi/2); Yp = -Yp;  % clockwise winding

    % Build a triangular fan [center, i, i+1] with vertex colors = cut gain
    % in dB.  Gouraud shading gives the Balanis "filled cut" look.
    nP = numel(Xp);
    V  = [0 0; [Xp, Yp]];
    Cv = [rmin; curve_dB(:)];
    F  = zeros(nP-1, 3);
    for k = 1:nP-1
        F(k,:) = [1, k+1, k+2];
    end

    patch(ax, 'Faces',F, 'Vertices',V, ...
              'FaceVertexCData',Cv, 'FaceColor','interp', ...
              'EdgeColor','none');

    hold(ax,'on');

    % Outline the cut curve itself.  Store (angle, magnitude) in UserData
    % so attachDataTip can surface them in the tooltip.
    outlineH = plot(ax, Xp, Yp, 'Color',[0.15 0.15 0.15], 'LineWidth',1.2);
    outlineH.UserData.AngleDeg = rad2deg(aRad);
    outlineH.UserData.MagDb    = curve_dB(:);

    % Polar decorations: concentric gain rings labelled in dB + angular
    % spokes every 30 deg.  These are purely decorative so they are made
    % non-interactive (no tooltips on hover).  This is a Cut plot, not a
    % Full-Pattern plot, so the decoration is NOT gated on ctrl.ShowGrids.
    DEC = {'HandleVisibility','off', 'HitTest','off', 'PickableParts','none'};
    TXT = {'HitTest','off', 'PickableParts','none', 'HandleVisibility','off'};
    arc = linspace(0, 2*pi, 361);
    dbTicks = ticks;
    for tk = dbTicks
        rv = (tk - rmin)/max(rmax - rmin, eps);
        if rv <= 0 || rv > 1 + 1e-6; continue; end
        plot(ax, rv*cos(arc), rv*sin(arc), ':', ...
             'Color',[0.45 0.45 0.45], 'LineWidth',0.5, DEC{:});
        text(ax, 0, -rv, sprintf(' %g dB', tk), ...
             'Color',[0.2 0.2 0.2], 'FontSize',8, ...
             'HorizontalAlignment','left','VerticalAlignment','middle', TXT{:});
    end
    for ph = 0:30:330
        xy = [cos(deg2rad(ph)-pi/2) -sin(deg2rad(ph)-pi/2)];
        plot(ax, [0 xy(1)], [0 xy(2)], ':', ...
             'Color',[0.5 0.5 0.5], 'LineWidth',0.4, DEC{:});
        text(ax, 1.08*xy(1), 1.08*xy(2), sprintf('%d\\circ', ph), ...
             'Color',[0.1 0.1 0.1], 'HorizontalAlignment','center', ...
             'VerticalAlignment','middle', 'FontSize',8, TXT{:});
    end

    % HPBW wedge overlay - gated on the same flag as the cut plots.
    if isfield(ctrl,'ShowHPBW') && ctrl.ShowHPBW
        [bw, edges] = proc.hpbw(a_deg, gT);
        if ~isnan(bw)
            wa = linspace(deg2rad(edges(1)), deg2rad(edges(2)), 60);
            wx = [0, cos(wa-pi/2)];
            wy = [0, -sin(wa-pi/2)];
            patch(ax, wx, wy, [1 0.87 0.45], 'FaceAlpha',0.28, ...
                  'EdgeColor','none', DEC{:});
        end
    end

    hold(ax,'off');

    axis(ax,'equal');
    axis(ax, 1.18*[-1 1 -1 1]);
    % Hide the cartesian axes frame/ticks but keep the axes itself
    % visible so the title/colorbar still render.
    set(ax, 'XTick',[], 'YTick',[], ...
            'Box','off', ...
            'XColor','none', 'YColor','none');
    try; ax.Color = 'none'; catch; end

    clim(ax, lims);
    colormap(ax, cmap);
    cb = colorbar(ax); cb.Label.String = lbl; cb.Ticks = ticks;
    % Cut plots always carry a descriptive title.
    t = title(ax, titleForCut(cutType, cutValue));
    try; t.Interpreter = 'tex'; catch; end

    try; plt.attachDataTip(outlineH, 'filledpolar', R, comp, cutType); catch; end
end

function s = titleForCut(cutType, cutValue)
    if strcmpi(cutType,'Phi Cut')
        s = sprintf('Phi cut (\\theta = %g\\circ)', cutValue);
    elseif strcmpi(cutType,'Theta Cut')
        s = sprintf('Theta cut (\\phi = %g\\circ)', cutValue);
    else
        s = sprintf('%s = %g\\circ', cutType, cutValue);
    end
end
