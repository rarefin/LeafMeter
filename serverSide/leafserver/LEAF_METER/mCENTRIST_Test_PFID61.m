% Function: scene categorization on the 67 class indoor scene dataset using mCENTRIST 
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Tips: this code is constructed based on the LLC code from Jianchao Yang @ UIUC at http://www.ifp.illinois.edu/~jyang29/LLC.htm
% Created on 2012.6.29
% Last modified on 2014.1.14

clear; close all; clc;

%% Parameter setting
mCENTRIST_model = 1;      % mCENTRIST model ("1" is for TIP; "2" can generally achieve better result; they are different at the data structure for PCA)
pyramid = [1, 2, 4];             % SPM structure
pca_num = 40;                   % number of chosen eigenvectors in pca (40 - following CENTRIST)
nRounds = 5;                     % number of random train and test on the dataset
cc = power(2,-5);               % regularization parameter for linear SVM in LibSVM package
tr_num  = 12;                     % number of training examples per category
ts_num_max = 1000;              % maximum number of test examples per category 
tr_split = cell(1,nRounds);   % training sample index 
ts_split = cell(1,nRounds);   % test sample index
mem_block = 3000;            % maxmum number of testing features loaded each time

%% Path setting 
addpath('Libsvm/matlab');   % Libsvm package is used
addpath('mCENTRIST');     % the directory where mCENTRIST extraction function locate

% img_dir ={'image/67 class indoor/O1', 'image/67 class indoor/O2', 'image/67 class indoor/O3',...
%      'image/67 class indoor/Sobel_R'};       % directory for the image database                             
% 101_ObjectCategories
 
img_dir ={'F:\CENTRIST gray_scale\image\foodPFID'};       % directory for the image database                             
data_dir = 'data/foodPFID/mCENTRIST/O1O2O3Sobel_m1';           % directory for saving mCENTRIST descriptors
split_dir = 'sample_split/foodPFID';                                                % directory for training and test sample split

%% mCENTRIST extraction and saving
% extr_mCENTRIST(img_dir, data_dir, mCENTRIST_model);

%% Retrieve the directory of the mCENTRIST descriptor database
fprintf('dir the database...');

database = retr_database_dir(data_dir);

if isempty(database),
    error('Data directory error!');
end

%% Achieve mCENTRIST extraction information for PCA and classification
feaMat_w = 0;       % mCENTRIST feature matrix width
feaMat_h = 0;       % mCENTRIST feature matrix height (the row corresponds to feature vector)
fea_part = 0;        % number of mCENTRIST feature parts for PCA

fpath = database.path{1};   load(fpath);

[feaMat_h, feaMat_w] = size(feaSet.feaArr);  fea_part =  feaSet.feaPart;

%% Train and test
fprintf('\nTesting...\n');

dFea = pca_num * fea_part * feaMat_h ;      % dimensionality of mCENTRIST (after PCA) 
vect = cell(1,fea_part);                                % SPCAT eigenvector
f_min = zeros(1,dFea);                               % min value of training feature in column
f_max = zeros(1,dFea);                              % max value of training feature in column    

clabel = unique(database.label);
nclass = length(clabel);
num_c = length(cc);                                   % number of 'cc'
c_chosen = zeros(1,nRounds);
accuracy = zeros(nRounds, 1); 

for ii = 1:nRounds,
    fprintf('Testing round: %d\n', ii);
    
    tr_idx = [];
    ts_idx = [];
    
%     % load sample split
%     fpath = fullfile(split_dir, ['sam_split', '.mat']);
%     load(fpath, 'sam_split');
%     tr_idx = sam_split.tr_split{1,ii};
%     ts_idx = sam_split.ts_split{1,ii};
    
    % generate sample split randomly
    for jj = 1:nclass,
        
        idx_label = find(database.label == clabel(jj));
        num = length(idx_label);
        rng(ii+jj);
        idx_rand = randperm(num);
        
        
        
