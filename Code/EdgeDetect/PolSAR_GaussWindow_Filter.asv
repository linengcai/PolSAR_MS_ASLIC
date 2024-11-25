function [ESM, index] = PolSAR_GaussWindow_Filter(img, sigma, lf, directions)

% img: 原图像
% lf: windows size
% ESM: 边缘映射
% index: 每一点对应的最小比率方向

% 由于输入的是重建后的PolSAR图像，无需滤波
img_mean = img;

%expand sample C matrix
expan_img = ExpanMatrix(img_mean, lf);
[expanRow, expanCol] = size(expan_img(:,:,1));

% cta = 0:pi/directions:pi-pi/directions;
Dist = zeros(expanRow, expanCol, directions);

for p=1:directions
    % 生成高斯双边窗
	[upperW, lowerW] = Gauss_Window(sigma, lf, 0, p, directions);
%     window = upperW + lowerW;
    
    % estimate Zx
    C11U=filter2(upperW,expan_img(:,:,1),'same');
    C22U=filter2(upperW,expan_img(:,:,2),'same');
    C33U=filter2(upperW,expan_img(:,:,3),'same');
    C12rU=filter2(upperW,expan_img(:,:,4),'same');
    C13rU=filter2(upperW,expan_img(:,:,5),'same');
    C23rU=filter2(upperW,expan_img(:,:,6),'same');
    C12iU=filter2(upperW,expan_img(:,:,7),'same');
    C13iU=filter2(upperW,expan_img(:,:,8),'same');
    C23iU=filter2(upperW,expan_img(:,:,9),'same');
    
    % estimate Zy
    C11L=filter2(lowerW,expan_img(:,:,1),'same');
    C22L=filter2(lowerW,expan_img(:,:,2),'same');
    C33L=filter2(lowerW,expan_img(:,:,3),'same');
    C12rL=filter2(lowerW,expan_img(:,:,4),'same');
    C13rL=filter2(lowerW,expan_img(:,:,5),'same');
    C23rL=filter2(lowerW,expan_img(:,:,6),'same');
    C12iL=filter2(lowerW,expan_img(:,:,7),'same');
    C13iL=filter2(lowerW,expan_img(:,:,8),'same');
    C23iL=filter2(lowerW,expan_img(:,:,9),'same');
    
    for i = 1:expanRow
        for j = 1:expanCol
            Zx = [C11U(i, j), C22U(i, j), C33U(i, j),C12rU(i, j),C13rU(i, j),C23rU(i, j),C12iU(i, j),C13iU(i, j),C23iU(i, j)];
            Zy = [C11L(i, j), C22L(i, j), C33L(i, j),C12rL(i, j),C13rL(i, j),C23rL(i, j),C12iL(i, j),C13iL(i, j),C23iL(i, j)];

            Dist(i,j,p) = CalJBLD_biwindow(Zx, Zy);                 
        end
    end

    disp([ 'processed ' num2str(p) ' direction']); 
end

[ESM, index] = max(Dist,[],3);

end

