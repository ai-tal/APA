function addPatternGrid(ax, X, Y, Z, dThetaDeg, dPhiDeg)
%ADDPATTERNGRID Overlay latitude/longitude grid lines on a 3D surface.
%
%   addPatternGrid(AX, X, Y, Z) draws dashed grid curves directly ON the
%   surface defined by X, Y, Z (each Nth x Nph).  It picks rows / columns
%   spaced ~30 deg apart in theta / phi from the surface vertex grid, and
%   plots them as 3D dashed polylines.  Because the lines come from the
%   actual surface coordinates they hug whatever shape the pattern has -
%   on a unit sphere they are great circles / parallels of latitude; on a
%   gain-deformed pattern they follow the deformed surface so the user
%   sees the lat/long net stretched onto the pattern.
%
%   addPatternGrid(AX, X, Y, Z, DTHETADEG, DPHIDEG) overrides the default
%   30 deg grid spacing.
%
%   Existing grid overlays (Tag = 'PatternGrid') are removed first so the
%   helper can be safely re-invoked on every refresh.

    if nargin < 5 || isempty(dThetaDeg); dThetaDeg = 30; end
    if nargin < 6 || isempty(dPhiDeg);   dPhiDeg   = 30; end
    if ~isgraphics(ax) || ~isvalid(ax); return; end

    % findALL (vs findobj) is required because the existing grid lines
    % are stored with HandleVisibility='off' so they don't pollute the
    % legend / object children list.
    delete(findall(ax, 'Tag', 'PatternGrid'));
    [Nth, Nph] = size(X);
    if Nth < 3 || Nph < 3; return; end

    OPTS = {'LineStyle',':', 'Color',[0.45 0.45 0.45], 'LineWidth',0.5, ...
            'HandleVisibility','off', 'HitTest','off', ...
            'PickableParts','none', 'Tag','PatternGrid'};

    hold(ax,'on');

    % Latitude lines (constant theta) at every dThetaDeg of the input grid.
    nThetaLines = max(round(180 / dThetaDeg), 3);
    iTheta      = unique(round(linspace(1, Nth, nThetaLines + 1)));
    for k = iTheta
        plot3(ax, X(k,:), Y(k,:), Z(k,:), OPTS{:});
    end

    % Longitude lines (constant phi) at every dPhiDeg.
    nPhiLines = max(round(360 / dPhiDeg), 4);
    iPhi      = unique(round(linspace(1, Nph, nPhiLines + 1)));
    for k = iPhi
        plot3(ax, X(:,k), Y(:,k), Z(:,k), OPTS{:});
    end

    hold(ax,'off');
end
