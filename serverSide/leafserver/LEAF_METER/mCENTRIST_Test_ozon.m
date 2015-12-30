% Function: scene categorization on the 8 class sports event dataset using mCENTRIST 
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Tips: this code is constructed based on the LLC code from Jianchao Yang @ UIUC at http://www.ifp.illinois.edu/~jyang29/LLC.htm
% Created on 2012.6.29
% Last modified on 2014.1.14
% filename='M:\mCENTRIST_v1.0\256 caltech\256_ObjectCategories\004.baseball-bat\004_0011.jpg';
clear; close all; clc;

%% Parameter setting
mCENTRIST_model = 1;      % mCENTRIST model ("1" is for TIP; "2" can generally achieve better result; they are different at the data structure for PCA)
pyramid = [1, 2, 4];             % SPM structure
pca_num = 40;                   % number of chosen eigenvectors in pca (40 - following CENTRIST)
nRounds = 5;                     % number of random train and test on the dataset
cc = power(2,-5);               % regularization parameter for linear SVM in LibSVM package
tr_num  = 40;                     % number of training examples per category
ts_num_max= 1;
ts_num_cat = 60;               % number of test examples per category 
tr_split = cell(1,nRounds);   % training sample index 
ts_split = cell(1,nRounds);   % test sample index
mem_block = 3000;            % maxmum number of testing features loaded each time

%% Path setting 
addpath('Libsvm/matlab');   % Libsvm package is used
addpath('mCENTRIST');     % the directory where mCENTRIST extraction function locate

% img_dir ={'image/8 class event/O1', 'image/8 class event/O2', 'image/8 class event/O3',...
%      'image/8 class event/Sobel_R'};       % directory for the image database                             
img_dir ={'C:\Users\admin\Desktop\Hackathon\Leaf_Sample'};       % directory for the image database          
% img_dir ={'image/8 class event/O1', 'image/8 class event/Sobel_R'};       % directory for the image database                             


data_dir = 'data/ozon/mCENTRIST/O1O2O3Sobel_m1';           % directory for saving mCENTRIST descriptors
split_dir = 'sample_split/scene';                                                % directory for training and test sample splits

%% mCENTRIST extraction and saving
extr_mCENTRIST(img_dir, data_dir, mCENTRIST_model);

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


    fprintf('Testing round: %d\n', 1);
    
    tr_idx = [];
    ts_idx = [];
    
%     % load sample split
%     fpath = fullfile(split_dir, ['sam_split', '.mat']);
%     load(fpath, 'sam_split');
%     tr_idx = sam_split.tr_split{1,ii};
%     ts_idx = sam_split.ts_split{1,ii};
    
    % generate sample split randomly
%     for jj = 1:nclass,         
        idx_label = find(database.label == clabel(1));
        num = length(idx_label);
%         rng(ii+jj);
%         idx_rand = randperm(num);
        
%         tr_idx = [tr_idx; idx_label(idx_rand(1:tr_num))];
%         ts_idx = [ts_idx; idx_label(idx_rand(tr_num+1:tr_num+ts_num_cat))];  
       
%             tr_idx = [tr_idx; idx_label((1:tr_num))];
            ts_idx = [ts_idx; idx_label(1)];
%         else
%             tr_idx = [tr_idx; idx_label(idx_rand(1:tr_num))];
%             ts_idx = [ts_idx; idx_label(idx_rand(tr_num+1:end))];
%         end   
%     end
    
    % restore sample split for train and test in each round
%     tr_split{1,1} = tr_idx;
    ts_split{1,1} = ts_idx;
    
% % %     tr_fea_ori = zeros(length(tr_idx)*feaMat_h, feaMat_w);
% % %     tr_fea = zeros(length(tr_idx), dFea);
% % %     tr_label = zeros(length(tr_idx), 1);
% % %     
% % %     for jj = 1:length(tr_idx)
% % %         fpath = database.path{tr_idx(jj)};  load (fpath);   fea = feaSet.feaArr;        
% % %         tr_fea_ori((jj-1)*feaMat_h+1:jj*feaMat_h, :) = fea;
% % %         
% % %         label = database.label(tr_idx(jj));  
% % %         tr_label(jj) = label;
% % %     end
% % %     
% % %     if 1 == 1
        part_dFea = feaMat_w / fea_part;
