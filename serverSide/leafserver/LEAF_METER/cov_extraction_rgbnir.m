% Function: extract and save the covariance matrices of RGB-NIR images, the mean is not substracted during covariance matrix computation, 
%               and random pixel sampling is executed per image.
% Input:      img_dir - the dictionary where the RGB-NIR images are stored
%               cov_dir - the dictionary where the covariance matrices are stored 
%               c_ratio - image resize ratio for covariance matrix extraction
%               n_sample - number of sampling pixels per image
% Output:    cov_matrix - covariance matrix of different RGB-NIR images
%               label_matrix - label matrix of different RGB-NIR images
% Author: Yang Xiao @ SCE NTU (hustcowboy@gmail.com)
% Created on 2012.5.10
% Last modified on 2014.1.12

function [cov_matrix, label_matrix] = cov_extraction_rgbnir(img_dir, cov_dir, c_ratio, n_sample)

% obtain the subfolders
subfolder = dir(img_dir);

c_label = 1;            % label of categories
n_pair = 0;             % number of RGB-NIR images

% RGB and NIR image separation, and covariance matrices extraction
for ii = 1:  length(subfolder)
       
     if ~strcmp(subfolder(ii,1).name,'.') && ~strcmp(subfolder(ii,1).name,'..')
         
          file =  dir(fullfile(img_dir,subfolder(ii,1).name,'*.tiff'));
          
          for jj = 1:length(file)
              
              [pathstr, filename, ext] = fileparts(fullfile(img_dir,subfolder(ii,1).name,file(jj).name));    % obtain file name
              
              if strcmp(filename(length(filename)-2:length(filename)),'rgb')
                  
                  [A, map, alpha] = imread(fullfile(img_dir,subfolder(ii,1).name,file(jj).name));   % read the RGB image
                  [img_h, img_w, nChannel] = size(A);
                  if isempty(map)
                      if nChannel == 3
                          rgb_img = A;
                      else
                          continue;
                      end
                  else
                      [img_h, img_w] = size(A);
                      tmp = zeros(3, img_h*img_w);
                      rgb_img = zeros(img_h, img_w, 3);
                      A = reshape(A, 1, img_h*img_w);
                      tmp(1,:) = floor(255*map(A+1,1));    tmp(2,:) = floor(255*map(A+1,2));      tmp(3,:) = floor(255*map(A+1,3));
                      rgb_img(:,:,1) = reshape(tmp(1,:), img_h, img_w);     rgb_img(:,:,2) = reshape(tmp(2,:), img_h, img_w);       rgb_img(:,:,3) = reshape(tmp(3,:), img_h, img_w);
                  end
                  rgb_img = double(imresize(rgb_img, c_ratio));
                   
                   % read and save the corresponding NIR image
                   nir_filename = filename;
                   nir_filename(length(nir_filename)-2:length(nir_filename)) = 'nir';
                   if ~exist(fullfile(img_dir,subfolder(ii,1).name,[nir_filename,'.tiff']), 'file')
                       error('rbg and nir images are not matched');
                   else
                       nir_img = imread(fullfile(img_dir,subfolder(ii,1).name,[nir_filename,'.tiff']));
                       nir_img = double(imresize(nir_img, c_ratio));
                   end
                   
                   % array to store RGB and NIR image for covariance matrix extraction
                   [row, col] = size(rgb_img(:,:,1));   
                   comb_img = zeros(row*col, 4);
                   for kk = 1:3
                       comb_img(:,kk) = reshape(rgb_img(:,:,kk), row*col, 1);
                   end
                   comb_img(:,kk+1) = reshape(nir_img, row*col, 1);
                   comb_img = comb_img / 255;
                   
                   % sampling from each channel
                   idx_rand = randperm(row*col);
                   sam_idx = idx_rand(1:n_sample);
                   for kk = 1:4
                       comb_img_sam(:,kk) = comb_img(sam_idx,kk);
                   end
                   
                   % covariance matrix extraction and saving
                   cov_struct = struct;
                   cov  = comb_img_sam' * comb_img_sam;
                   cov_struct.cov = cov;
                   cov_struct.dim = n_sample;
                   cov_folder = fullfile(cov_dir, subfolder(ii,1).name);
                   filename = filename(1:length(filename)-4);
                   cov_filepath = fullfile(cov_dir, subfolder(ii,1).name, [filename '.mat']);
                   if exist(cov_folder,'dir') ~= 7
                       mkdir(cov_folder);
                   end
                   save(cov_filepath, 'cov_struct');
                   
                   %output
                   n_pair = n_pair+1;
                   cov_matrix{1, n_pair} = cov_struct;
                   label_matrix(n_pair,1) = c_label;
                   
              end
          end
          
          c_label = c_label+1;      %update label
          
     end
end

