% Function: extract the gradient magnitude image
% Input:      I - the original image
%               type_index - gradient magnitude type index (1 - Sobel)
% Output:   gradimg - gradient magnitude image
% Author£ºYang Xiao @ IPRAI HUST (hustcowboy@gmail.com)
% Created on 2010.12.23
% Last modified on 2010.12.23

function [gradimg] = gradimg_obtain(I, type_index)

I = double(I);

if type_index == 1
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(double(I), hy, 'replicate');
    Ix = imfilter(double(I), hx, 'replicate');
    gradimg = sqrt(Ix.^2 + Iy.^2);
    
elseif type_index == 2
    
end