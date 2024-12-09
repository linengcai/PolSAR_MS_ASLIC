% 后处理 形态学处理
% 输入 rowC_init colC_init regionSizeC 以确定搜索区域
function Label = PostProcess(rowC_init, colC_init, regionSizeC, rs_scale, Label)
% 后处理片段
[m, n] = size(Label);
lenSP = length(rowC_init);
for k = 1 : lenSP
    % 修改为目前聚类中心为中心的栅格
    rs = round(regionSizeC(k) * rs_scale);
    rowStart = max(1, rowC_init(k) - rs);
    rowEnd = min(m, rowC_init(k) + rs);
    colStart = max(1, colC_init(k) - rs);
    colEnd = min(n, colC_init(k) + rs);

    % 获取超像素的block
    block = Label(rowStart:rowEnd, colStart:colEnd);
    block(block ~= k) = 0;
    block(block == k) = 1;
    [label, szlabel] = bwlabel(block, 4); % 把一张0，1的图，生成连通域的图
    bh = rowEnd - rowStart + 1;
    bw = colEnd - colStart + 1;  %block的宽高
    %无伴生连通域，略过
    if szlabel < 2  
        continue;
    end

    % 找到最大的连通区域，为主连通区域
    maxLen = -1;
    labelC = 1;
    for j = 1:szlabel
        tmpaa = find(label == j);
        if maxLen < length(tmpaa)
            maxLen = length(tmpaa);
            labelC = j;
        end
    end

    top = max(1, rowStart - 1);
    bottom = min(m, rowEnd + 1);
    left = max(1, colStart - 1);
    right = min(n, colEnd + 1);
    for i = 1 : szlabel %遍历连通域
        if i == labelC %主连通域不处理
            continue;
        end

        marker = zeros(bottom - top + 1, right - left + 1); %生成一个外扩一圈的marker，标记哪些点已经被统计过接触情况
        bw = label;
        bw(bw ~= i) = 0;
        bw(bw == i) = 1; %当前连通域标记图
        contourBW = bwperim(bw); %求取外轮廓
        idxArr = find(contourBW == 1);
        labelArr = zeros(4 * length(idxArr), 1);  %记录轮廓点的4邻域点标记值的向量
        num = 0;
        for idx = 1 : size(idxArr) %遍历轮廓点,统计其4邻域点的标记值
            bc = floor((idxArr(idx) - 1) / bh) + 1;
            br = idxArr(idx) - bh * (bc - 1); %轮廓点在block中的行列信息
            row = br + rowStart - 1;
            col = bc + colStart - 1; %轮廓点在大图中的行列信息
            rc = [row - 1, col; row + 1, col; row, col - 1; row, col + 1];
            for p = 1 : 4
                row = rc(p, 1);
                col = rc(p, 2);

                if ~(row >= 1 && row <= m && col >= 1 && col <= n && Label(row, col) ~= k)
                    continue;
                end

                if marker(row - top + 1, col - left + 1) == 0 %未被统计过
                    marker(row - top + 1, col - left + 1) = 1;
                    num = num + 1;
                    labelArr(num) = Label(row, col);
                end
            end
        end

        labelArr(labelArr == 0) = []; %去除零元素
        uniqueLabel = unique(labelArr);
        numArr = zeros(length(uniqueLabel), 1);
        for p = 1 : length(uniqueLabel)
            idx = find(labelArr == uniqueLabel(p));
            numArr(p) = length(idx);
        end
        idx = find(numArr == max(numArr));
        maxnumLabel = uniqueLabel(idx(1)); %接触最多的标签

        for row = rowStart : rowEnd
            for col = colStart : colEnd
                if bw(row-rowStart+1, col-colStart+1) == 0
                    continue;
                end
                Label(row, col) = maxnumLabel;
            end
        end
    end
end