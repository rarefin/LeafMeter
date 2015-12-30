% Function: extract census transform index value for single channel image
% Input:
% I - single channel image
% Output:
% ct_idx - census transform index
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Created on 2012.7.20
% Last modified on 2012.7.20

function [ct_idx,forhisto,ct_idx_org_img] = census_idx(I,kkd,kkhv,l)
% % function [ct_idx,forhisto] = census_idx(I,kkd,kkhv,l)
[img_h, img_w] = size(I);

ct_idx = cell(1,8);
ct_idx{1,1} = zeros(img_h, img_w);  ct_idx{1,2} = zeros(img_h, img_w);  ct_idx{1,3} = zeros(img_h, img_w);  ct_idx{1,4} = zeros(img_h, img_w);
ct_idx{1,5} = zeros(img_h, img_w);  ct_idx{1,6} = zeros(img_h, img_w);  ct_idx{1,7} = zeros(img_h, img_w);  ct_idx{1,8} = zeros(img_h, img_w);


ct_idx_org_img = cell(1,8);
ct_idx_org_img{1,1} = zeros(img_h, img_w);  
ct_idx_org_img{1,2} = zeros(img_h, img_w);  
ct_idx_org_img{1,3} = zeros(img_h, img_w);  
ct_idx_org_img{1,4} = zeros(img_h, img_w);
ct_idx_org_img{1,5} = zeros(img_h, img_w);  
ct_idx_org_img{1,6} = zeros(img_h, img_w);  
ct_idx_org_img{1,7} = zeros(img_h, img_w);  
ct_idx_org_img{1,8} = zeros(img_h, img_w);




I_tmp = zeros(img_h, img_w);

%% Compute census transform value index
I_tmp(2:img_h, 2:img_w) = I(1:img_h-1, 1:img_w-1);
ct_idx{1,1}(2:img_h-1, 2:img_w-1) = I(2:img_h-1,2:img_w-1) - I_tmp(2:img_h-1,2:img_w-1);    %ct_idx{1,1} = (ct_idx{1,1}<=0);

ct_idx_org_img{1,1}(2:img_h-1, 2:img_w-1) = I_tmp(2:img_h-1,2:img_w-1);

I_tmp(2:img_h, 1:img_w) = I(1:img_h-1, 1:img_w);
ct_idx{1,2}(2:img_h-1, 2:img_w-1) = I(2:img_h-1,2:img_w-1) - I_tmp(2:img_h-1,2:img_w-1);    %ct_idx{1,2} = (ct_idx{1,2}<=0);

ct_idx_org_img{1,2}(2:img_h-1, 2:img_w-1) = I_tmp(2:img_h-1,2:img_w-1);

I_tmp(2:img_h, 1:img_w-1) = I(1:img_h-1, 2:img_w);
ct_idx{1,3}(2:img_h-1, 2:img_w-1) = I(2:img_h-1,2:img_w-1) - I_tmp(2:img_h-1,2:img_w-1);   % ct_idx{1,3} = (ct_idx{1,3}<=0);

ct_idx_org_img{1,3}(2:img_h-1, 2:img_w-1) = I_tmp(2:img_h-1,2:img_w-1);

I_tmp(1:img_h, 2:img_w) = I(1:img_h, 1:img_w-1);
ct_idx{1,4}(2:img_h-1, 2:img_w-1) = I(2:img_h-1,2:img_w-1) - I_tmp(2:img_h-1,2:img_w-1);   %ct_idx{1,4} = (ct_idx{1,4}<=0);

ct_idx_org_img{1,4}(2:img_h-1, 2:img_w-1) = I_tmp(2:img_h-1,2:img_w-1);

I_tmp(1:img_h, 1:img_w-1) = I(1:img_h, 2:img_w);
ct_idx{1,5}(2:img_h-1, 2:img_w-1) = I(2:img_h-1,2:img_w-1) - I_tmp(2:img_h-1,2:img_w-1);  % ct_idx{1,5} = (ct_idx{1,5}<=0);

ct_idx_org_img{1,5}(2:img_h-1, 2:img_w-1) = I_tmp(2:img_h-1,2:img_w-1);

