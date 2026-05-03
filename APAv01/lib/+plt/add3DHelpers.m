function add3DHelpers(ax, radius)
%ADD3DHELPERS Overlay XYZ body axes, equator and zero-meridian on a 3D plot.
%   All helper graphics are marked non-interactive so they never surface
%   their own (X,Y,Z) tooltip when the user hovers the plot.  The
%   principal-plane circles are drawn slightly OUTSIDE the given radius
%   so they don't fuse with the pattern surface itself.

    if nargin<2 || isempty(radius); radius = 1; end
    rAx   = radius * 1.25;              % XYZ axis arrows (longest)
    rCirc = radius * 1.08;              % equator / zero-meridian circles
    hold(ax,'on');

    OPTS = {'HandleVisibility','off', 'HitTest','off', 'PickableParts','none'};
    TXTOPTS = {'HitTest','off', 'PickableParts','none', 'HandleVisibility','off'};

    % Principal axes.
    plot3(ax,[-rAx rAx],[0 0],[0 0], 'Color',[0.9 0.1 0.1], 'LineWidth',1.0, OPTS{:});
    plot3(ax,[0 0],[-rAx rAx],[0 0], 'Color',[0.1 0.6 0.1], 'LineWidth',1.0, OPTS{:});
    plot3(ax,[0 0],[0 0],[-rAx rAx], 'Color',[0.1 0.1 0.9], 'LineWidth',1.0, OPTS{:});
    text(ax, rAx, 0, 0, ' +X', 'Color',[0.7 0 0], 'FontWeight','bold', TXTOPTS{:});
    text(ax, 0, rAx, 0, ' +Y', 'Color',[0 0.5 0], 'FontWeight','bold', TXTOPTS{:});
    text(ax, 0, 0, rAx, ' +Z', 'Color',[0 0 0.7], 'FontWeight','bold', TXTOPTS{:});

    t = linspace(0,2*pi,180);
    c = cos(t); s = sin(t); z = zeros(size(t));
    % Equator (XY-plane) and zero-meridian circles drawn slightly larger
    % than the sphere radius so they sit clearly outside the data surface.
    plot3(ax, rCirc*c, rCirc*s, z,         ':', 'Color',[0.3 0.3 0.3], OPTS{:});
    plot3(ax, rCirc*c, z,       rCirc*s,   ':', 'Color',[0.3 0.3 0.3], OPTS{:});
    plot3(ax, z,       rCirc*c, rCirc*s,   ':', 'Color',[0.3 0.3 0.3], OPTS{:});
    hold(ax,'off');
end
