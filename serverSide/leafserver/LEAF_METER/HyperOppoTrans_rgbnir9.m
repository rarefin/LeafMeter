% Function: execute the hyper opponent transformation on the RGB-NIR 9 class scene dataset
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Tips: The RGB-NIR 9 class scene dataset can be downloaded at http://www.cs.bath.ac.uk/brown/nirscene/nirscene.html
% Created on 2012.4.22
% Last modified on 2014.1.12 

clear;  close all;  clc;

%% Parameter setting
c_ratio = 1;                       % image resize ratio for covariance matrix extraction
nRounds = 5;                    % number of rounds of image sampling on the dataset
nSamImg = 42;                 % number of sampling images per round
nSamPixel = 2000;            % number of sampling pixels in each multi-channel image
nChannel = 4;                   % number of image channels

%% Path setting
% obtain the root path of the mixed RGB and NIR images
directory_name = uigetdir('F:\mCENTRIST_v1.0\mCENTRIST_v1.0','Mixed Images');
indx = strfind(directory_name,'\');
directory_name_top = directory_name(1:indx(end)-1);

cov_dir = 'cov';       %path for covariance matrix
path_cov = fullfile(directory_name_top, cov_dir);
if exist(path_cov, 'dir') ~= 7
    mkdir(path_cov);
end

vv_dir = 'vec_val';   %path for eigenvector and eigenvalue
path_vv = fullfile(directory_name_top, vv_dir);
if exist(path_vv, 'dir') ~= 7
    mkdir(path_vv);
end

%% Extract and save the covariance matrices of RGB-NIR images
disp('Covariance matrix extraction!');
[cov_matrix, label_matrix] =  cov_extraction_rgbnir(directory_name, path_cov, c_ratio, nSamPixel);

%% Opponent transformation matrix computation
disp('Opponent transformation matrix computation!');
nclass = label_matrix(length(label_matrix),1);     
clabel = 1:1:nclass;
vv_show = cell(1, nRounds);      % the eigen vectors computed from all the rounds
trans_matrxi = [ ];                 % the final opponent transformation matrix

for ii = 1:nRounds
    sam_idx = [];   % index of the sampled RGB-NIR images
    
    for jj = 1:nclass
        idx_label = find(label_matrix == clabel(jj));
        num = length(idx_label);
        idx_rand = randperm(num);
        sam_idx = [sam_idx; idx_label(idx_rand(1:nSamImg))];
    end
    
    f_cov = zeros(nChannel,nChannel);         % the covariance matrix of the sampled RGB-NIR image
    c_dim = 0;                                             % number of the sampled RGB-NIR pixels
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
% trans_matrix = [0.2516 0.2525 0.2484 0.2473; 0.1061 0.1317 0.2592 -0.5028; -0.4707 -0.0257 0.4022 0.1011; 0.2331 -0.4973 0.2313 0.0381]';  
%------------------------------------------------------------

%% Obtain the hyper opponent transformed images and save the results
disp('Hyper opponent transformation!');

% create folders for RGB, R, G, B, NIR and the hyper opponent transformed images
chafolder_name = {'RGB', 'R', 'G', 'B', 'NIR', 'O1', 'O2', 'O3', 'O4', 'K', 'Sobel_R'};           % O1, O2, O3 and O4 are the opponent transfored images; K is the grayscale image
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
        
        % create corresponding scene folder in "RGB", "R", "G", "B" and "NIR" folder
        for j = 1:length(chafolder_name)
            
            scenefolder{1,j} = fullfile(path_chafolder{1,j}, subfolder(i,1).name);
            
            if exist(scenefolder{1,j}, 'dir') ~= 7
                mkdir(scenefolder{1,j});
            end
        end
                
        file =  dir(fullfile(directory_name,subfolder(i,1).name,'*.tiff'));
        
        for j = 1:length(file)
      
            [pathstr, filename, ext] = fileparts(fullfile(directory_name,subfolder(i,1).name,file(j).name));    % obtain file name
            
            if strcmp(filename(length(filename)-2:length(filename)),'rgb')
                
                ncount = ncount + 1;
                [A, map, alpha] = imread(fullfile(directory_name,subfolder(i,1).name,file(j).name));            % read the RGB image
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
                
                % save RGB, R, G and B images separately
                imwrite(uint8(rgb_img), fullfile(scenefolder{1,1},[filename(1:length(filename)-4),'.jpg']),'jpg');
                imwrite(uint8(rgb_img(:,:,1)), fullfile(scenefolder{1,2},[filename(1:length(filename)-4),'.jpg']),'jpg');
                imwrite(uint8(rgb_img(:,:,2)), fullfile(scenefolder{1,3},[filename(1:length(filename)-4),'.jpg']),'jpg');
                imwrite(uint8(rgb_img(:,:,3)), fullfile(scenefolder{1,4},[filename(1:length(filename)-4),'.jpg']),'jpg');
                
                % read and save the corresponding NIR image
                nir_filename = filename;
                nir_filename(length(nir_filename)-2:length(nir_filename)) = 'nir';
                if ~exist(fullfile(directory_name,subfolder(i,1).name,[nir_filename,'.tiff']), 'file')
                    error('rbg and nir images are not matched');
                else
                    nir_img = imread(fullfile(directory_name,subfolder(i,1).name,[nir_filename,'.tiff']));
                     imwrite(uint8(nir_img), fullfile(scenefolder{1,5},[filename(1:length(filename)-4),'.jpg']),'jpg');
                end
                
                % cell array to store RGB-NIR image
                for k = 1:3
                    comb_img{1,k} = rgb_img(:,:,k);
                end
                comb_img{1,k+1} = nir_img;
                
                % opponent transformation
                decor_img = oppo_trans(comb_img, trans_matrix);
                    
                % save the opponent transformed image
                for k = 1:4
                     imwrite(uint8(decor_img{1,k}), fullfile(scenefolder{1,k+5},[filename(1:length(filename)-4),'.jpg']),'jpg');
                end
                
                 % extract and save grayscale image
                gray = rgb2gray(rgb_img);
                imwrite(uint8(gray), fullfile(scenefolder{1,10},[filename(1:length(filename)-4),'.jpg']),'jpg');
                
                % extract and save Sobel image of "R" channel
                I_filter = rgb_img(:,:,1);  sobel = gradimg_obtain(I_filter, 1);    sobel = floor(mat2gray(sobel) * 255);    % normalize Sobel image to [0 255]
                imwrite(uint8(sobel), fullfile(scenefolder{1,11},[filename(1:length(filename)-4),'.jpg']),'jpg');
                
                fprintf('Processing %s_%s: wid %d, hgt %d, %d RGB-NIR images processed \n', ...
                    subfolder(i,1).name, filename(1:length(filename)-4), img_w, img_h, ncount);              
            end           
        end
    end
end
