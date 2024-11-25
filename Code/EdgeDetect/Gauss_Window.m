function [upperW, lowerW] = Gauss_Window(sigma, lf, df, p, direction)

sigx = sigma(1);
sigy = sigma(2);

N = direction;  % number of directions
cta = 0:pi/N:pi-pi/N;

w = lf;
upperW = zeros(2*w+1, 2*w+1);
lowerW = upperW;

theta = cta(p);
for x = -w:w
    for y = -w:w
        rx = [cos(theta) sin(theta)]*[x; y];
        ry = [-sin(theta) cos(theta)]*[x; y];

        % 传统高斯窗，在中间那条缝不为0
        weight = 1/(sigx*sigy)*exp(-(rx)^2/(2*sigx^2))*exp(-(ry)^2/(2*sigy^2));
        
        if rx > 0.5 + df % && sqrt(rx^2 + ry^2) <= lf+df+eps
            upperW(x+w+1, y+w+1) = weight;
        end
        if rx < -0.5 - df % && sqrt(rx^2 + ry^2) <= lf+df+eps
            lowerW(x+w+1, y+w+1) = weight;
        end
    end
end

upperW = upperW/sum(sum(upperW));
lowerW = lowerW/sum(sum(lowerW));
