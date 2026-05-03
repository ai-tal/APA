function R = vecToVecRotation(s, d)
%VECTOVECROTATION Minimum-angle 3x3 rotation matrix taking unit vector s to d.
    s = s(:)/norm(s); d = d(:)/norm(d);
    c = dot(s,d);
    if c >  1-1e-12
        R = eye(3); return;
    end
    if c < -1+1e-12
        if abs(s(1)) < 0.9; ax = cross(s,[1;0;0]); else; ax = cross(s,[0;1;0]); end
        ax = ax/norm(ax);
        K = [0 -ax(3) ax(2); ax(3) 0 -ax(1); -ax(2) ax(1) 0];
        R = eye(3) + 2*(K*K);                          % Rodrigues at theta=pi
        return;
    end
    v = cross(s,d);
    K = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
    R = eye(3) + K + K*K * (1/(1+c));
end
