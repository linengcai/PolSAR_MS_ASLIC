% 输入 rowC_init colC_init regionSizeC 以确定搜索区域
% M1 M2 span1 span2 的特征平均值以确定新中心点的坐标
function Centers = UpdateCenter(Label, rowC_init, colC_init, regionSizeC, rs_scale, M, span)

    lenSP = length(rowC_init);
    [m, n] = size(span);
    % 更新聚类中心
    colorCenter = zeros(lenSP, 9);
    SpanCenter = zeros(lenSP, 1);
    rowC = zeros(lenSP, 1);
    colC = zeros(lenSP, 1);

    for k = 1 : lenSP
        num = 0;
        sumColor = zeros(1, 9);    
        sumR = 0;
        sumC = 0;
        sumSpan = 0;
        rs = round(regionSizeC(k) * rs_scale);
        rowStart = max(1, rowC_init(k) - rs);
        rowEnd = min(m, rowC_init(k) + rs);
        colStart = max(1, colC_init(k) - rs);
        colEnd = min(n, colC_init(k) + rs);

        for i = rowStart:rowEnd
            for j = colStart:colEnd
                if Label(i, j) == k
                    % 计算平均的坐标，像素
                    num = num + 1;
                    sumR = sumR + i;
                    sumC = sumC + j;
                    color = M((j - 1) * m + i, :);
                    sumColor = sumColor + color;
                    sumSpan = sumSpan + span(i, j);
                end
            end
        end

        colorCenter(k, :) = sumColor / num;
        rowC(k) = round(sumR / num);
        colC(k) = round(sumC / num);
        SpanCenter(k, :) = sumSpan / num;

    end
    Centers = cat(2, colorCenter, SpanCenter, rowC, colC); % 在第三维 拼接到一起    

end



% end