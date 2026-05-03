function cmap = thermCmap(n)
%THERMCMAP Bichromatic blue-white-red colormap (OriginLab thermometer style).
    if nargin<1; n = 255; end
    N = n;
    cmap = uint8([N*ones(1,N), N:-1:0;  0:N-1, N:-1:0;  0:N, N*ones(1,N)].');
    cmap = double(cmap) / double(N);
end
