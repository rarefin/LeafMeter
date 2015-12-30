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

%%
Calculate_Color(); %**************
                          
img_dir ={'O1', 'O2', 'O3', 'Sobel_R'};       % directory for the image database          

data_dir = 'Leaf_Data';           % directory for saving mCENTRIST descriptors

%% mCENTRIST extraction and saving
extr_mCENTRIST(img_dir, data_dir, mCENTRIST_model);

%% Retrieve the directory of the mCENTRIST descriptor database
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
fprintf('\nProcessing...\n');

dFea = pca_num * fea_part * feaMat_h ;      % dimensionality of mCENTRIST (after PCA) 
vect = cell(1,fea_part);                                % SPCAT eigenvector
f_min = zeros(1,dFea);                               % min value of training feature in column
f_max = zeros(1,dFea);                              % max value of training feature in column    

clabel = unique(database.label);
nclass = length(clabel);
num_c = length(cc);                                   % number of 'cc'
c_chosen = zeros(1,nRounds);
accuracy = zeros(nRounds, 1); 

    
tr_idx = [];
ts_idx = [];

% generate sample split randomly
idx_label = find(database.label == clabel(1));
num = length(idx_label);

ts_idx = [ts_idx; idx_label(1)];

ts_split{1,1} = ts_idx;

part_dFea = feaMat_w / fea_part;

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

% open a file for writing
fid = fopen('Leaf_Output/Type.txt', 'w');
fprintf(fid, '%d', C);
fclose(fid);

fid = fopen('Leaf_Output/Knowledge.txt', 'w');
fprintf(fid, '%f', 100*d2p);
fclose(fid);
