function [row, col]=readrowcol(path)
%read config.txt file,which is in the same directory with data file.

fid = fopen(fullfile(path, '\config.txt'),'r');
%fseek(fid,216,'bof');
rowcol = textscan(fid, '%s');
row = str2num(cell2mat(rowcol{1}(2)));
col = str2num(cell2mat(rowcol{1}(5)));
fclose(fid);
