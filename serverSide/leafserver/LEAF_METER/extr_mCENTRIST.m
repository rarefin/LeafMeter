% Function: extract and save mCENTRIST for the image dataset
% Input: img_dir                              - the root path of multi-channel images
%          data_dir                             - the root path for saving mCENTRIST
%          mCENTRIST_model            - mCENTRIST extraction model
% Output:
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Created on 2012.6.14
% Last modified on 2014.1.13

function extr_mCENTRIST(img_dir, data_dir, mCENTRIST_model)
% function extr_mCENTRIST(img_dir, data_dir, mCENTRIST_model,img_dir_mask)
addpath('mCENTRIST');     % the directory where mCENTRIST extraction function locate
pyramid_levl = 3;               % SPM level
maxImSize = 300;              % alll the images are resized to be no larger than 300 ¡Á 300

[database] = CalculatemCENTRISTDescriptor(img_dir, data_dir, pyramid_levl, maxImSize, mCENTRIST_model);
% [database1] = CalculatemCENTRISTDescriptor1(img_dir, data_dir, pyramid_levl, maxImSize, mCENTRIST_model);
% [database2] = CalculatemCENTRISTDescriptor2(img_dir, data_dir, pyramid_levl, maxImSize, mCENTRIST_model);
% [database] = CalculatemCENTRISTDescriptor(img_dir, data_dir, pyramid_levl, maxImSize, mCENTRIST_model,img_dir_mask);
