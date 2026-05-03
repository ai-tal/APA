function enableRotate3D(ax)
%ENABLEROTATE3D Activate rotate-by-default on a uiaxes (3D plot).
%   Emulates the behaviour of Antenna Toolbox helpers like patternCustom,
%   where the user can drag the 3D view without first toggling the rotate
%   button on the axes toolbar.  Works on uiaxes in App Designer apps.

    if nargin<1 || isempty(ax) || ~isvalid(ax); return; end

    % 1) Make rotate the FIRST (default) interaction so a left-click drag
    %    rotates immediately - while still keeping zoom, pan and data
    %    tips enabled so users have the full uifigure interaction set.
    try
        ax.Interactions = [rotateInteraction zoomInteraction panInteraction dataTipInteraction];
    catch
        try
            enableDefaultInteractivity(ax);
        catch; end
    end

    % 2) Hide the axes toolbar - users can just drag directly.
    try
        tb = axtoolbar(ax,{'restoreview','datacursor'});
        tb.Visible = 'off';
    catch; end

    % (No rotate3d fallback - it hijacks clicks and breaks data tips.)
end
