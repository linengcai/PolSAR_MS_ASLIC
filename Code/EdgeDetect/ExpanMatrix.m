function expan_img = ExpanMatrix(img, filterWindowSize)
    [M, N, cha] = size(img);
    expan_img = zeros(M + 2 * filterWindowSize, N + 2 * filterWindowSize, cha);
    for i = 1:cha
        tmp = img(:,:,i);
        A = [tmp(filterWindowSize+1:-1:2,:);tmp;tmp(M-1:-1:M-filterWindowSize,:)];
        B = [A(:,filterWindowSize+1:-1:2),A,A(:,N-1:-1:N-filterWindowSize)];
        expan_img(:,:,i) = B;
    end
    
end