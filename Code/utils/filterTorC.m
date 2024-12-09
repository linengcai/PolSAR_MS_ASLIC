function T = filterTorC(T, winS)
    winSize = 3;
    
    if nargin > 1
        winSize = winS;
    end
    
    [row, col, cha] = size(T);
    
    localW = ones(winSize, winSize);
    for i = 1:cha
        T(:, :, i) = filter2(localW, T(:, :, i), 'same') / (winSize*winSize);
    end
end