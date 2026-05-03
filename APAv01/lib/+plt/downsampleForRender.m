function Rs = downsampleForRender(R, maxNth, maxNph)
%DOWNSAMPLEFORRENDER Subsample a pattern's spherical grid for fast plotting.
%
%   Rs = downsampleForRender(R) returns a copy of the processed-pattern
%   struct R whose theta/phi axes (and ALL grid-shaped fields like
%   G_total_dB, AR_dB, Eth, Eph, ...) are decimated by integer strides so
%   neither dimension exceeds the default targets (91 in theta, 181 in
%   phi, i.e. ~16k surface vertices instead of 65k+).
%
%   Rs = downsampleForRender(R, MAXNTH, MAXNPH) lets the caller override
%   the targets.  Pass an empty/0 to keep an axis untouched.
%
%   The decimation only affects how the surface plots LOOK; it never
%   touches the original processed data, so data tables, exports, cut
%   plots and HPBW calculations stay full-resolution.
%
%   For grids already at or below the target resolution the input is
%   returned unchanged.

    if nargin < 2 || isempty(maxNth) || maxNth <= 0; maxNth = 91;  end
    if nargin < 3 || isempty(maxNph) || maxNph <= 0; maxNph = 181; end
    if isempty(R) || ~isfield(R,'theta') || ~isfield(R,'phi'); Rs = R; return; end

    Nth = numel(R.theta);
    Nph = numel(R.phi);
    sTh = max(1, ceil(Nth / maxNth));
    sPh = max(1, ceil(Nph / maxNph));
    if sTh == 1 && sPh == 1
        Rs = R; return;
    end

    iTh = 1:sTh:Nth;
    if iTh(end) ~= Nth; iTh = [iTh, Nth]; end           % keep last sample
    iPh = 1:sPh:Nph;
    if iPh(end) ~= Nph; iPh = [iPh, Nph]; end

    Rs = R;
    Rs.theta = R.theta(iTh);
    Rs.phi   = R.phi(iPh);

    flds = fieldnames(R);
    for k = 1:numel(flds)
        f = flds{k};
        v = R.(f);
        if ~isnumeric(v) || ~ismatrix(v); continue; end
        if isequal(size(v), [Nth, Nph])
            Rs.(f) = v(iTh, iPh);
        end
    end
end
