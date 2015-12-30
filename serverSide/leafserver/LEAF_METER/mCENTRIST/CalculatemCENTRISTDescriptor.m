% Function: extract mCENTRIST descriptor of the multi-channel images
% Input: 
% rt_img_dir               - image database root path
% rt_data_dir              - feature database root path
% pyramid_levl            - pyramid level of SPM
% maxImSize              - maximum size of the input image
% mCENTRIST_model - mCENTRIST extraction model
% Output: 
% database                 - directory for the calculated mCENTRIST descriptors
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Created on 2012.6.14
% Last modified on 2014.1.13

function [database] = CalculatemCENTRISTDescriptor(rt_img_dir, rt_data_dir, pyramid_levl, maxImSize, mCENTRIST_model)
% function [database] = CalculatemCENTRISTDescriptor(rt_img_dir, rt_data_dir, pyramid_levl, maxImSize, mCENTRIST_model,img_dir_mask)

disp('Extracting mCENTRIST descriptors...');

subfolders = dir(rt_img_dir{1,1});
nChannel = length(rt_img_dir);            % number of channels
database = [];
database.imnum = 0;                          % total image number of the database
database.cname = {};                         % name of each class
database.label = [];                             % label of each class
database.path = {};                             % contain the pathes for each image of each class
database.nclass = 0;
nCount = 0;                                       % image counter

for ii = 1:length(subfolders)
    
    subname = subfolders(ii).name;
    
    if ~strcmp(subname, '.') && ~strcmp(subname, '..'),
        
        database.nclass = database.nclass + 1;
        database.cname{database.nclass} = subname;
        frames = dir(fullfile(rt_img_dir{1,1}, subname, '*.jpg'));
%         frames_ann = dir(fullfile(rt_img_dir{1,1}, subname, '*.mat'));%%% this line
%         frames = dir(fullfile(rt_img_dir{1,1}, subname, '*.tif'));
% % % %     frames_mask = dir(fullfile(img_dir_mask{1,1}, subname, '*.jpg'));%% this line FLOWER
% % % %     frames_mask = dir(fullfile(img_dir_mask{1,1}, subname, '*.png'));%%% this line
        c_num = length(frames);
        database.imnum = database.imnum + c_num;
        database.label = [database.label; ones(c_num, 1)*database.nclass];
        
        catepath = fullfile(rt_data_dir, subname);
        if ~isdir(catepath),
            mkdir(catepath);
        end
        
        for jj = 1:c_num
            for kk = 1:nChannel
                imgpath = fullfile(rt_img_dir{1,kk}, subname, frames(jj).name);
                
% % %                 %%% this line
% % %                 annpath = fullfile(rt_img_dir{1,kk}, subname, frames_ann(jj).name);
% % %                 annot=load(annpath);
% % %                 left=annot.bbox.left;
% % %                 top=annot.bbox.top;
% % %                 right=annot.bbox.right;
% % %                 bottom=annot.bbox.bottom;
% % %                 %%% this line
                


% % % % % %                 %%% this line
% % %                 maskpath = fullfile(img_dir_mask{1,1}, subname, frames_mask(jj).name);
% % %                 Imask=imread(maskpath);
% % %                 if ndims(Imask)==3,
% % %                 Imask= double(rgb2gray(Imask));
% % %                 end
% % %                 aa=find(Imask<100);
% % %                 
% % %                 
% % % % % % % % % % % % % % % % % % % % % % %  


% % %                 %%% this line
% % %               
% % %                 Imask=imread(imgpath);
% % %                 if ndims(Imask)==3,
% % %                 Imask= double(rgb2gray(Imask));
% % %                 end
% % %                 tempI=Imask;
% % %                 temp=mode(mode(Imask));
% % %                 aa=find(Imask==temp);
% % %                 tempI(aa)=0;%%% aei line
% % %                  I=tempI;
% % %                 
% % % % % % % % % % % % % % % % % % % % % % % 




% % % % % %                 %%% this line FLOWER
% % %                 maskpath = fullfile(img_dir_mask{1,1}, subname, frames_mask(jj).name);
% % %                 Imask=imread(maskpath);
% % %                 if ndims(Imask)==3,
% % %                 Imask= double(rgb2gray(Imask));
% % %                 end
% % %    
% % %                 
% % %                 if length(unique(Imask)) == 1 
% % %                         I= imread(imgpath);
% % %                 else
% % %                 temp=mode(mode(Imask));
% % %                 aa=find(Imask==temp); 
% % %                 I= imread(imgpath);
% % %                 if ndims(I)==3,
% % %                 I= double(rgb2gray(I));
% % %                 end
% % %                 I(aa)=0;%%% aei line
% % %                 clearvars aa;
% % %                 end
   % % % % % % % % % % % % % % % % % % % % % % %   FLOWER






                I = imread(imgpath); %%% aei line NOT FOR FLOWER
                
                if ndims(I) == 3,
                    I = double(rgb2gray(I));
                else
                    I = double(I);
                end
% % % %                 I=imcrop(I,[left,top,(right-left),(bottom - top)]);%%% this line
% % % %                 I(aa)=0;%%% aei line
                


 % % % % % % % % % % % % % % % %  pfid                
%                 tempI=I;
%                 temp=mode(mode(I));
%                 aa=find(I==temp);
%                 tempI(aa)=0;%%% aei line
%                 [r,c,v] = find(tempI);
%                 xmin=min(r);
%                 ymin=min(c);
%                 height=max(r)-xmin;
%                 width=max(c)-ymin;
%                 tempI=imcrop(I,[ymin xmin width height]);
%                 I=tempI;
                

% % % % %                 if max(img_h, img_w) > maxImSize,
% % % %                     I = floor(imresize(I,[150 150], 'bicubic'));
%                 end;
                
                % % %                 tempI=
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % %                                 




                [img_h, img_w] = size(I);
                                
                if max(img_h, img_w) > maxImSize,
                    I = floor(imresize(I, maxImSize/max(img_h, img_w), 'bicubic'));
                end;
                
                [img_h, img_w] = size(I);
                
                % obtain SPM block images
                [block_img_tmp, spm_block_num] = spm_block_img(I, pyramid_levl);

                if kk == 1
                    [block_h, block_w] = size(block_img_tmp{1,1});  % height and width of spm block images
                    
                    block_img = cell(nChannel, spm_block_num);
                    for ll = 1:nChannel
                        for mm = 1:spm_block_num
                            block_img{ll, mm} = zeros(block_h, block_w);
                        end
                    end
                end
                
                for ll = 1:spm_block_num
                    block_img{kk,ll} = block_img_tmp{1,ll};
                end 
            end
            
            % extract mCENTRIST descriptor with SPM
            if mCENTRIST_model == 1 || mCENTRIST_model == 2
                [feaSet.feaArr] = mCENTRIST_spm(block_img, mCENTRIST_model);   % mCENTRIST extraction
            end
            
            if mCENTRIST_model == 1
                feaSet.feaPart = 2;
            elseif mCENTRIST_model == 2
                feaSet.feaPart = 2 * nchoosek(nChannel, 2);
            end
            
            [pdir, fname] = fileparts(frames(jj).name);
            fpath = fullfile(rt_data_dir, subname, [fname, '.mat']);
            save(fpath, 'feaSet');
            database.path = [database.path, fpath];
            
            nCount = nCount + 1;
            fprintf('Processing %s: wid %d, hgt %d, spm level %d, %d images Processed\n', frames(jj).name, img_w, img_h, pyramid_levl, nCount);
            
        end
    end
end

