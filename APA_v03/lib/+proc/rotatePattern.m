function Pout = rotatePattern(P, mode, varargin)
%ROTATEPATTERN Apply a rigid rotation (antenna vs lab) remapped onto the sphere.
%   Pout = proc.rotatePattern(P, 'axis', '+Z')
%   Pout = proc.rotatePattern(P, 'arbitrary', unused, [rzDeg ryDeg])
%   Third argument is reserved; fourth gives Z*Y Euler sequence in degrees.
%   Pout = proc.rotatePattern(P, 'directions', thetaS_deg, phiS_deg, thetaT_deg, phiT_deg)
%   Aligns body direction (thetaS,phiS) with lab direction (thetaT,phiT).

    switch lower(mode)
        case 'axis'
            lbl = varargin{1};
            assert(strcmp(lbl, '+Z'), ...
                'rotatePattern: only axis ''+Z'' is identity.');
            Pout = P;
        case 'arbitrary'
            eulerDeg = varargin{2};
            assert(numel(eulerDeg) >= 2, 'rotatePattern: expected [rz, ry] degrees.');
            R = eulerToRotm(double(eulerDeg(:).'));
            Pout = rotateFarfield(P, R);
        case 'directions'
            assert(numel(varargin) >= 4, ...
                'rotatePattern: directions expects thetaSource_deg phiSource_deg thetaTarget_deg phiTarget_deg.');
            ths = double(varargin{1});
            phs = double(varargin{2});
            tht = double(varargin{3});
            pht = double(varargin{4});
            if abs(mod(phs - pht + 180, 360) - 180) < 1e-9 && abs(ths - tht) < 1e-9
                Pout = P;
                return
            end
            us = dirsvec(ths, phs);
            ut = dirsvec(tht, pht);
            R = rotMatMapAToB(us, ut);
            Pout = rotateFarfield(P, R);
        otherwise
            error('proc:rotatePattern:Mode', 'Unknown mode "%s".', mode);
    end
end

function R = rotMatMapAToB(a, b)
% Minimal rotation R with R*a = b (unit vectors), right-handed.
    a = a(:) / max(norm(a), eps);
    b = b(:) / max(norm(b), eps);
    v = cross(a, b);
    nv = norm(v);
    c = dot(a, b);
    if nv < 1e-14
        if c > 1 - 1e-14
            R = eye(3);
        else
            tmp = [1; 0; 0];
            if abs(dot(tmp, a)) > 0.9
                tmp = [0; 1; 0];
            end
            w = cross(a, tmp);
            w = w / max(norm(w), eps);
            K = skewSym(w);
            R = eye(3) + 2 * (K * K);
        end
    else
        k = v / nv;
        ang = atan2(nv, c);
        K = skewSym(k);
        R = eye(3) + sin(ang) * K + (1 - cos(ang)) * (K * K);
    end
end

function K = skewSym(w)
    K = [    0    -w(3)  w(2)
          w(3)     0   -w(1)
         -w(2)  w(1)    0   ];
end

function R = eulerToRotm(v)
    rz = deg2rad(v(1));
    ry = deg2rad(v(2));
    if numel(v) >= 3 && abs(v(3)) > 1e-12
        rz2 = deg2rad(v(3));
        R = Rz(rz)*Ry(ry)*Rz(rz2);
    else
        R = Rz(rz)*Ry(ry);
    end
end

function M = Rz(a)
    M = [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];
end

function M = Ry(a)
    M = [cos(a) 0 sin(a); 0 1 0; -sin(a) 0 cos(a)];
end

function Pout = rotateFarfield(P, R)
    Th = P.theta;
    Ph = P.phi;
    thU = unique(Th(:), 'sorted');
    phU = unique(Ph(:), 'sorted');
    Fth = griddedInterpolant({thU, phU}, P.Eth, 'linear', 'none');
    Fph = griddedInterpolant({thU, phU}, P.Eph, 'linear', 'none');

    sz = size(Th);
    Etho = zeros(sz);
    Epho = zeros(sz);

    for ii = 1:numel(Th)
        thd = Th(ii);
        phd = Ph(ii);
        uLab = dirsvec(thd, phd);
        uBody = R' * uLab;
        [tb, pb] = vec2sphere(uBody);
        pbw = wrapPhi360(pb, phU);
        try
            Eb_t = Fth(tb, pbw);
            Eb_p = Fph(tb, pbw);
        catch
            Eb_t = 0;
            Eb_p = 0;
        end
        [thbHat, phbHat] = shellbasis(tb, pbw);
        Ecart_body = Eb_t .* thbHat + Eb_p .* phbHat;
        Ecart_lab = R * Ecart_body;
        [thlHat, phlHat] = shellbasis(thd, phd);
        Etho(ii) = dot(Ecart_lab, thlHat);
        Epho(ii) = dot(Ecart_lab, phlHat);
    end

    Pout = P;
    Pout.Eth = Etho;
    Pout.Eph = Epho;
end

function u = dirsvec(thDeg, phDeg)
    th = deg2rad(thDeg);
    ph = deg2rad(phDeg);
    u = [sin(th).*cos(ph); sin(th).*sin(ph); cos(th)];
end

function [thHat, phHat] = shellbasis(thDeg, phDeg)
    th = deg2rad(thDeg);
    ph = deg2rad(phDeg);
    ct = cos(th); st = sin(th); cp = cos(ph); sp = sin(ph);
    thHat = [ct*cp; ct*sp; -st];
    phHat = [-sp; cp; 0];
end

function [thetaDeg, phiDeg] = vec2sphere(u)
    u = u(:);
    u = u / max(norm(u), eps);
    z = min(max(u(3), -1), 1);
    thetaDeg = acosd(z);
    phiDeg = atan2(u(2), u(1)) * (180/pi);
    phiDeg = mod(phiDeg + 360, 360);
end

function phw = wrapPhi360(ph, phU)
    phw = mod(ph, 360);
    phMin = min(phU); phMax = max(phU);
    if phw < phMin
        phw = phw + 360;
    end
    if phw > phMax + 1e-6 && phMax >= 359
        phw = mod(phw, 360);
    end
    phw = min(max(phw, phMin), phMax);
end
