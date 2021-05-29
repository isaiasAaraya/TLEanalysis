% Input reci and veci must be column vectors

function [rrsw, vrsw, transmat] = rv2rsw(reci, veci)
        
        % radial component (unit vector)
        rvec = reci/norm(reci);

        % cross-track component (unit vector)
        wvec    = cross(reci, veci)/norm(cross(reci, veci));
        
        % along-track component (unit vector)
        svec    = cross(wvec, rvec)/norm(cross(wvec, rvec));
        
        
        % assemble transformation matrix from eci to rsw frame (individual
        % components arranged in row vectors)
        transmat(1,1) = rvec(1);
        transmat(1,2) = rvec(2);
        transmat(1,3) = rvec(3);
        transmat(2,1) = svec(1);
        transmat(2,2) = svec(2);
        transmat(2,3) = svec(3);
        transmat(3,1) = wvec(1);
        transmat(3,2) = wvec(2);
        transmat(3,3) = wvec(3);

        rrsw = transmat*reci;
        vrsw = transmat*veci;
end