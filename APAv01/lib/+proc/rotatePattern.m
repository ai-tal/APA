function Q = rotatePattern(P, mode, varargin)
%ROTATEPATTERN Rotate a far-field pattern in 3D, resampling on its grid.
%
%   Q = rotatePattern(P, 'axis', name) where name is one of
%       '+X','-X','+Y','-Y','+Z','-Z'
%   rotates the pattern so the natural +Z boresight maps to that body axis.
%
%   Q = rotatePattern(P, 'arbitrary', srcThetaPhi, dstThetaPhi) where each
%   argument is a 1x2 vector [theta_deg, phi_deg], computes the minimal axis
%   rotation that maps the source direction onto the destination direction.
%
%   Q = rotatePattern(P, 'matrix', R) applies an explicit 3x3 rotation R.
%
%   The Eth, Eph components are vector-rotated to remain valid in the new
%   local (theta', phi') basis.

    switch lower(mode)
        case 'axis'
            R = axisRotation(varargin{1});
        case 'arbitrary'
            s = proc.sphToVec(varargin{1});
            d = proc.sphToVec(varargin{2});
            R = proc.vecToVecRotation(s, d);
        case 'matrix'
            R = varargin{1};
        otherwise
            error('rotatePattern:mode','Unknown rotation mode %s',mode);
    end

    th = P.theta(:);
    ph = P.phi(:);
    Nth = numel(th);
    Nph = numel(ph);

    [Tg, Pg] = ndgrid(th, ph);
    thR = deg2rad(Tg);
    phR = deg2rad(Pg);

    % Cartesian unit vector in the NEW frame for every (theta', phi').
    rN = cat(3, sin(thR).*cos(phR), sin(thR).*sin(phR), cos(thR));

    % Pre-image in OLD frame: r_old = R' * r_new
    Rt = R.';
    rO = zeros(size(rN));
    rO(:,:,1) = Rt(1,1)*rN(:,:,1) + Rt(1,2)*rN(:,:,2) + Rt(1,3)*rN(:,:,3);
    rO(:,:,2) = Rt(2,1)*rN(:,:,1) + Rt(2,2)*rN(:,:,2) + Rt(2,3)*rN(:,:,3);
    rO(:,:,3) = Rt(3,1)*rN(:,:,1) + Rt(3,2)*rN(:,:,2) + Rt(3,3)*rN(:,:,3);

    thOld = acos(max(min(rO(:,:,3),1),-1));
    phOld = mod(atan2(rO(:,:,2), rO(:,:,1)), 2*pi);

    F_th = griddedInterpolant({th, ph}, P.Eth, 'linear','nearest');
    F_ph = griddedInterpolant({th, ph}, P.Eph, 'linear','nearest');
    EthOld = F_th(rad2deg(thOld), rad2deg(phOld));
    EphOld = F_ph(rad2deg(thOld), rad2deg(phOld));

    % Local basis vectors in OLD frame at the pre-image point:
    [thHatO, phHatO] = sphBasis(thOld, phOld);
    % Local basis vectors in NEW frame at (theta', phi'):
    [thHatN, phHatN] = sphBasis(thR, phR);

    % E in cartesian (OLD frame) at the pre-image point:
    EvecOld = bsxfun(@times, EthOld, thHatO) + bsxfun(@times, EphOld, phHatO);
    % Rotate to NEW frame: E_new = R * E_old
    EvecNew = zeros(size(EvecOld));
    EvecNew(:,:,1) = R(1,1)*EvecOld(:,:,1) + R(1,2)*EvecOld(:,:,2) + R(1,3)*EvecOld(:,:,3);
    EvecNew(:,:,2) = R(2,1)*EvecOld(:,:,1) + R(2,2)*EvecOld(:,:,2) + R(2,3)*EvecOld(:,:,3);
    EvecNew(:,:,3) = R(3,1)*EvecOld(:,:,1) + R(3,2)*EvecOld(:,:,2) + R(3,3)*EvecOld(:,:,3);

    EthNew = sum(EvecNew .* thHatN, 3);
    EphNew = sum(EvecNew .* phHatN, 3);

    Q       = P;
    Q.Eth   = EthNew;
    Q.Eph   = EphNew;
    Q.meta.rotated = true;
    Q.meta.rotationR = R;
end

function R = axisRotation(name)
    switch upper(name)
        case '+Z', R = eye(3);
        case '-Z', R = diag([1 -1 -1]);                 % flip
        case '+X', R = [0 0 1; 0 1 0; -1 0 0];          % +Z -> +X
        case '-X', R = [0 0 -1; 0 1 0; 1 0 0];
        case '+Y', R = [1 0 0; 0 0 1; 0 -1 0];          % +Z -> +Y
        case '-Y', R = [1 0 0; 0 0 -1; 0 1 0];
        otherwise, error('rotatePattern:axis','Unknown axis %s',name);
    end
end

function [thHat, phHat] = sphBasis(theta, phi)
%SPHBASIS Cartesian components of theta-hat and phi-hat unit vectors.
    ct = cos(theta); st = sin(theta);
    cp = cos(phi);   sp = sin(phi);
    thHat = cat(3, ct.*cp, ct.*sp, -st);
    phHat = cat(3, -sp,    cp,     zeros(size(theta)));
end
