% clc
% clear all
% close all
%%  ‰»Î

function BR = BoundaryRecall(path, SegLabel)

RealEdg = imread(fullfile(path, 'RealEdg.bmp'));

[row, col] = size(SegLabel);

TP = 0;
FN = 0;
winSize = 3;
blockwindow = zeros(2*winSize+1, 2*winSize+1);
for i = 1:2*winSize+1
    for j = 1:2*winSize+1
        i_ = i - winSize - 1;
        j_ = j - winSize - 1;
        if i_^2 + j_^2 <= winSize*winSize
            blockwindow(i, j) = 1;
        end
    end
end

for i = 1:row
    for j = 1:col
        if RealEdg(i, j) == 255
            rowStart = max(1, i - winSize);
            rowEnd = min(row, i + winSize);
            colStart = max(1, j - winSize);
            colEnd = min(col, j + winSize);
            block = SegLabel(rowStart:rowEnd, colStart:colEnd);
            
            if all(size(block) == size(blockwindow))
                block = block .* blockwindow;
            end
            
            block = block(:);
            block(block == 0) = [];
            if length(unique(block)) >= 2
                TP = TP + 1;
            else
                FN = FN + 1;
            end
            
%             if all(all(block == block(1,1)))
%                 FN = FN + 1;
%             else
%                 TP = TP + 1;
%             end
            
        end
    end
end

BR = TP / (TP + FN);
end


