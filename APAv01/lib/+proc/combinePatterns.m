function Q = combinePatterns(patterns, method, opts)
%COMBINEPATTERNS Combine N patterns into a single canonical pattern.
%
%   Q = combinePatterns(patterns, method, opts)
%
%   patterns : cell array of canonical pattern structs.
%   method   : 'coherent' | 'incoherent' | 'envelope' | 'masked'
%   opts     : struct with fields
%       weights      complex vector (one per pattern, default all 1+0j)
%       masks        N x 4 matrix [thMin thMax phMin phMax] (deg) for 'masked'
%       maskedJoin   'max' (default) or 'coherent' inside masks
%
%   All patterns are first resampled to a common (theta, phi) grid, taken as
%   the densest among the inputs.

    n = numel(patterns);
    if n==0; error('combinePatterns:empty','No patterns supplied.'); end

    if nargin<3; opts = struct; end
    if ~isfield(opts,'weights') || isempty(opts.weights)
        opts.weights = ones(n,1);
    end
    if ~isfield(opts,'maskedJoin'); opts.maskedJoin = 'max'; end

    % Choose densest grid.
    maxNth = 0; maxNph = 0;
    chosen = 1;
    for k = 1:n
        if numel(patterns{k}.theta)*numel(patterns{k}.phi) > maxNth*maxNph
            maxNth = numel(patterns{k}.theta);
            maxNph = numel(patterns{k}.phi);
            chosen = k;
        end
    end
    theta = patterns{chosen}.theta;
    phi   = patterns{chosen}.phi;

    Eth = zeros(numel(theta), numel(phi));
    Eph = zeros(numel(theta), numel(phi));

    switch lower(method)
        case 'coherent'
            for k = 1:n
                Pk = proc.interpToCommonGrid(patterns{k}, theta, phi);
                Eth = Eth + opts.weights(k) * Pk.Eth;
                Eph = Eph + opts.weights(k) * Pk.Eph;
            end

        case 'incoherent'
            EthMag2 = zeros(size(Eth));
            EphMag2 = zeros(size(Eph));
            for k = 1:n
                Pk = proc.interpToCommonGrid(patterns{k}, theta, phi);
                w  = abs(opts.weights(k))^2;
                EthMag2 = EthMag2 + w*abs(Pk.Eth).^2;
                EphMag2 = EphMag2 + w*abs(Pk.Eph).^2;
            end
            Eth = sqrt(EthMag2);
            Eph = sqrt(EphMag2);

        case 'envelope'
            best = -inf(size(Eth));
            for k = 1:n
                Pk = proc.interpToCommonGrid(patterns{k}, theta, phi);
                Gk = abs(opts.weights(k))^2 * (abs(Pk.Eth).^2 + abs(Pk.Eph).^2);
                better = Gk > best;
                best(better) = Gk(better);
                Eth(better) = opts.weights(k) * Pk.Eth(better);
                Eph(better) = opts.weights(k) * Pk.Eph(better);
            end

        case 'masked'
            if ~isfield(opts,'masks') || size(opts.masks,1) ~= n
                error('combinePatterns:masks','opts.masks must be N-by-4.');
            end
            [Tg, Pg] = ndgrid(theta, phi);
            % Resolve any "complement" masks (rows containing NaN) into
            % the explicit set of grid points not yet claimed by another
            % row.  This lets the GUI define an arbitrary leftover
            % region for the LAST pattern without enumerating boxes.
            isCompRow = any(isnan(opts.masks), 2);
            maskMaps  = false(numel(theta), numel(phi), n);
            for k = 1:n
                if ~isCompRow(k)
                    maskMaps(:,:,k) = inMask(Tg, Pg, opts.masks(k,:));
                end
            end
            if any(isCompRow)
                claimed = any(maskMaps(:,:,~isCompRow), 3);
                comp    = ~claimed;
                idxComp = find(isCompRow);
                % Split the leftover evenly across multiple complement
                % rows (only the last row is flagged in normal usage).
                if numel(idxComp) == 1
                    maskMaps(:,:,idxComp) = comp;
                else
                    for k = idxComp(:)'
                        maskMaps(:,:,k) = comp;
                    end
                end
            end
            switch lower(opts.maskedJoin)
                case 'coherent'
                    for k = 1:n
                        Pk = proc.interpToCommonGrid(patterns{k}, theta, phi);
                        m  = maskMaps(:,:,k);
                        Eth(m) = Eth(m) + opts.weights(k)*Pk.Eth(m);
                        Eph(m) = Eph(m) + opts.weights(k)*Pk.Eph(m);
                    end
                otherwise   % 'max'
                    best = -inf(size(Eth));
                    for k = 1:n
                        Pk = proc.interpToCommonGrid(patterns{k}, theta, phi);
                        Gk = abs(opts.weights(k))^2 * (abs(Pk.Eth).^2 + abs(Pk.Eph).^2);
                        m  = maskMaps(:,:,k);
                        better = m & (Gk > best);
                        best(better) = Gk(better);
                        Eth(better)  = opts.weights(k)*Pk.Eth(better);
                        Eph(better)  = opts.weights(k)*Pk.Eph(better);
                    end
            end

        otherwise
            error('combinePatterns:method','Unknown method %s',method);
    end

    Q.theta = theta;
    Q.phi   = phi;
    Q.Eth   = Eth;
    Q.Eph   = Eph;
    Q.meta  = struct('source','combinePatterns','file','', ...
                     'name',sprintf('combined_%s_%dpat',method,n), ...
                     'format','combined','freq_Hz',NaN,'R_ref_m',1, ...
                     'maxGain_dB',NaN,'normalized',false, ...
                     'method',method,'nInputs',n);
end

function m = inMask(Tg, Pg, mask4)
    m = (Tg >= mask4(1)) & (Tg <= mask4(2)) & ...
        (Pg >= mask4(3)) & (Pg <= mask4(4));
end
