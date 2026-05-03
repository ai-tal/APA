function [dir, scores] = detectBoresight(P, halfAngleDeg)
%DETECTBORESIGHT Estimate the dominant boresight orientation of a pattern.
%
%   DIR = detectBoresight(P) returns one of '+X','-X','+Y','-Y','+Z','-Z'
%   identifying the principal-axis direction the pattern radiates the most
%   power into.
%
%   The detector projects a 45 deg HALF-CONE (i.e. a 90 deg total cone /
%   "umbrella") around each of the six cardinal directions and computes
%   the SOLID-ANGLE-WEIGHTED MEAN POWER inside that cone:
%
%       score(axis) = (sum_(theta,phi within cone) (|Eth|^2+|Eph|^2) sin(theta))
%                     / (sum_(theta,phi within cone) sin(theta))
%
%   The candidate direction with the largest mean power wins.  Because we
%   integrate over a 90 deg cone the metric is robust to off-axis spikes,
%   small platform-induced beam tilt (a few degrees), and pattern noise:
%   a single sharp side-lobe cannot push the score because its solid-angle
%   contribution is tiny relative to the cone.
%
%   DIR = detectBoresight(P, HALFANGLEDEG) overrides the default 45 deg.
%   [DIR, SCORES] = detectBoresight(...) also returns the 1x6 score
%   vector in the order {+X, -X, +Y, -Y, +Z, -Z}.

    if nargin < 2 || isempty(halfAngleDeg); halfAngleDeg = 45; end
    if isempty(P) || ~isfield(P,'theta') || ~isfield(P,'phi')
        dir = '+Z'; scores = zeros(1,6); return;
    end
    cosThr = cosd(halfAngleDeg);

    % Sample directions on the spherical grid.
    [Tg, Pg] = ndgrid(deg2rad(P.theta(:)), deg2rad(P.phi(:)));
    sx = sin(Tg).*cos(Pg);
    sy = sin(Tg).*sin(Pg);
    sz = cos(Tg);

    Gpow = abs(P.Eth).^2 + abs(P.Eph).^2;     % linear power proxy
    dA   = sin(Tg);                            % solid-angle weight

    candDir = {'+X','-X','+Y','-Y','+Z','-Z'};
    candVec = [ 1  0  0
               -1  0  0
                0  1  0
                0 -1  0
                0  0  1
                0  0 -1];

    scores = -inf(1,6);
    for k = 1:6
        a = candVec(k,:);
        cosA = a(1)*sx + a(2)*sy + a(3)*sz;
        mask = cosA >= cosThr;
        Wsum = sum(dA(mask));
        if Wsum > 0
            scores(k) = sum(Gpow(mask) .* dA(mask)) / Wsum;
        end
    end

    [~, idx] = max(scores);
    dir = candDir{idx};
end