%                 idx_rand = 1:num; 
% idx_rand = [1:6 13:18 7:12];
idx_rand = [ 7:12 13:18 1:6];

        if num > tr_num + ts_num_max
            tr_idx = [tr_idx; idx_label(idx_rand(1:tr_num))];
            ts_idx = [ts_idx; idx_label(idx_rand(tr_num+1:tr_num+ts_num_max))];
        else
            tr_idx = [tr_idx; idx_label(idx_rand(1:tr_num))];
            ts_idx = [ts_idx; idx_label(idx_rand(tr_num+1:end))];
        end    
    end
    
    % restore sample split for train and test in each round
    tr_split{1,ii} = tr_idx;
    ts_split{1,ii} = ts_idx;
    
    tr_fea_ori = zeros(length(tr_idx)*feaMat_h, feaMat_w);
    tr_fea = zeros(length(tr_idx), dFea);
    tr_label = zeros(length(tr_idx), 1);
    
    for jj = 1:length(tr_idx)
        fpath = database.path{tr_idx(jj)};  load (fpath);   fea = feaSet.feaArr;        
        tr_fea_ori((jj-1)*feaMat_h+1:jj*feaMat_h, :) = fea;
        
        label = database.label(tr_idx(jj));  
        tr_label(jj) = label;
    end
    
    if ii == 1
        part_dFea = feaMat_w / fea_part;
        
        for jj = 1:fea_part
            vect{1,jj} = spact(tr_fea_ori(: , (jj-1)*part_dFea+1:jj*part_dFea), pca_num);    % PCA
        end
    end
    
    for jj = 1:length(tr_idx)
        for kk = 1:fea_part
            tr_fea_tmp = tr_fea_ori(feaMat_h*(jj-1)+1:feaMat_h*jj, (kk-1)*part_dFea+1:kk*part_dFea) * vect{1,kk};
            tr_fea(jj, pca_num*feaMat_h*(kk-1)+1:pca_num*feaMat_h*kk) = reshape(tr_fea_tmp, 1, pca_num*feaMat_h);
        end
    end
    
    clear tr_fea_ori;   clear tr_fea_tmp;
    
    % feature normalization
    f_min = min(tr_fea);    f_max = max(tr_fea);    f_tmp = f_max-f_min;
    r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
    tr_fea = (tr_fea - repmat(f_min,length(tr_idx),1)).*repmat(r,length(tr_idx),1);
    
    c_chosen(ii) = 1;
    options = [ '-s 0 -t 0 ' '-g ' num2str(power(2, -7)) ' -c ' num2str(cc(c_chosen(ii)))];      % Libsvm parameter setting (linear SVM is used)
    model = svmtrain(double(tr_label), sparse(tr_fea), options);                                      
    clear tr_fea;
    
    % load the testing features
    ts_num = length(ts_idx);    ts_label = [ ];
    
    if ts_num < mem_block,
        % load the testing features directly into memory for test
        ts_fea = zeros(length(ts_idx), dFea);
        ts_label = zeros(length(ts_idx), 1);
        
        for jj = 1:length(ts_idx)
            fpath = database.path{ts_idx(jj)};      load(fpath);        fea = feaSet.feaArr;     
            label = database.label(ts_idx(jj));      ts_label(jj) = label;
            
            for kk = 1:fea_part
                ts_fea_tmp = fea(:, (kk-1)*part_dFea+1:kk*part_dFea) * vect{1,kk};
                ts_fea(jj, pca_num*feaMat_h*(kk-1)+1:pca_num*feaMat_h*kk) = reshape(ts_fea_tmp, 1, pca_num*feaMat_h);
            end
        end
        clear ts_fea_tmp;
        
        ts_fea = (ts_fea - repmat(f_min,length(ts_idx),1)).*repmat(r,length(ts_idx),1);     % normalize the test feature    
        [C, Acc, d2p] = svmpredict(double(ts_label), sparse(ts_fea), model);                % svm test 
        clear ts_fea;
        
    else       
        % load the testing features block by block
        num_block = floor(ts_num/mem_block);
        rem_fea = rem(ts_num, mem_block);
        
        curr_ts_fea = zeros(mem_block, dFea);
        curr_ts_label = zeros(mem_block, 1);
        
        C = [];
        
        for jj = 1:num_block,        
            block_idx = (jj-1)*mem_block + (1:mem_block);   
            curr_idx = ts_idx(block_idx);
            
            % load the current block of features
            for kk = 1:mem_block,
                fpath = database.path{curr_idx(kk)};    load (fpath);   fea = feaSet.feaArr;       
                label = database.label(curr_idx(kk));    curr_ts_label(kk) = label;
                
                for ll = 1:fea_part
                    ts_fea_tmp = fea(:, (ll-1)*part_dFea+1:ll*part_dFea) * vect{1,ll};
                    curr_ts_fea(kk, pca_num*feaMat_h*(ll-1)+1:pca_num*feaMat_h*ll) = reshape(ts_fea_tmp, 1, pca_num*feaMat_h);
                end
            end
            clear ts_fea_tmp;
            
            curr_ts_fea = (curr_ts_fea - repmat(f_min,mem_block,1)).*repmat(r,mem_block,1);       % normalize the test feature
            
            % test the current block features
            ts_label = [ts_label; curr_ts_label];
            [curr_C, Acc, d2p] = svmpredict(double(curr_ts_label), sparse(curr_ts_fea), model);     % svm test
            C = [C; curr_C];
        end
        clear curr_ts_fea;
        
        curr_ts_fea = zeros(rem_fea, dFea);
        curr_ts_label = zeros(rem_fea, 1);
        curr_idx = ts_idx(num_block*mem_block + (1:rem_fea));
        
        for kk = 1:rem_fea,
            fpath = database.path{curr_idx(kk)};    load (fpath);   fea = feaSet.feaArr;
            label = database.label(curr_idx(kk));    curr_ts_label(kk) = label;
            
            for ll = 1:fea_part
                ts_fea_tmp = fea(:, (ll-1)*part_dFea+1:ll*part_dFea) * vect{1,ll};
                curr_ts_fea(kk, pca_num*feaMat_h*(ll-1)+1:pca_num*feaMat_h*ll) = reshape(ts_fea_tmp, 1, pca_num*feaMat_h);
            end
        end
        clear ts_fea_tmp;
        
        curr_ts_fea = (curr_ts_fea - repmat(f_min,rem_fea,1)).*repmat(r,rem_fea,1);                % normalize the test feature
        
        % test the current block features
        ts_label = [ts_label; curr_ts_label];
        [curr_C, Acc, d2p] = svmpredict(double(curr_ts_label), sparse(curr_ts_fea), model);     % svm test
        C = [C; curr_C];
        clear curr_ts_fea;  
    end
    
    % normalize the classification accuracy by averaging over different classes
    acc = zeros(nclass, 1);
    
    for jj = 1 : nclass,
        c = clabel(jj);
        idx = find(ts_label == c);
        curr_pred_label = C(idx);
        curr_gnd_label = ts_label(idx);
        acc(jj) = length(find(curr_pred_label == curr_gnd_label))/length(idx);
    end
    accusvm(ii)=Acc(1);    
    accuracy(ii) = mean(acc);
    
fid = fopen('FixedRandom_svm_accu_samsung_scene.txt', 'a');
fprintf(fid,'round %d accuracy: %.2f\n', ii, accusvm(ii) );
fclose(fid);
    
end

Ravg = mean(accuracy);                  % average recognition rate
Rstd = std(accuracy);                       % standard deviation of the recognition rate
svmaccu=mean(accusvm); 

fprintf('Average accuracy: %.2f, Standard deviation: %.2f \n', Ravg*100, Rstd*100);
fid = fopen('FixedRandom_svm_accu_samsung_scene.txt', 'a');
fprintf(fid,'Average accuracy: %.2f, Standard deviation: %.2f svmaccu: %.2f\n', Ravg*100, Rstd*100,svmaccu);
fclose(fid);

%% save sample split for train and test
% sam_split = struct;
% sam_split.tr_split = tr_split;
% sam_split.ts_split = ts_split;
% fpath = fullfile(split_dir, ['sam_split', '.mat']);
% if ~isdir(split_dir),
%     mkdir(split_dir);
% end
% save(fpath, 'sam_split');
