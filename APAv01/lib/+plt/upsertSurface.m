function [h, isNew] = upsertSurface(ax, kind, X, Y, Z, C)
%UPSERTSURFACE Reuse an existing primary surface on AX or create a new one.
%
%   [H, ISNEW] = upsertSurface(AX, KIND, X, Y, Z, C) returns the primary
%   surface handle hosted by AX.  KIND is 'pcolor' | 'surf' | 'sphere'.
%   The existing handle (cached in AX.UserData.PrimarySurf) is reused if
%   it is still valid AND its grid layout matches the new data; only the
%   X/Y/Z/CData fields are then updated.  Otherwise the axes is reset and
%   a new surface is created.
%
%   This is the heart of the "no full re-create on refresh" optimisation:
%   creating a fresh pcolor / surf object on a 65k-vertex grid in a
%   uifigure costs ~1-3 s; mutating XData/YData/ZData/CData costs tens of
%   ms.  Auxiliary decorations (helpers, peak markers, datatip rows) are
%   handled by the calling plot function.
%
%   For 'pcolor' pass an empty Z; for 'surf' / 'sphere' pass the full
%   coordinate triple.

    h = [];
    if isfield(ax.UserData, 'PrimarySurf')
        h = ax.UserData.PrimarySurf;
    end

    canReuse = ~isempty(h) && isgraphics(h) && isvalid(h) && ...
               isequal(size(h.CData), size(C));

    if canReuse
        isNew = false;
        try
            if strcmp(kind,'pcolor')
                h.XData = X;
                h.YData = Y;
                h.CData = C;
            else
                h.XData = X;
                h.YData = Y;
                h.ZData = Z;
                h.CData = C;
            end
        catch
            % Mismatched class - fall through to recreation.
            canReuse = false;
        end
    end
    if canReuse; return; end

    isNew = true;
    cla(ax, 'reset');
    switch kind
        case 'pcolor'
            h = pcolor(ax, X, Y, C);
            set(h, 'FaceColor','interp', 'LineStyle','none');
        case {'surf','sphere'}
            h = surf(ax, X, Y, Z, C, 'EdgeColor','none');
        otherwise
            error('upsertSurface:kind','Unknown surface kind: %s', kind);
    end
    ax.UserData.PrimarySurf = h;
end
