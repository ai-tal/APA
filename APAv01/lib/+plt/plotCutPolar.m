function plotCutPolar(pax, R, cutType, cutValue, showT, showRH, showLH, ctrl)
%PLOTCUTPOLAR Polar cut plot with HPBW highlighted as a thetaregion wedge.
    cla(pax,'reset');
    pax.ThetaZeroLocation = 'top';
    pax.ThetaDir          = 'clockwise';
    [a, gT, gR, gL, ~] = plt.getCut(R, cutType, cutValue);
    aRad = deg2rad(a);

    hold(pax,'on');

    % Draw HPBW wedge first so it sits underneath the curves - but only
    % when the HPBW toggle is active.
    showHPBW = isfield(ctrl,'ShowHPBW') && ctrl.ShowHPBW;
    if showHPBW
        [bw, edges] = proc.hpbw(a, gT);
        if ~isnan(bw)
            try
                h = thetaregion(pax, deg2rad(edges(1)), deg2rad(edges(2)), ...
                                'FaceColor',[1 0.87 0.45], 'FaceAlpha',0.28);
                set(h,'HandleVisibility','off');
            catch
                pk = max(gT);
                arcA = linspace(deg2rad(edges(1)), deg2rad(edges(2)), 80);
                polarplot(pax, arcA, repmat(pk-3, size(arcA)), 'LineWidth',3, ...
                          'Color',[0.9 0.5 0.1], 'HandleVisibility','off');
            end
        end
    end

    lines = gobjects(0);
    if showT;  lines(end+1) = polarplot(pax, aRad, gT, 'LineWidth',1.8, 'Color',[0   0.45 0.74], 'DisplayName','E_{Total}  '); end %#ok<AGROW>
    if showRH; lines(end+1) = polarplot(pax, aRad, gR, 'LineWidth',1.4, 'Color',[0.85 0.33 0.10], 'DisplayName','E_{RHCP}'); end %#ok<AGROW>
    if showLH; lines(end+1) = polarplot(pax, aRad, gL, 'LineWidth',1.4, 'Color',[0.47 0.67 0.19], 'DisplayName','E_{LHCP}'); end %#ok<AGROW>
    if isempty(lines)
        lines(end+1) = polarplot(pax, aRad, gT, 'LineWidth',1.8, 'DisplayName','E_{Total}'); %#ok<AGROW>
    end
    try plt.attachDataTip(lines, 'cut', R, 'Total Gain', cutType); catch; end

    title(pax, titleForCut(cutType, cutValue));
    hold(pax,'off');

    rlim(pax, [ctrl.Cmin ctrl.Cmax]);
    legend(pax,'show','Location','northeastoutside');
end

function s = titleForCut(cutType, cutValue)
    % "Phi cut (\theta = VAL°)" or "Theta cut (\phi = VAL°)"
    if strcmpi(cutType,'Phi Cut')
        s = sprintf('Phi cut (\\theta = %g\\circ)', cutValue);
    elseif strcmpi(cutType,'Theta Cut')
        s = sprintf('Theta cut (\\phi = %g\\circ)', cutValue);
    else
        s = sprintf('%s = %g\\circ', cutType, cutValue);
    end
end