I_tmp(1:img_h-1, 2:img_w) = I(2:img_h, 1:img_w-1);
ct_idx{1,6}(2:img_h-1, 2:img_w-1) = I(2:img_h-1,2:img_w-1) - I_tmp(2:img_h-1,2:img_w-1);   %ct_idx{1,6} = (ct_idx{1,6}<=0);

ct_idx_org_img{1,6}(2:img_h-1, 2:img_w-1) = I_tmp(2:img_h-1,2:img_w-1);

I_tmp(1:img_h-1, 1:img_w) = I(2:img_h, 1:img_w);
ct_idx{1,7}(2:img_h-1, 2:img_w-1) = I(2:img_h-1,2:img_w-1) - I_tmp(2:img_h-1,2:img_w-1);   %ct_idx{1,7} = (ct_idx{1,7}<=0);

ct_idx_org_img{1,7}(2:img_h-1, 2:img_w-1) = I_tmp(2:img_h-1,2:img_w-1);

I_tmp(1:img_h-1, 1:img_w-1) = I(2:img_h, 2:img_w);
ct_idx{1,8}(2:img_h-1, 2:img_w-1) = I(2:img_h-1,2:img_w-1) - I_tmp(2:img_h-1,2:img_w-1);   %ct_idx{1,8} = (ct_idx{1,8}<=0);

ct_idx_org_img{1,8}(2:img_h-1, 2:img_w-1) = I_tmp(2:img_h-1,2:img_w-1);


% % % % d = [ct_idx{1,1}(:),ct_idx{1,2}(:),ct_idx{1,3}(:),ct_idx{1,4}(:),ct_idx{1,5}(:),ct_idx{1,6}(:),ct_idx{1,7}(:),ct_idx{1,8}(:)];

d_diag = [ct_idx{1,1}(:),ct_idx{1,3}(:),ct_idx{1,6}(:),ct_idx{1,8}(:)];
d_vh =  [ct_idx{1,2}(:),ct_idx{1,4}(:),ct_idx{1,5}(:),ct_idx{1,7}(:)];
% forhisto1 = ( max(d,[],2) - min(d,[],2)).^(0.5);
% % if l<1
    
% % %     forhisto1 = ( max(d,[],2) - min(d,[],2));
    forhisto_d_diag = ( max(d_diag,[],2) - min(d_diag,[],2));
    forhisto_d_vh = ( max(d_vh,[],2) - min(d_vh,[],2));
%     forhisto1 = ( max(d,[],2) - min(d,[],2)).*(0.5);
    th_diag=(forhisto_d_diag.^(l)).*kkd;
    th_vh=(forhisto_d_vh.^(l)).*kkhv;
% % else
%     th=0;
%     forhisto1=ones(img_h*img_w,1) ;
% %       forhisto1 = ( max(d,[],2) - min(d,[],2));
% %       th=forhisto1.*kk;
% % end
%     A = th(:,ones(8, 1));
 ct_idx{1,1} = reshape(ct_idx{1,1}(:)>=th_diag,img_h, img_w);
 ct_idx{1,2} = reshape(ct_idx{1,2}(:)>=th_vh,img_h, img_w);
 ct_idx{1,3} = reshape(ct_idx{1,3}(:)>=th_diag,img_h, img_w);
 ct_idx{1,4} = reshape(ct_idx{1,4}(:)>=th_vh,img_h, img_w);
 ct_idx{1,5} = reshape(ct_idx{1,5}(:)>=th_vh,img_h, img_w);
 ct_idx{1,6} = reshape(ct_idx{1,6}(:)>=th_diag,img_h, img_w);
 ct_idx{1,7} = reshape(ct_idx{1,7}(:)>=th_vh,img_h, img_w);
 ct_idx{1,8} = reshape(ct_idx{1,8}(:)>=th_diag,img_h, img_w);
% % % %  forhisto=reshape(forhisto1,img_h, img_w);
forhisto=zeros(img_h, img_w);
%  figure (1); hold on;
%  imshow(uint8(forhisto));
%  figure (2); hold on;
%  imshow(uint8(I));
%  ct_idx;