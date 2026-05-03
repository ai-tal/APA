function addPeakMarker(ax, R, comp, plotType)
%ADDPEAKMARKER Place a small crosshair/marker at the peak of the selected
%component on the given plot type.
%   All marker handles are stored with Tag='PeakMarker' (and no
%   HandleVisibility hiding) so callers can reliably remove them via
%   `delete(findall(ax, 'Tag', 'PeakMarker'))` whenever the user un-checks
%   "Show peak marker".

    if nargin < 4; plotType = 'contour'; end
    try
        G = plt.selectComponent(R, comp);
    catch
        G = R.G_total_dB;
    end
    [~, idx] = max(G(:));
    [it, ip] = ind2sub(size(G), idx);
    th = R.theta(it); ph = R.phi(ip);

    OPTS = {'Color',[0.9 0.15 0.15], 'HandleVisibility','off', 'Tag','PeakMarker'};

    switch lower(plotType)
        case 'contour'
            % X = phi, Y = theta.
            plot(ax, ph, th, '+', 'MarkerSize',12, 'LineWidth',1.4, OPTS{:});
            plot(ax, ph, th, 'o', 'MarkerSize',6,  'LineWidth',1.2, ...
                 'MarkerEdgeColor',[0.9 0.15 0.15], 'HandleVisibility','off', 'Tag','PeakMarker');
        case 'circular'
            % radius = theta, phi=0 at top, clockwise -> (sin, cos)
            x = th*sind(ph); y = th*cosd(ph);
            plot(ax, x, y, '+', 'MarkerSize',12, 'LineWidth',1.4, OPTS{:});
            plot(ax, x, y, 'o', 'MarkerSize',6,  'LineWidth',1.2, ...
                 'MarkerEdgeColor',[0.9 0.15 0.15], 'HandleVisibility','off', 'Tag','PeakMarker');
        case 'spherical'
            X = sind(th)*cosd(ph); Y = sind(th)*sind(ph); Z = cosd(th);
            plot3(ax, X, Y, Z, '+', 'MarkerSize',14, 'LineWidth',1.8, OPTS{:});
        case '3d'
            % The 3D surface is normalised so the peak sits at r ~= 1.
            r = 1.05;
            X = r*sind(th)*cosd(ph); Y = r*sind(th)*sind(ph); Z = r*cosd(th);
            plot3(ax, X, Y, Z, '+', 'MarkerSize',14, 'LineWidth',1.8, OPTS{:});
    end
end
