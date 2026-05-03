function attachDataTip(h, plotType, R, comp, cutType)
%ATTACHDATATIP Install a custom (theta, phi, magnitude) data tip on a plot
%handle.
%
%  plotType : 'contour' | 'circular' | 'spherical' | '3d' | 'filledpolar' | 'cut'
%  R        : processed-pattern struct (with theta, phi, G_*_dB, AR_dB)
%  comp     : active component name driving the magnitude/unit
%  cutType  : (cuts only) 'Phi Cut' or 'Theta Cut' - selects theta/phi as angle
%
%  The magnitude unit is 'dB' for Axial Ratio and 'dBi' otherwise.
%
%  Implementation notes:
%    Earlier revisions force-bootstrapped the DataTipTemplate by creating
%    and immediately deleting a throw-away datatip.  In some uifigure
%    builds that workaround pops a stray empty figure window every time
%    a plot refreshes (e.g. after a rotation, component switch, or
%    colorbar-limits change).  We rely on MATLAB's automatic
%    DataTipTemplate creation instead and assign the row vector in a
%    single shot - that is enough to populate the template on every
%    surf / pcolor / line / patch handle in supported releases.

    if nargin < 4 || isempty(comp);    comp    = 'Total Gain'; end
    if nargin < 5 || isempty(cutType); cutType = '';           end
    if isempty(h) || ~all(isvalid(h)); return; end

    unit = ' dBi';
    if strcmpi(comp,'Axial Ratio'); unit = ' dB'; end

    % Make sure the hosting axes keeps data-tip interaction alive so the
    % tooltip appears on hover/click.
    try
        ax = ancestor(h(1), 'axes');
        if isempty(ax); ax = ancestor(h(1), 'polaraxes'); end
        if ~isempty(ax) && isvalid(ax)
            ix = ax.Interactions;
            hasDT = false;
            for kk = 1:numel(ix)
                if isa(ix(kk), 'matlab.graphics.interaction.interactions.DataTipInteraction')
                    hasDT = true; break;
                end
            end
            if ~hasDT
                ax.Interactions = [ix dataTipInteraction];
            end
        end
    catch
    end

    switch lower(plotType)
        case {'contour','circular','spherical','3d'}
            try
                G = plt.selectComponent(R, comp);
            catch
                G = R.G_total_dB;
            end
            [Tm, Pm] = ndgrid(R.theta(:), R.phi(:));
            for k = 1:numel(h)
                addSurfTip(h(k), Tm, Pm, G, unit);
            end

        case 'filledpolar'
            addFilledPolarTip(h, unit, cutType);

        case 'cut'
            % Line object(s): cartesian (XData/YData) or polar
            % (ThetaData[rad] / RData).  Detect and use the right data
            % source so the tooltip shows the actual numbers.
            if strcmpi(cutType,'Phi Cut')
                xName = '\phi';
            elseif strcmpi(cutType,'Theta Cut')
                xName = '\theta';
            else
                xName = 'Angle';
            end
            for k = 1:numel(h)
                addCutTip(h(k), xName, unit);
            end
    end
end

function addSurfTip(h, Tm, Pm, G, unit)
    if ~isgraphics(h); return; end
    % Some pcolor / surf instances on uifigures don't expose
    % DataTipTemplate until a real datatip has been instantiated once.
    % Bootstrap it ONCE per handle (cached via setappdata), so the
    % cost is paid on first creation only.  We tolerate the throw-away
    % datatip because we've eliminated the other figure-leak source
    % (the bogus shading(ax,'interp') call in plotCircular).
    if isempty(getappdata(h, 'DTBootstrapped'))
        try
            dt = datatip(h, 'DataIndex', 1);
            delete(dt);
        catch
            try; dt = datatip(h); delete(dt); catch; end
        end
        setappdata(h, 'DTBootstrapped', true);
    end
    try
        r1 = dataTipTextRow('\theta', Tm, '%g\\circ');
        r2 = dataTipTextRow('\phi',   Pm, '%g\\circ');
        r3 = dataTipTextRow('Mag',    G,  ['%.2f' unit]);
        h.DataTipTemplate.DataTipRows = [r1; r2; r3];
    catch
    end
end

function addFilledPolarTip(h, unit, cutType)
    if isempty(h); return; end
    angLbl = '\theta';
    if strcmpi(cutType,'Phi Cut'); angLbl = '\phi'; end
    for k = 1:numel(h)
        if ~isgraphics(h(k)); continue; end
        if isempty(getappdata(h(k), 'DTBootstrapped'))
            try; dt = datatip(h(k), 'DataIndex', 1); delete(dt); catch; end
            setappdata(h(k), 'DTBootstrapped', true);
        end
        try
            r1 = dataTipTextRow(angLbl, h(k).UserData.AngleDeg, '%g\\circ');
            r2 = dataTipTextRow('Mag',  h(k).UserData.MagDb,    ['%.2f' unit]);
            h(k).DataTipTemplate.DataTipRows = [r1; r2];
        catch
        end
    end
end

function addCutTip(h, xName, unit)
    if ~isgraphics(h); return; end
    if isempty(getappdata(h, 'DTBootstrapped'))
        try; dt = datatip(h, 'DataIndex', 1); delete(dt); catch; end
        setappdata(h, 'DTBootstrapped', true);
    end
    try
        if isprop(h, 'ThetaData')
            angDeg = rad2deg(h.ThetaData);
            r1 = dataTipTextRow(xName, angDeg,  '%g\\circ');
            r2 = dataTipTextRow('Mag', h.RData, ['%.2f' unit]);
        else
            r1 = dataTipTextRow(xName, 'XData', '%g\\circ');
            r2 = dataTipTextRow('Mag', 'YData', ['%.2f' unit]);
        end
        h.DataTipTemplate.DataTipRows = [r1; r2];
    catch
    end
end
