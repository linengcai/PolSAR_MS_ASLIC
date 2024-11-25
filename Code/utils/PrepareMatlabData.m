% clc
clear all

dataPath = '.\Data\AIRSAR\';
disp(dataPath)

%% time1
[row, col] = readrowcol([dataPath, '\T3']); %read config.txt 
% T3
file_idT11 = fopen([dataPath, '\T3\T11.bin'],'rb');
file_idT22 = fopen([dataPath, '\T3\T22.bin'],'rb');
file_idT33 = fopen([dataPath, '\T3\T33.bin'],'rb');
file_idT12r = fopen([dataPath, '\T3\T12_real.bin'],'rb');
file_idT12i = fopen([dataPath, '\T3\T12_imag.bin'],'rb');
file_idT13r = fopen([dataPath, '\T3\T13_real.bin'],'rb');
file_idT13i = fopen([dataPath, '\T3\T13_imag.bin'],'rb');
file_idT23r = fopen([dataPath, '\T3\T23_real.bin'],'rb');
file_idT23i = fopen([dataPath, '\T3\T23_imag.bin'],'rb');

image = zeros(row, col, 9);


for i=1:row
    image(i, :, 1)=fread(file_idT11, col,'float32');
    image(i, :, 2)=fread(file_idT22, col,'float32');
    image(i, :, 3)=fread(file_idT33, col,'float32');
    image(i, :, 4)=fread(file_idT12r, col,'float32');
    image(i, :, 5)=fread(file_idT13r, col,'float32');
    image(i, :, 6)=fread(file_idT23r, col,'float32');
    image(i, :, 7)=fread(file_idT12i, col,'float32');
    image(i, :, 8)=fread(file_idT13i, col,'float32');
    image(i, :, 9)=fread(file_idT23i, col,'float32');
end

fclose(file_idT11);
fclose(file_idT22);
fclose(file_idT33);
fclose(file_idT12i);
fclose(file_idT12r);
fclose(file_idT13i);
fclose(file_idT13r);
fclose(file_idT23i);
fclose(file_idT23r);

T = image;

T_rec = filterTorC(image, 3);

load(fullfile(dataPath, 'span.mat'));
load(fullfile(dataPath, 'ENL.mat'));


save(fullfile(dataPath, 'dataset.mat'), 'T', 'T_rec', 'span', 'ENL');


