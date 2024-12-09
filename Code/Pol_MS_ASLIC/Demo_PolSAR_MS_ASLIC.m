clc
close all
clear all

global dataPath;
dataPath = '.\Data\AIRSAR\';
load(fullfile(dataPath, 'dataset.mat'));
realEdge = imread(fullfile(dataPath, 'RealEdg.bmp'));
realEdge = realEdge./255;
Pauli_Img = imread(fullfile(dataPath, 'PauliRGB.bmp'));

%% edge detect
ESM_file = fullfile(dataPath, 'ESM.mat');
Flag_regeneESM = 1;
if exist(ESM_file, 'file') == 2 && Flag_regeneESM == 0
    load(ESM_file);
else
    %----- setting -------%
    direction = 8;  % directions
    Tlow = .1;     %  0.03 threshold
    Thigh = 0.6;  % 0.18
    thresh = [Tlow Thigh]; % 用来生成edgeMap的阈值参数

    w = 3;
    l = 3;
    wl = [w, l];
    sigx = (2*l+3)/(2*sqrt(pi));
    sigy = sigx / 2;
    sigma = [sigx, sigy];

    % ---------- edge detect ------------
    tic
    [edgeMap, ESM] = PolSAR_EdgeDetect(T_rec, thresh, sigma, wl, direction);
    toc

    % save
    save(fullfile(dataPath, 'ESM.mat'), 'ESM');
end

%% preprocess
ENL = ENL ./ max(ENL(:));
span_max = min(max(span(:)), mean(span(:)) * 2);
span = min(1, span ./ span_max);
ESM_max = min(max(ESM(:)), mean(ESM(:)) * 4);
ESM = min(1, ESM ./ ESM_max);
ESM = ESM * 0.9 + 0.1;


%% Superpixel Generation
BR_MSLNC_Array = [];
ASA_MSLNC_Array = [];
lenSP_MSLNC_Array = [];
s_Array = [42	34	28	23	19	15	12	10];
for i = 1:length(s_Array)
    s = s_Array(i);
    [Label, lenSP] = MS_ASLIC_Function(s, T_rec, span, ENL, ESM);
    % 创建边界掩码
    Boundary = boundarymask(Label);
    % 显示原图像和带标签的图像
    figure;
    imshow(imoverlay(Pauli_Img, Boundary, 'red')); % 原图上叠加边界
    BR = BoundaryRecall(dataPath, Label);
    ASA = ASACal(dataPath, Label);
    BR_MSLNC_Array = [BR_MSLNC_Array, BR];
    ASA_MSLNC_Array = [ASA_MSLNC_Array, ASA];
    lenSP_MSLNC_Array = [lenSP_MSLNC_Array, lenSP];  
end





