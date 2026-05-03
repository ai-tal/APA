function Q = combinePatterns(patterns, mode, opts)
%COMBINEPATTERNS Combine multiple patterns on the same (theta,phi) grid.
%   Q = proc.combinePatterns({P1,P2,...}, 'coherent', opts)
%       opts.weights column vector, length = numel(patterns)
%   Q = proc.combinePatterns({P1,...,PN}, 'masked', opts)
%       opts.thetaBands, opts.phiBands — (N-1)x2 if opts.useAllRows is false (remainder = pattern N);
%       or Nx2 if opts.useAllRows is true (explicit band per pattern; first match wins).

    if nargin < 3
        opts = struct;
    end
    assert(iscell(patterns) && ~isempty(patterns), ...
        'combinePatterns: patterns must be a non-empty cell array.');

    switch lower(mode)
        case 'coherent'
            w = opts.weights(:);
            assert(numel(w) == numel(patterns), ...
                'combinePatterns: weights length must match pattern count.');
            P0 = patterns{1};
            sz = size(P0.Eth);
            Eth = zeros(sz);
            Eph = zeros(sz);
            for k = 1:numel(patterns)
                Pk = patterns{k};
                assert(isequal(size(Pk.Eth), sz), ...
                    'combinePatterns: all patterns must share the same grid size.');
                Eth = Eth + w(k) .* Pk.Eth;
                Eph = Eph + w(k) .* Pk.Eph;
            end
            Q = P0;
            Q.Eth = Eth;
            Q.Eph = Eph;

        case 'masked'
            N = numel(patterns);
            assert(N >= 2, 'combinePatterns:masked', 'Need at least two patterns.');
            assert(isfield(opts, 'thetaBands') && isfield(opts, 'phiBands'), ...
                'combinePatterns:masked', 'opts.thetaBands and opts.phiBands are required.');
            tb = opts.thetaBands;
            pb = opts.phiBands;
            useAll = isfield(opts, 'useAllRows') && opts.useAllRows;
            if useAll
                assert(isequal(size(tb), [N, 2]) && isequal(size(pb), [N, 2]), ...
                    'combinePatterns:masked', 'With useAllRows, bands must be %dx2.', N);
            else
                assert(isequal(size(tb), [N - 1, 2]) && isequal(size(pb), [N - 1, 2]), ...
                    'combinePatterns:masked', 'Band arrays must be (%d-1)x2.', N);
            end
            P0 = patterns{1};
            sz = size(P0.Eth);
            for k = 1:N
                assert(isequal(size(patterns{k}.Eth), sz), ...
                    'combinePatterns: all patterns must share the same grid size.');
            end
            Eth = zeros(sz);
            Eph = zeros(sz);
            Th = P0.theta;
            Ph = P0.phi;
            if useAll
                for ii = 1:numel(Eth)
                    t = Th(ii);
                    pm = mod(Ph(ii), 360);
                    pid = N;
                    for k = 1:N
                        if t >= tb(k, 1) && t <= tb(k, 2)
                            pk = pb(k, :);
                            if pk(1) <= pk(2)
                                inPhi = pm >= pk(1) && pm <= pk(2);
                            else
                                inPhi = pm >= pk(1) || pm <= pk(2);
                            end
                            if inPhi
                                pid = k;
                                break;
                            end
                        end
                    end
                    Eth(ii) = patterns{pid}.Eth(ii);
                    Eph(ii) = patterns{pid}.Eph(ii);
                end
            else
                for ii = 1:numel(Eth)
                    t = Th(ii);
                    pm = mod(Ph(ii), 360);
                    pid = N;
                    for k = 1:(N - 1)
                        if t >= tb(k, 1) && t <= tb(k, 2)
                            pk = pb(k, :);
                            if pk(1) <= pk(2)
                                inPhi = pm >= pk(1) && pm <= pk(2);
                            else
                                inPhi = pm >= pk(1) || pm <= pk(2);
                            end
                            if inPhi
                                pid = k;
                                break;
                            end
                        end
                    end
                    Eth(ii) = patterns{pid}.Eth(ii);
                    Eph(ii) = patterns{pid}.Eph(ii);
                end
            end
            Q = P0;
            Q.Eth = Eth;
            Q.Eph = Eph;

        otherwise
            error('proc:combinePatterns:Mode', 'Unknown mode "%s".', mode);
    end
end
