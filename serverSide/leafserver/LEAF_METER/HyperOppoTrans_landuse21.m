% Function: execute the hyper opponent transformation on the 21 class land-use classification dataset
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Tips: The 21 class land-use classification dataset can be downloaded at http://vision.ucmerced.edu/datasets/landuse.html
%         For this dataset, please group the images of different categories into different folders firstly.  
% Created on 2012.4.22
% Last modified on 2014.1.12

clear;  close all;  clc;

%% Parameter setting
c_ratio = 1;                       % image resize ratio for covariance matrix extraction
nRounds = 5;                    % number of rounds of image sampling on the dataset
nSamImg = 80;                 % number of sampling images per round
nSamPixel = 2000;            % number of sampling pixels in each multi-channel image
nChannel = 3;                   % number of image channels

%% Path setting
% obtain the root path of the RGB images
directory_name = uigetdir('F:\mCENTRIST_v1.0\mCENTRIST_v1.0\UCMerced_LandUse\','Mixed Images');
indx = strfind(directory_name,'\');
directory_name_top = directory_name(1:indx(end)-1);

cov_dir = 'cov';       % path for covariance matrix
path_cov = fullfile(directory_name_top, cov_dir);
if exist(path_cov, 'dir') ~= 7
    mkdir(path_cov);
end

vv_dir = 'vec_val';   % path for eigenvector and eigenvalue
path_vv = fullfile(directory_name_top, vv_dir);
if exist(path_vv, 'dir') ~= 7
    mkdir(path_vv);
end

%% Extract and save the covariance matrices of RGB images
disp('Covariance matrix extraction!');
[cov_matrix, label_matrix] =  cov_extraction_rgb(directory_name, path_cov, c_ratio, nSamPixel);

%% Opponent transformation matrix computation
disp('Opponent transformation matrix computation!');
nclass = label_matrix(length(label_matrix),1);     
clabel = 1:1:nclass;
vv_show = cell(1, nRounds);      % the eigen vectors computed from all the rounds
trans_matrxi = [ ];                     % the final opponent transformation matrix

for ii = 1:nRounds
    sam_idx = [];   % index of the sampled RGB images
    
    for jj = 1:nclass
        idx_label = find(label_matrix == clabel(jj));
        num = length(idx_label);
        idx_rand = randperm(num);
        sam_idx = [sam_idx; idx_label(idx_rand(1:nSamImg))];
    end
    
    f_cov = zeros(nChannel,nChannel);         % the covariance matrix of the sampled RGB image
    c_dim = 0;                                             % number of the sampled RGB pixels
    for jj = 1:length(sam_idx)
        f_cov = f_cov + cov_matrix{1,sam_idx(jj)}.cov;
        c_dim = c_dim + cov_matrix{1,sam_idx(jj)}.dim;
    end
    f_cov = f_cov / (c_dim-1);
    
    [vect, val] = eig(f_cov);                           % obtain eigenvalue and eigenvectors of covariance matrix
    val = diag(val);                                       % obtain eigenvalue as one-dimensional vector
    [junk, rindices] = sort(-1*val);                  % sort "val" in decreasing order
    val = val(rindices);
    vect = vect(:,rindices);
    for jj = 1:size(vect,2)
        vect(:,jj) = vect(:,jj) / sum(abs(vect(:,jj)));
    end
    
    % save eigenvector and eigenvalue
    vect_val = struct;
    vect_val.vector = vect;
    vect_val. val = val;
    vvfile_path = fullfile(path_vv, [num2str(ii) '.mat']);
    save(vvfile_path, 'vect_val');
    
    vv_show{1,ii} = vect_val;
end

for ii = 1:nRounds
    if ii==1
        sum_vect = vv_show{1,ii}.vector;
        sum_val = vv_show{1,ii}.val;
    else
        sum_vect = sum_vect + vv_show{1,ii}.vector;
        sum_val = sum_val + vv_show{1,ii}.val;
    end    
end

%------------------------------------------------------------
trans_matrix = sum_vect / nRounds;      % obtain the opponent transformation maxtrix for the RGB-NIR 9 class scene dataset

% in mCENTRIST TIP paper, the opponent transformation matrix is:
% trans_matrix = [0.3419 0.3419 0.3162; -0.4829 0.0618 0.4553; -0.2158 0.4889 -0.2953]';  
%------------------------------------------------------------

%% Obtain the hyper opponent transformed images and save the results
disp('Hyper opponent transformation!');

% create folders for RGB, R, G, B and the hyper opponent transformed images
chafolder_name = {'RGB', 'R', 'G', 'B', 'O1', 'O2', 'O3', 'K', 'Sobel_R'};            % O1, O2 and O3 are the opponent transfored images; K is the grayscale image
for i = 1:length(chafolder_name)
    path_chafolder{1,i} = fullfile(directory_name_top, chafolder_name{1,i});
    if exist(path_chafolder{1,i},'dir') ~= 7
        mkdir(path_chafolder{1,i});
    end
end

% obtain the subfolders
subfolder = dir(directory_name);
ncount = 0;     % image counter

% hyper opponent transformation
for i = 1:length(subfolder)
    if ~strcmp(subfolder(i,1).name,'.') && ~strcmp(subfolder(i,1).name,'..')
        
        % create corresponding scene folder in "RGB", "R", "G", "B" folder
        for j = 1:length(chafolder_name)
            scenefolder{1,j} = fullfile(path_chafolder{1,j}, subfolder(i,1).name);
            
            if exist(scenefolder{1,j}, 'dir') ~= 7
                mkdir(scenefolder{1,j});
            end    
        end
                
        file = [];
        file1 =  dir(fullfile(directory_name,subfolder(i,1).name,'*.tiff'));     if ~isempty(file1) file = [file file1]; end
        file2 =  dir(fullfile(directory_name,subfolder(i,1).name,'*.jpg'));     if ~isempty(file2) file = [file file2]; end
        file3 =  dir(fullfile(directory_name,subfolder(i,1).name,'*.jpeg'));   if ~isempty(file3) file = [file file3]; end
        file4 =  dir(fullfile(directory_name,subfolder(i,1).name,'*.tif'));       if ~isempty(file4) file = [file file4]; end
        
        for j = 1:length(file)
            
            [pathstr, filename, ext] = fileparts(fullfile(directory_name,subfolder(i,1).name,file(j).name));    % obtain file name
            
            [A, map, alpha] = imread(fullfile(directory_name,subfolder(i,1).name,file(j).name));               % read the RGB image
            [img_h, img_w, nChannel] = size(A);
            if isempty(map)
                if nChannel == 3
                    rgb_img = A;
                    tmp_img = rgb_img(:,:,1) - rgb_img(:,:,2);    tmp_img1 = rgb_img(:,:,1) - rgb_img(:,:,3);
                    
                    if length(unique(tmp_img)) == 1 && length(unique(tmp_img1)) == 1
                        continue;
                    end
                    
                    ncount = ncount + 1;
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
                ncount = ncount + 1;
            end
           
            save_filename = filename;   % remain the original file name
            
            % save RGB, R, G and B images respectively
            imwrite(uint8(rgb_img), fullfile(scenefolder{1,1},[save_filename,'.jpg']),'jpg');
            imwrite(uint8(rgb_img(:,:,1)), fullfile(scenefolder{1,2},[save_filename,'.jpg']),'jpg');
            imwrite(uint8(rgb_img(:,:,2)), fullfile(scenefolder{1,3},[save_filename,'.jpg']),'jpg');
            imwrite(uint8(rgb_img(:,:,3)), fullfile(scenefolder{1,4},[save_filename,'.jpg']),'jpg');
            
            % cell array to store RGB image
            for k = 1:3
                comb_img{1,k} = rgb_img(:,:,k);
            end
            
            % opponent transformation
            decor_img = oppo_trans(comb_img, trans_matrix);
            
            % save the opponent transformed images
            for k = 1:3
                imwrite(uint8(decor_img{1,k}), fullfile(scenefolder{1,k+4},[save_filename,'.jpg']),'jpg');
            end
            
            % extract and save grayscale image
            gray = rgb2gray(rgb_img);
            imwrite(uint8(gray), fullfile(scenefolder{1,8},[save_filename,'.jpg']),'jpg');
            
            % extract and save "Sobel" image of "R" channel
            I_filter = rgb_img(:,:,1);  sobel = gradimg_obtain(I_filter, 1);    sobel = floor(mat2gray(sobel) * 255); % normalize Sobel image to [0 255]
            imwrite(uint8(sobel), fullfile(scenefolder{1,9},[save_filename,'.jpg']),'jpg');
            
            fprintf('Processing %s: wid %d, hgt %d, %d RGB images processed \n', filename, img_w, img_h, ncount);           
        end
    end
end
