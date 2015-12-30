% Function: obtain the SPM block images
% Input:
% I                           - original image
% pyramid_levl          - SPM levels
% Output:
% block_img             - SPM block images
% spm_block_num    - number of spm blocks
% Author: Yang Xiao @ SCE NTU (hustcowboy@gmail.com)
% Created on 2012.6.7
% Last modified on 2012.6.7

function [block_img, spm_block_num] = spm_block_img(I, pyramid_levl)

spm_block_num = 1;      % number of patches in SPM
for ii = 2:pyramid_levl
    spm_block_num = spm_block_num + power(2, (ii-1))*power(2, (ii-1));
    spm_block_num = spm_block_num + ( power(2, (ii-1)) - 1) * ( power(2, (ii-1)) - 1);
end

[img_h, img_w] = size(I);   % image size of the original image

% SPM block images size
block_h = floor(img_h / power(2, (pyramid_levl-1)));
block_w = floor(img_w / power(2, (pyramid_levl-1)));

% SPM block images
block_img = cell(1, spm_block_num);
for ii = 1:spm_block_num
    block_img{1,ii} = zeros(block_h, block_w);
end

% Obtain SPM block images
block_counter = 1;
for ii = 1:pyramid_levl
    if ii == 1
        block_img{1,block_counter} = floor(imresize(I, [block_h, block_w], 'bicubic'));
        block_counter = block_counter + 1;
    else      
        block_h_ori =  floor(img_h / power(2, (ii-1)));
        block_w_ori = floor(img_w / power(2, (ii-1)));
        
        for  jj = 1:power(2,ii-1)
            for kk = 1:power(2,ii-1)           
                % left-top point of each block
                lt_point.y = block_h_ori*(kk-1) + 1;
                lt_point.x = block_w_ori*(jj-1) + 1;
                
                block_img{1,block_counter} = floor(imresize(I(lt_point.y:lt_point.y+block_h_ori-1,lt_point.x:lt_point.x+block_w_ori-1), [block_h, block_w], 'bicubic'));
                block_counter = block_counter + 1;
            end
        end
        
        for jj = 1:power(2,ii-1)-1
            for kk = 1:power(2,ii-1)-1      
                % left-top point of each block
                 lt_point.y = block_h_ori*(kk-1) + floor(block_h_ori / 2);
                 lt_point.x = block_w_ori*(jj-1) + floor(block_w_ori / 2);
                 
                 block_img{1,block_counter} = floor(imresize(I(lt_point.y:lt_point.y+block_h_ori-1,lt_point.x:lt_point.x+block_w_ori-1), [block_h, block_w], 'bicubic'));
                 block_counter = block_counter + 1;                
            end
        end        
    end
end








