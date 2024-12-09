% clc
% clear

function ASA = ASACal(path, Seg)

% path = 'E:\SuperPixelProject\Data\San';

% TrueSeg �� Edge2Seg.m����õ�
TrueSeg = load(fullfile(path, 'TrueSeg.mat'));
TrueSeg = TrueSeg.TrueSeg;


lenSP = max(Seg(:));

countAll = 0;
countAcc = 0;

for i = 1:lenSP
    [indx, indy] = find(Seg == i);
    xstart = min(indx);xend = max(indx);
    ystart = min(indy);yend = max(indy);
    
    blockSeg = Seg(xstart:xend, ystart:yend);
    blockTSeg = TrueSeg(xstart:xend, ystart:yend);
    
    blockSeg(blockSeg ~= i) = 0;
    blockSeg(blockSeg == i) = 1;
    
    % ֻ���� �ó����ص�
    tmp = blockSeg .* blockTSeg;
    tmp = tmp(:);
    tmp(tmp == 0) = [];
    
    % mode : Most frequent values in array
    % �ҵ�ռ��������
    indTmp = find(tmp == mode(tmp));
    lenTmp = length(indTmp);
    
%     if lenTmp ~= length(indx)
%         disp(lenTmp);
%     end
    
    countAll = countAll + length(indx);
    countAcc = countAcc + lenTmp;
    
    
end

ASA = countAcc / countAll;
end