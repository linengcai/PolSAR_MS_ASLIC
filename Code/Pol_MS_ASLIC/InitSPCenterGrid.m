% 计算初始的方形超像素中心分布
% 输入图像的长宽 m n 超像素的尺度s
% 得到 形状为 h * w 的初始超像素中心
 
function [rowC_init, colC_init] = InitSPCenterGrid(m, n, s)


    %--------计算栅格顶点与中心的坐标---------% 
    h = floor(m / s); % 行有多少个超像素
    w = floor(n / s); % 列有多少个超像素
    rowR = floor((m - h*s)/2); % 多余部分首尾均分
    colR = floor((n - w*s)/2);

    rowStartList=(rowR + 1) : s : (m - s + 1); % 超像素 的 起始 行数
    rowStartList(1) = 1;
    rowEndList = rowStartList + s;  % 超像素 的 结束 行数
    rowEndList(1) = rowR + s;
    rowEndList(end) = m;
    colStartList = (colR + 1) : s : (n - s + 1);
    colStartList(1) = 1;
    colEndList = colStartList + s;
    colEndList(1) = colR + s;
    colEndList(end) = n;
    rowCList = floor((rowStartList + rowEndList - 1) / 2); % 超像素 的 中心坐标
    colCList = floor((colStartList + colEndList - 1) / 2);
    % 显示划分结果
    if 0
        temp = zeros(m,n);
        temp(rowStartList,:)=1;
        temp(:,colStartList)=1;
        for i=1:h
            for j=1:w
                temp(rowCList(i), colCList(j))=1;
            end
        end
        figure,imshow(temp);
    end
    rowC_init = repmat(rowCList', [1,w]); 
    colC_init = repmat(colCList, [h,1]);


end