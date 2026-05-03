function plotCutRect(ax, R, cutType, cutValue, showT, showRH, showLH, ctrl)
%PLOTCUTRECT Rectangular cut plot with HPBW shading (xregion overlay).
    cla(ax,'reset');
    [ang, gT, gR, gL, lbl] = plt.getCut(R, cutType, cutValue);

    % HPBW is only drawn when the caller explicitly asks for it via the
    % HPBW state-button on the UI (ctrl.ShowHPBW).
    showHPBW = isfield(ctrl,'ShowHPBW') && ctrl.ShowHPBW;
    if showHPBW
        [bw, edges] = proc.hpbw(ang, gT);
        if ~isnan(bw)
            xL = edges(1); xR = edges(2);
            try
                h = xregion(ax, xL, xR, 'FaceColor',[1 0.87 0.45], 'FaceAlpha',0.28);
                set(h, 'HandleVisibility','off');
            catch
                ylo = ctrl.Cmin; yhi = ctrl.Cmax;
                patch(ax, [xL xR xR xL], [ylo ylo yhi yhi], [1 0.92 0.7], ...
                      'EdgeColor','none','FaceAlpha',0.30, 'HandleVisibility','off');
            end
            [pk, ipk] = max(gT);
            yline(ax, pk-3, '--', 'Color',[0.5 0.5 0.5], 'HandleVisibility','off');
            xline(ax, ang(ipk), ':', 'Color',[0.4 0.4 0.4], 'HandleVisibility','off');
        end
    end

    hold(ax,'on');
    lines = gobjects(0);
    if showT;  lines(end+1) = plot(ax, ang, gT, 'LineWidth',1.8, 'Color',[0   0.45 0.74], 'DisplayName','E_{Total}  '); end %#ok<AGROW>
    if showRH; lines(end+1) = plot(ax, ang, gR, 'LineWidth',1.4, 'Color',[0.85 0.33 0.10], 'DisplayName','E_{RHCP}'); end %#ok<AGROW>
    if showLH; lines(end+1) = plot(ax, ang, gL, 'LineWidth',1.4, 'Color',[0.47 0.67 0.19], 'DisplayName','E_{LHCP}'); end %#ok<AGROW>
    if isempty(lines)
        lines(end+1) = plot(ax, ang, gT, 'LineWidth',1.8, 'DisplayName','E_{Total}'); %#ok<AGROW>
    end
    for lh = lines(:)'
        try plt.attachDataTip(lh, 'cut', R, 'Total Gain', cutType); catch; end
    end
    hold(ax,'off');

    title(ax, titleForCut(cutType, cutValue));
    xlabel(ax, lbl); ylabel(ax,'Gain (dBi)');
    set(ax, 'YLim',[ctrl.Cmin ctrl.Cmax], 'XLim',[min(ang) max(ang)], 'XTick',min(ang):30:max(ang));

    grid(ax,'on');
    legend(ax,'show','Location','best');
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
