function bindViewListener(ax, cb)
%BINDVIEWLISTENER Invoke cb([az, el]) whenever the 3D view of ax changes.
%  A single listener is attached per axes; subsequent calls replace any
%  previous one so repeated plot refreshes don't stack listeners.
    if nargin < 2 || isempty(cb); return; end
    if ~isgraphics(ax); return; end

    % Drop any previous listener we attached.
    try
        old = getappdata(ax, 'ViewListener');
        if ~isempty(old) && isvalid(old); delete(old); end
    catch
    end

    try
        L = addlistener(ax, 'View', 'PostSet', @(src,evt) safeCb(cb, ax));
        setappdata(ax, 'ViewListener', L);
    catch
    end
end

function safeCb(cb, ax)
    try
        v = get(ax,'View');
        if nargin(cb) >= 2 || abs(nargin(cb)) >= 2
            cb(ax, v);
        else
            cb(v);
        end
    catch
    end
end
