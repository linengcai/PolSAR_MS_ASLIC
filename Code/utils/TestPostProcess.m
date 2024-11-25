
function [Label, Centers] = TestPostProcess(Label, regionSizeC, rowC_start, colC_start, M, span, SpanC_start, colorC_start)


    lenSP = length(rowC_start);
    
    [m, n] = size(Label);
    
    for k = 1 : lenSP

    %     if k == 625
    %         disp(k)
    %     end

        % 获取超像素的栅格区域

        % 修改为目前聚类中心为中心的栅格
    %     rowCidx = rowC_start(k);
    %     colCidx = colC_start(k);
        rs = regionSizeC(k);
        rowStart = max(1, rowC_start(k) - rs);
        rowEnd = min(m, rowC_start(k) + rs);
        colStart = max(1, colC_start(k) - rs);
        colEnd = min(n, colC_start(k) + rs);

        % 获取超像素的block
        block = Label(rowStart : rowEnd, colStart : colEnd);
        block(block ~= k) = 0;
        block(block == k) = 1;
        [label, szlabel] = bwlabel(block, 4); % 把一张0，1的图，生成连通域的图
    %     szlabel = max(label(:)); % 标签个数
        bh = rowEnd - rowStart + 1;
        bw = colEnd - colStart + 1;  %block的宽高

%         %无伴生连通域，略过
%         if szlabel < 2  
%             continue;
%         end

    %     labelC = label(rowCidx - rowStart + 1, colCidx - colStart + 1); %主连通域的标记值

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
            if i == labelC && maxLen > 9%主连通域不处理
                continue;
            end

            marker = zeros(bottom - top + 1, right - left + 1); %生成一个外扩一圈的marker，标记哪些点已经被统计过接触情况
            bw = label;
            bw(bw ~= i) = 0;
            bw(bw == i) = 1; %当前连通域标记图
            contourBW = bwperim(bw); %求取外轮廓
            %             figure,imshow(contourBW);
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
    
    % 更新聚类中心
    colorC = zeros(lenSP, 9);
    SpanC = zeros(lenSP, 1);
    rowC = zeros(lenSP, 1);
    colC = zeros(lenSP, 1);
    for k = 1 : lenSP
        num = 0;
        sumColor = zeros(1, 9);    
        sumR = 0;
        sumC = 0;
        sumSpan = 0;
        
        % 获取聚类中心的栅格
        % 修改为目前聚类中心为中心的栅格
%         c = floor((k - 1) / h) + 1;
%         r = k - h * (c - 1);
%         rowCidx = rowC_start(k);
%         colCidx = colC_start(k);
        rs = regionSizeC(k);
        rowStart = max(1, rowC_start(k) - rs);
        rowEnd = min(m, rowC_start(k) + rs);
        colStart = max(1, colC_start(k) - rs);
        colEnd = min(n, colC_start(k) + rs);
        
        for i = rowStart : rowEnd
            for j = colStart : colEnd
                if Label(i, j) == k
                    % 计算平均的坐标，像素
                    num = num + 1;
                    sumR = sumR + i;
                    sumC = sumC + j;
%                     color = reshape(img(i, j, :), 1, 9);
                    color  = M((j - 1) * m + i, :);
                    sumColor = sumColor + color;
                    sumSpan = sumSpan + span(i, j);
                end
            end
        end
        if num == 0
%             disp(num)
            rowC(k) = rowC_start(k);
            colC(k) = colC_start(k);
            SpanC(k) = SpanC_start(k);
            colorC(k, :) = colorC_start(k, :);
        else
            colorC(k, :) = sumColor / num;
            rowC(k) = round(sumR / num);
            colC(k) = round(sumC / num);
            SpanC(k) = sumSpan / num;
        end   
    end
    Centers = cat(2, colorC, SpanC, rowC, colC); % 在第三维 拼接到一起      
    
    
end