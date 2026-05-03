function lock3DCameraBox(ax, halfBox)
%LOCK3DCAMERABOX Force a 3D axes to a fixed [-halfBox, +halfBox] cube.
%
%   lock3DCameraBox(AX, HALFBOX) makes the axes display a symmetric cube
%   of half-side HALFBOX (default 1.3) with a 1:1:1 data aspect ratio so
%   ALL 3D plots in the app share the SAME camera box / zoom level.
%
%   The implementation mimics the toolbar workaround the user spotted:
%   first switch the axes to the "Stretch-to-Fill" mode so MATLAB
%   forgets any previous tight-bounding-box adjustments, then put it
%   back into "Fixed Aspect Ratio" mode by enforcing
%   DataAspectRatio=[1 1 1] and the same explicit XLim/YLim/ZLim.
%   Calling this on every refresh keeps the box stable even when surface
%   data extents change (e.g. when a deformed pattern shrinks below a
%   unit sphere) - that is exactly the case that was making the 3D
%   pattern plot look slightly more zoomed in than the Spherical one.

    if nargin < 2 || isempty(halfBox); halfBox = 1.3; end
    if ~isgraphics(ax) || ~isvalid(ax); return; end

    try
        % Step 1 - "Stretch-to-Fill": let MATLAB drop any aspect-ratio
        % constraints it auto-set from the surface bounding box.
        ax.PlotBoxAspectRatioMode = 'auto';
        ax.DataAspectRatioMode    = 'auto';
        ax.CameraViewAngleMode    = 'auto';
        % Step 2 - explicit limits & 1:1:1 aspect = "Fixed Aspect Ratio".
        xlim(ax, [-halfBox  halfBox]);
        ylim(ax, [-halfBox  halfBox]);
        zlim(ax, [-halfBox  halfBox]);
        ax.DataAspectRatio    = [1 1 1];
        ax.PlotBoxAspectRatio = [1 1 1];
    catch
    end
end