% % %         
% % %         for jj = 1:fea_part
% % %             vect{1,jj} = spact(tr_fea_ori(: , (jj-1)*part_dFea+1:jj*part_dFea), pca_num);    % PCA % aei khane change korsi pca nai
% % %         end
% % %     end
% % %     
% % %     for jj = 1:length(tr_idx)
% % %         for kk = 1:fea_part
% % %             tr_fea_tmp = tr_fea_ori(feaMat_h*(jj-1)+1:feaMat_h*jj, (kk-1)*part_dFea+1:kk*part_dFea) * vect{1,kk};
% % %             tr_fea(jj, pca_num*feaMat_h*(kk-1)+1:pca_num*feaMat_h*kk) = reshape(tr_fea_tmp, 1, pca_num*feaMat_h);
% % % % % tr_fea(jj, pca_num*feaMat_h*(kk-1)+1:pca_num*feaMat_h*kk) = reshape(tr_fea_tmp, 1, pca_num*feaMat_h); %%% aei khane chang
% % %         end
% % %     end
% % %     
% % %     clear tr_fea_ori;   clear tr_fea_tmp;
% % %     
% % %     % feature normalization
% % %     f_min = min(tr_fea);    f_max = max(tr_fea);    f_tmp = f_max-f_min;
% % %     r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
% % %     tr_fea = (tr_fea - repmat(f_min,length(tr_idx),1)).*repmat(r,length(tr_idx),1);
% % %     
% % %     c_chosen(1) = 1;
% % %     options = [ '-s 0 -t 0 ' '-g ' num2str(power(2, -7)) ' -c ' num2str(cc(c_chosen(1)))];      % Libsvm parameter setting (linear SVM is used)
% % %     model = svmtrain(double(tr_label), sparse(tr_fea), options);                                      
% % %     clear tr_fea;
% % %     
    
% % %     save model and load model
% fpath = fullfile(rt_data_dir, subname, [fname, '.mat']);
%             save(fpath, 'feaSet');
% save('model','model');
% % % save('model');
% % % save('vect');
load('model.mat');
load('vect.mat');
    % load the testing features
    ts_num = length(ts_idx);    ts_label = [ ];
    
   
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
        
        f_min = min(ts_fea);    f_max = max(ts_fea);    f_tmp = f_max-f_min;
    r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
        
        ts_fea = (ts_fea - repmat(f_min,length(ts_idx),1)).*repmat(r,length(ts_idx),1);     % normalize the test feature    
        [C, Acc, d2p] = svmpredict(double(ts_label), sparse(ts_fea), model);                % svm test 
        clear ts_fea;
        
    
    % normalize the classification accuracy by averaging over different classes
    acc = zeros(nclass, 1);
    
    for jj = 1 : nclass,
        c = clabel(jj);
        idx = find(ts_label == c);
        curr_pred_label = C(idx);
        curr_gnd_label = ts_label(idx);
        acc(jj) = length(find(curr_pred_label == curr_gnd_label))/length(idx);
    end
    accusvm(1)=Acc(1);
    accuracy(1) = mean(acc);
    fid = fopen('FixedRandom_svm_accu_samsung_scene.txt', 'a');
fprintf(fid,'round %d accuracy: %.2f\n', 1, accusvm(1));
fclose(fid);


% Ravg = mean(accuracy);                  % average recognition rate
% Rstd = std(accuracy);                       % standard deviation of the recognition rate
% svmaccu=mean(accusvm); 
% fprintf('Average accuracy: %.2f, Standard deviation: %.2f \n', Ravg*100, Rstd*100);
% 
% fid = fopen('FixedRandom_svm_accu_samsung_scene.txt', 'a');
% fprintf(fid,'Average accuracy: %.2f, Standard deviation: %.2f svmaccu: %.2f\n', Ravg*100, Rstd*100,svmaccu);
% fclose(fid);
%% save sample split for train and test
% sam_split = struct;
% sam_split.tr_split = tr_split;
% sam_split.ts_split = ts_split;
% fpath = fullfile(split_dir, ['sam_split', '.mat']);
% if ~isdir(split_dir),
%     mkdir(split_dir);
% end
% save(fpath, 'sam_split');
