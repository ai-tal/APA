function addAzElIndicator(ax, target)
%ADDAZELINDICATOR Pin a live "Az / El" readout to a uilabel above a 3D axes.
%
%   addAzElIndicator(ax, target) writes the current [az el] of `ax` into
%   `target` (a uilabel positioned in a sibling grid cell, outside the
%   axes) and installs a View listener so it stays in sync as the user
%   rotates the 3D view.  Keeping the indicator OUTSIDE the axes is what
%   guarantees it never drifts with the 3D camera.
%
%   addAzElIndicator(ax) (no target) falls back to the axes title slot.
%
%   Successive calls on the same axes replace any previously installed
%   listener, so refreshing the plot never stacks callbacks.

    if nargin < 1 || ~isgraphics(ax); return; end
    if nargin < 2; target = gobjects(0); end

    % Drop any previous listener we installed.
    try
        oldL = getappdata(ax, 'AzElListener');
        if ~isempty(oldL) && isvalid(oldL); delete(oldL); end
    catch
    end

    setappdata(ax, 'AzElTarget', target);
    refresh();

    try
        L = addlistener(ax, 'View', 'PostSet', @(~,~) refresh());
        setappdata(ax, 'AzElListener', L);
    catch
    end

    function refresh()
        if ~isvalid(ax); return; end
        try
            v = get(ax,'View');
        catch
            return;
        end
        % Round to the nearest integer so the indicator never shows
        % distracting fractional digits while the user is dragging.
        txt = sprintf('Az: %d%c  El: %d%c', round(v(1)), 176, round(v(2)), 176);
        tgt = getappdata(ax, 'AzElTarget');
        if ~isempty(tgt) && all(isvalid(tgt))
            try
                tgt.Interpreter = 'none';
            catch
            end
            try
                tgt.Text = txt;
                return;
            catch
            end
        end
        try
            t = title(ax, txt, 'FontSize', 10, 'FontWeight','normal', ...
                      'Color',[0.2 0.2 0.2], 'Interpreter','none');
            set(t, 'PickableParts','none');
        catch
        end
    end
end
