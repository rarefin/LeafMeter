% Function: opponent transformation on multi-channel images (the method proposed in Ref. [1]) 
% Input: 
% comb_img           -  array which contain multi-channel images
% trans_matrix        -  opponent transformation matrix
% Output: 
% decor_img          -  the opponent transfomed images
% Ref. [1]: M. Brown and S. S¨¹sstrunk, "Multi-spectral SIFT for scene category recognition" , CVPR11
% Author: Yang Xiao @ SCE NTU (hustcowboy@gmail.com)
% Created on 2012.4.23
% Last modified on 2014.1.12

function [decor_img] = oppo_trans(comb_img, trans_matrix)

%% Parameters
channel_num = length(comb_img);     % obtain the number of channels
[row, col] = size(comb_img{1,1});       % obtain the image size of each channel

[m_row, m_col] = size(trans_matrix); 
for i = 1:m_col
     trans_matrix(:,i) =  trans_matrix(:,i) / sum(abs( trans_matrix(:,i)));     % normalize opponent transformation matrix
end

%% Transform the image of each channel to one dimensional
for i = 1:channel_num
    data_array(:, i) = reshape(comb_img{1,i}, row*col, 1);
end
data_array = double(data_array);

%% Opponent transformation
data_decor_array = data_array * trans_matrix;       %1-d decorrelated image array for each channel

% obtain the offset
[d_row, d_col] = size(data_array);
offset_decor_array = 255 * ones(d_row, d_col);     % offset array

%assign the elements more than 0 in trans_matrix to 0 and abs trans_matrix
[idx_row, idx_col] = find(trans_matrix>0);
for i = 1:length(idx_row)
    trans_matrix(idx_row(i),idx_col(i)) = 0;
end
trans_matrix = abs(trans_matrix);

data_decor_array = data_decor_array + offset_decor_array*trans_matrix;

%% Output
[d_dim, output_channel_num] = size(data_decor_array);
for i = 1:output_channel_num
    decor_img{1,i} = reshape(data_decor_array(:,i), row, col);
end
