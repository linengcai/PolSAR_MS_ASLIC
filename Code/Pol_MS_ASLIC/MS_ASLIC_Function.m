
function [Label, lenSP, BR, ASA] = MS_ASLIC_Function(s, img, span, ENL, ESM)

% rs_scale = 1;
% PolH = ESM ./ ENL;

%% 计算初始超像素中心
m = size(img, 1); % 行 
n = size(img, 2); % 列

% 得到方形分布
[rowC_init, colC_init] = InitSPCenterGrid(m, n, s);

% 是否多尺度分布
if 1
    [rowC, colC, regionSizeC] = MSInitSPCenter(rowC_init, colC_init, s, 0.1, ENL, ESM);
    rs_scale = 1.25;
else
    [h, w] = size(rowC_init);
    rowC = reshape(rowC_init, h*w, 1);
    colC = reshape(colC_init, h*w, 1);
    regionSizeC = ones(size(rowC)) * s;
    rs_scale = 1;
end


lenSP = length(rowC);

if 0
    % 显示划分结果
    temp = zeros(m, n);
    lenSP = length(rowC);
    for i = 1 : lenSP
        temp(rowC(i), colC(i)) = 1;
    end
    figure;imshow(temp);
end


% 保存一个初始的超像素中心，用于确定搜索范围
rowC_init = rowC;
colC_init = colC;

% 初始超像素中心放置于边缘强度的最低处
for i = 1 : lenSP
    % 3*3 的block
    block = ESM(rowC(i) - 1 : rowC(i) + 1, colC(i) - 1 : colC(i) + 1);
    [minVal, idxArr] = min(block(:));
    % 求最小的edge的坐标
    jOffset = floor((idxArr(1) + 2) / 3);
    iOffset = idxArr(1) - 3 * (jOffset - 1);
    rowC(i) = rowC(i) + iOffset - 2;
    colC(i) = colC(i) + jOffset - 2;
end

%%  kmeans超像素分割
M = reshape(img, m * n, size(img, 3));  % 像素值重排 matlab对三维数据处理很弱
Label = zeros(m, n) - 1; % 标签
dist = Inf * ones(m, n); % 每个像素的最小距离

% 计算初始中心
colorCenter = zeros(lenSP, 9);
SpanCenter = zeros(lenSP, 1);
for i = 1 : lenSP
    colorCenter(i, 1:9) = img(rowC(i), colC(i), :);
    SpanCenter(i, 1) = span(rowC(i), colC(i), :);
end
Centers = cat(2, colorCenter, SpanCenter, rowC, colC); % 在第2维 拼接到一起

% 开始循环
iter = 0;
maxIter = 50;
while(1)
    iter = iter + 1;
    dis = Inf * ones(m, n);
    disp(iter);
    if iter > maxIter
        break
    end
    Centers_last = Centers;
    % 按照超像素个数进行循环
    for k = 1 : lenSP
        rowCidx = Centers(k, 11);
        colCidx = Centers(k, 12); % 聚类中心坐标
        rs = round(regionSizeC(k) * rs_scale);
        rowStart = max(1, rowC_init(k) - rs);
        rowEnd = min(m, rowC_init(k) + rs);
        colStart = max(1, colC_init(k) - rs);
        colEnd = min(n, colC_init(k) + rs);
        
        colorC = Centers(k, 1:9);
        spanC = Centers(k, 10);
        
        % 循环处理block
        for i = rowStart : rowEnd
            for j = colStart : colEnd
                
                colorCur = M((j - 1) * m + i, :);
                spanCur = span(i, j);
                
                d = Dist_function(colorCur, colorC, spanCur, spanC, [i, j], [rowCidx, colCidx], ENL, ESM, rs, rs_scale);
                
                if d < dis(i, j)
                    dis(i, j) = d;
                    Label(i, j) = k;
                end
                
            end
        end
    end
    
    if iter > 0
        % 后处理
        Label = PostProcess(rowC_init, colC_init, regionSizeC, rs_scale, Label);
    end
%       更新中心
    Centers = UpdateCenter(Label, rowC_init, colC_init, regionSizeC, rs_scale, M, span);
    
%     [Label, Centers] = TestPostProcess(Label, regionSizeC, rowC_init, colC_init, M, span, SpanCenter, colorCenter);
  
    
    % early stop
    diff = Centers(:,11:12) - Centers_last(:,11:12);
    disp(sum(abs(diff(:))))
    if sum(abs(diff(:))) < lenSP * s / 40 %残差低于阈值，结束迭代
        disp(sum(diff(:)));
        break;
    end
    
end

% 后处理
Label = PostProcess(rowC_init, colC_init, regionSizeC, rs_scale, Label);


