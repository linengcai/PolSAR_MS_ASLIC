%%
% clc;
% clear;
% close all;


% dataPath = [path, site{S}, '\ROI_', num2str(L), times{T}];

% dataPath = 'C:\SuperPixelProject\Data\San';

function result = PolSARProData2MatlabData(dataPath)

disp(dataPath)
[row, col] = readrowcol([dataPath, '\C3']);%read config.txt 

%% C3
file_idC11 = fopen([dataPath, '\C3\C11.bin'],'rb');
file_idC22 = fopen([dataPath, '\C3\C22.bin'],'rb');
file_idC33 = fopen([dataPath, '\C3\C33.bin'],'rb');
file_idC12r = fopen([dataPath, '\C3\C12_real.bin'],'rb');
file_idC12i = fopen([dataPath, '\C3\C12_imag.bin'],'rb');
file_idC13r = fopen([dataPath, '\C3\C13_real.bin'],'rb');
file_idC13i = fopen([dataPath, '\C3\C13_imag.bin'],'rb');
file_idC23r = fopen([dataPath, '\C3\C23_real.bin'],'rb');
file_idC23i = fopen([dataPath, '\C3\C23_imag.bin'],'rb');

C11=zeros(row,col);
C22=zeros(row,col);
C33=zeros(row,col);
C12i=zeros(row,col);
C12r=zeros(row,col);
C13r=zeros(row,col);
C13i=zeros(row,col);
C23i=zeros(row,col);
C23r=zeros(row,col);
for i=1:row
    C11(i,:)=fread(file_idC11, col,'float32');
    C22(i,:)=fread(file_idC22, col,'float32');
    C33(i,:)=fread(file_idC33, col,'float32');
    C12i(i,:)=fread(file_idC12i, col,'float32');
    C12r(i,:)=fread(file_idC12r, col,'float32');
    C13i(i,:)=fread(file_idC13i, col,'float32');
    C13r(i,:)=fread(file_idC13r, col,'float32');
    C23i(i,:)=fread(file_idC23i, col,'float32');
    C23r(i,:)=fread(file_idC23r, col,'float32');
end

C12=complex(C12r, C12i);
C13=complex(C13r, C13i);
C23=complex(C23r, C23i);



saveFile = [dataPath '\C_Ori.mat'];
save(saveFile, 'C11', 'C22', 'C33', 'C12', 'C13', 'C23');

C = cat(3,C11,C22,C33,C12r,C13r,C23r,C12i,C13i,C23i);
save([dataPath '\Cori.mat'], 'C');

fclose(file_idC11);
fclose(file_idC22);
fclose(file_idC33);
fclose(file_idC12i);
fclose(file_idC12r);
fclose(file_idC13i);
fclose(file_idC13r);
fclose(file_idC23i);
fclose(file_idC23r);

%% Span
span = C11 + C22 + C33;
saveFile3 = [dataPath, '\span.mat']; 
save(saveFile3, 'span');

%% T3
file_idT11 = fopen([dataPath, '\T3\T11.bin'],'rb');
file_idT22 = fopen([dataPath, '\T3\T22.bin'],'rb');
file_idT33 = fopen([dataPath, '\T3\T33.bin'],'rb');
file_idT12r = fopen([dataPath, '\T3\T12_real.bin'],'rb');
file_idT12i = fopen([dataPath, '\T3\T12_imag.bin'],'rb');
file_idT13r = fopen([dataPath, '\T3\T13_real.bin'],'rb');
file_idT13i = fopen([dataPath, '\T3\T13_imag.bin'],'rb');
file_idT23r = fopen([dataPath, '\T3\T23_real.bin'],'rb');
file_idT23i = fopen([dataPath, '\T3\T23_imag.bin'],'rb');

T11=zeros(row,col);
T22=zeros(row,col);
T33=zeros(row,col);
T12i=zeros(row,col);
T12r=zeros(row,col);
T13r=zeros(row,col);
T13i=zeros(row,col);
T23i=zeros(row,col);
T23r=zeros(row,col);
for i=1:row
    T11(i,:)=fread(file_idT11, col,'float32');
    T22(i,:)=fread(file_idT22, col,'float32');
    T33(i,:)=fread(file_idT33, col,'float32');
    T12i(i,:)=fread(file_idT12i, col,'float32');
    T12r(i,:)=fread(file_idT12r, col,'float32');
    T13i(i,:)=fread(file_idT13i, col,'float32');
    T13r(i,:)=fread(file_idT13r, col,'float32');
    T23i(i,:)=fread(file_idT23i, col,'float32');
    T23r(i,:)=fread(file_idT23r, col,'float32');
end

T12=complex(T12r, T12i);
T13=complex(T13r, T13i);
T23=complex(T23r, T23i);

saveFile = [dataPath '\T_Ori.mat'];
save(saveFile, 'T11', 'T22', 'T33', 'T12', 'T13', 'T23');
T = cat(3,T11,T22,T33,T12r,T13r,T23r,T12i,T13i,T23i);
save([dataPath '\Tori.mat'], 'T');

fclose(file_idT11);
fclose(file_idT22);
fclose(file_idT33);
fclose(file_idT12i);
fclose(file_idT12r);
fclose(file_idT13i);
fclose(file_idT13r);
fclose(file_idT23i);
fclose(file_idT23r);

%% ENL
file_idENL = fopen(fullfile(dataPath, '\T3\ratio_log.bin'),'rb');

ENL = zeros(row, col);
for i = 1 : row
	ENL(i, :)=fread(file_idENL, col, 'float32');
end

save(fullfile(dataPath, 'ENL.mat'), 'ENL');
fclose(file_idENL);


result = 0;

                       
    

