clc
clear all
% close all

%% 
%-----load PolSAR data-------%
dataPath = '.\Data\AIRSAR\';

load(fullfile(dataPath, 'dataset.mat'));

img_pauli=fPauliImShow(T);
figure,imshow(img_pauli);

%%
ESM_file = fullfile(dataPath, 'ESM.mat');
Flag_regeneESM = 0;
if exist(ESM_file, 'file') == 2 && Flag_regeneESM == 0
    load(ESM_file);
else
    %------------ parameter setting ---------------
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

%% plot
% 归一化
ESM = min(ESM, mean(ESM(:) * 6));
min_val = min(ESM(:));
max_val = max(ESM(:));
ESM = (ESM - min_val) / (max_val - min_val);
figure;
imagesc(ESM);
axis equal;
axis off
colorbar;  % 显示颜色栏