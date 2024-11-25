clc
clear 
close all;

dir = '.\Data\AIRSAR\';

img = imread(fullfile(dir, 'RealEdg.bmp'));
img = img(:,:,1);
[row, col] = size(img);

img(img==255)=1;
figure;imshow(img,[]);

bbb = abs(double(img) - ones(size(img)));

TrueSeg = bwlabeln(bbb, 8);
TrueSegOld = TrueSeg;

max(TrueSeg(:))
iter = 0;
while(1)
    
    iter = iter + 1;
    index = find(TrueSeg == 0);
    if length(index) == 0
        break;
    end
    for i = 1:row
        for j = 1:col
            if TrueSeg(i, j) == 0
                tmpLabel = TrueSeg(max(1, i-1):min(i+1, row),max(1,j-1): min(j+1, col));
                tmpLabel = tmpLabel(:);
                
                if all(tmpLabel == 0)
                    continue;
                else
                    tmpLabel(tmpLabel == 0) = [];
                    TrueSegOld(i, j) = mode(tmpLabel);
                end
                    
            else
                continue;
            end
        end
    end
    TrueSeg = TrueSegOld;
end


save(fullfile(dir, 'TrueSeg.mat'), 'TrueSeg');
