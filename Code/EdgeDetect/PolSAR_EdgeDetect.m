function [edge_map, ESM] = PolSAR_EdgeDetect(img, thresh, sigma, wl, directions)
% img: input PolSAR image
% thresh: a vector of [lowT, highT], and 0< lowT < highT < 1;

thresh0 = .1;
thresh1 = .1;
thresh2 = .2;

if nargin > 1
    thresh0 = thresh(1);
    thresh1 = thresh(1);
    thresh2 = thresh(2);
end

filterWindowSize = ceil(sqrt((wl(1) + 1)^2 + wl(2)^2));

%------------ Compute edge map for PolSAR data using Gauss window----------

[ESM_R, index] = PolSAR_GaussWindow_Filter(img, sigma, filterWindowSize, directions);


%%
ESM = ESM_R;
% figure, imshow(ESM_R,[])
% figure, imshow(index, [])
%--------------------------------------------
edgeMap_0 = non_maximum_suppression_multidirection(ESM, index, thresh0, 1, directions);

% % %-----extract edge map
edge_possible = (ESM>thresh1).*edgeMap_0;
edge_strong = (ESM>thresh2).*edgeMap_0;
[xs, ys] = find(edge_strong == 1);
edge_map = bwselect(edge_possible, ys, xs, 8);
edge_map = bwmorph(edge_map, 'thin',8);
edge_map = edge_map(filterWindowSize+1:end-filterWindowSize, filterWindowSize+1:end-filterWindowSize);
ESM = ESM(filterWindowSize+1:end-filterWindowSize, filterWindowSize+1:end-filterWindowSize);

end