function z = fPauliImShow(varargin)

data = varargin{1};
n = 2;
if nargin ==2
    n = varargin{2};
end

z(:,:,3) = uint8(255 * min(1, data(:,:,1))./(mean2(data(:,:,1))*n));
z(:,:,1) = uint8(255 * min(1, data(:,:,2))./(mean2(data(:,:,2))*n));
z(:,:,2) = uint8(255 * min(1, data(:,:,3))./(mean2(data(:,:,3))*n));


% a = mean2(data(:,:,1))*n;
% b = mean2(data(:,:,2))*n;
% c = mean2(data(:,:,3))*n;
% aa = max(a,b);
% aa = max(aa, c);

% z(:,:,3) = (data(:,:,1))./aa;
% z(:,:,1) = (data(:,:,2))./aa;
% z(:,:,2) = (data(:,:,3))./aa;
