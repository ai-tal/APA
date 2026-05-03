function plotCoverage(ax, thr, cov, names, ctrl)
%PLOTCOVERAGE Line plot of coverage % vs threshold for one or more patterns.
%
%   plotCoverage(AX, THR, COV, NAMES) plots each column of COV vs THR.
%   plotCoverage(..., CTRL) honours plot-control fields:
%       ctrl.gridOn    - true/false    (default true)
%       ctrl.legendOn  - true/false    (default true)
%       ctrl.lineWidth - numeric       (default 1.6)

    if nargin<5 || isempty(ctrl); ctrl = struct(); end
    if ~isfield(ctrl,'gridOn');    ctrl.gridOn = true;    end
    if ~isfield(ctrl,'legendOn');  ctrl.legendOn = true;  end
    if ~isfield(ctrl,'lineWidth'); ctrl.lineWidth = 1.6;  end

    cla(ax,'reset');
    hold(ax,'on');
    for k = 1:size(cov,2)
        plot(ax, thr, cov(:,k), 'LineWidth', ctrl.lineWidth, ...
             'DisplayName', escName(names{k}));
    end
    hold(ax,'off');
    if ctrl.gridOn; grid(ax,'on'); else; grid(ax,'off'); end
    xlabel(ax,'Threshold (dB)');
    ylabel(ax,'Coverage (%)');
    ylim(ax,[0 101]);
    if ctrl.legendOn
        legend(ax,'show','Location','southwest','Interpreter','none');
    else
        legend(ax,'off');
    end
    title(ax,'Coverage vs threshold');
end

function s = escName(s)
    s = strrep(s,'_','\_');
end
