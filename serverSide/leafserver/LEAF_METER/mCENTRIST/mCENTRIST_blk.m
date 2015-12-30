% Function: extract mCENTRIST for the SPM block
% Input:
% ct_idx - census transform index of multi-channel SPM block images
% spec_idx - channel index for mCENTRIST extraction
% blk_idx - block index
% model - mCENTRIST extraction model
% Output:
% ct_hist - mCENTRIST descriptor of the SPM block
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Created on 2012.7.5
% Last modified on 2013.4.7

% % % function [ct_hist] = mCENTRIST_blk(ct_idx,forhisto_idx, spec_idx, blk_idx, model, ct_idx_org_img)

function [ct_hist] = mCENTRIST_blk(ct_idx,forhisto_idx, spec_idx, blk_idx, model)

[n_channel, blk_num] = size(ct_idx);
n_channel = length(spec_idx);
[img_h, img_w] = size(ct_idx{1,blk_idx}{1,1});
l_bound = 0;  
% h_bound = power(16, n_channel) - 1;  
h_bound = power(16, 2) - 1;  
if model == 1 || model == 2  % extract mCENTRIST in the directions of diagonal and ver&hori respectively
    
    ct_diag = zeros(img_h, img_w);
    ct_vh = zeros(img_h, img_w);
    
    for ii = 1:n_channel       
        %% mCENTRIST in diagonal direction
        ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,1} * power(2,0); 
        ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,3} * power(2,2);
        ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,6} * power(2,5); 
        ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,8} * power(2,7);
        
        %% mCENTRIST in vertical and horizontal direction
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,2} * power(2,1); 
        ct_vh = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,2} * power(2,1); 
        ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,4} * power(2,3);
        ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,5} * power(2,4); 
        ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,7} * power(2,6);     
        
    end
% % %     
% % % %     d1 = [ct_idx_org_img{spec_idx(1,1), blk_idx}{1,1}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,3}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,6}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,8}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,1}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,3}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,6}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,8}(:)];
% % % %     
% % % %     ct_forhisto1 = ( max(d1,[],2) - min(d1,[],2));
% % % % 
% % % %     d2 = [ct_idx_org_img{spec_idx(1,1), blk_idx}{1,2}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,4}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,5}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,7}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,2}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,4}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,5}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,7}(:)];
% % % %     
% % % %     ct_forhisto2 = ( max(d2,[],2) - min(d2,[],2));


% % %     d11 = [ct_idx_org_img{spec_idx(1,1), blk_idx}{1,1}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,3}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,6}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,8}(:)];
% % %     d12=  [ ct_idx_org_img{spec_idx(1,2), blk_idx}{1,1}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,3}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,6}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,8}(:)];
% % %     ct_forhisto11 = ( max(d11,[],2) - min(d11,[],2));
% % %     ct_forhisto12 = ( max(d12,[],2) - min(d12,[],2));
% % % 
% % %     d21 = [ct_idx_org_img{spec_idx(1,1), blk_idx}{1,2}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,4}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,5}(:),ct_idx_org_img{spec_idx(1,1), blk_idx}{1,7}(:)] ;
% % %     d22= [ ct_idx_org_img{spec_idx(1,2), blk_idx}{1,2}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,4}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,5}(:),ct_idx_org_img{spec_idx(1,2), blk_idx}{1,7}(:)];
% % %     ct_forhisto21 = ( max(d21,[],2) - min(d21,[],2));
% % %     ct_forhisto22 = ( max(d22,[],2) - min(d22,[],2));



% % % %     for ii = 1:n_channel
% % % %     for kk=1:blk_num
% % % %         
% % % %         temp_forhisto= forhisto_idx{ii, kk}(:);
% % % %         f_min = min(temp_forhisto);    f_max = max(temp_forhisto);    f_tmp = f_max-f_min;
% % % %         r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
% % % %         forhisto_idx{ii, kk} = reshape((temp_forhisto - f_min).*(r*255),img_h, img_w);
% % % %     end
% % % % end
    
% % % %         f_min = min(ct_forhisto11);    f_max = max(ct_forhisto11);    f_tmp = f_max-f_min;
% % % %         r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
% % % %         ct_forhisto11 = (ct_forhisto11 - f_min).*(r*255);
% % % %         
% % % %         f_min = min(ct_forhisto12);    f_max = max(ct_forhisto12);    f_tmp = f_max-f_min;
% % % %         r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
% % % %         ct_forhisto12 = (ct_forhisto12 - f_min).*(r*255);
        
% % % %         ct_forhisto1=(ct_forhisto11+ct_forhisto12)./2;
        
        
        
        
        
% % %         f_min = min(ct_forhisto21);    f_max = max(ct_forhisto21);    f_tmp = f_max-f_min;
% % %         r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
% % %         ct_forhisto21 = (ct_forhisto21 - f_min).*(r*255);
% % %         
% % %         f_min = min(ct_forhisto22);    f_max = max(ct_forhisto22);    f_tmp = f_max-f_min;
% % %         r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
% % %         ct_forhisto22 = (ct_forhisto22 - f_min).*(r*255);
        
% % % %         ct_forhisto2=(ct_forhisto21+ct_forhisto22)./2;
        
        
% % %     forhisto=reshape(forhisto1,img_h, img_w);

% % % for ii = 1:n_channel       
% % %     if ii == 1 
% % %         %% mCENTRIST in diagonal direction
% % %         ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,1} * power(2,0);  
% % %         ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,2} * power(2,1);
% % %         ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,3} * power(2,2);  
% % %         ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,4} * power(2,3);
% % %         ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,5} * power(2,4);  
% % %         ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,6} * power(2,5);
% % %         ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,7} * power(2,6);  
% % %         ct_diag = ct_diag + ct_idx{spec_idx(1,ii), blk_idx}{1,8} * power(2,7);
% % %     else
% % %         %% mCENTRIST in vertical and horizontal direction
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,1} * power(2,0); 
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,2} * power(2,1);
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,3} * power(2,2);  
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,4} * power(2,3); 
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,5} * power(2,4); 
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,6} * power(2,5);
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,7} * power(2,6);  
% % %         ct_vh = ct_vh + ct_idx{spec_idx(1,ii), blk_idx}{1,8} * power(2,7);  
% % %     end
% % % end
    
    
    
% %     ct_forhisto = zeros(img_h, img_w);
% % %     ct_vh_forhisto = zeros(img_h, img_w);
    
% %     for ii = 1:n_channel       
% %         %% mCENTRIST in diagonal direction
% %         ct_forhisto = ct_forhisto + forhisto_idx{spec_idx(1,ii), blk_idx} ;     
% %     end
    
    
    
% % %         ct_forhisto1 = zeros(img_h, img_w);
% % %         ct_forhisto2 = zeros(img_h, img_w);
% % % 
% % %         ct_forhisto1 = ct_forhisto1 + forhisto_idx{spec_idx(1,1), blk_idx} ;     
% % %         ct_forhisto2 = ct_forhisto2 + forhisto_idx{spec_idx(1,2), blk_idx} ; 


% ct_forhisto1 = ct_forhisto1./mean(mean(ct_forhisto1));
% ct_forhisto2    = ct_forhisto2./mean(mean(ct_forhisto2));
    %% Delete homogeneous component in mCENTRIST
%     idx_diag_l = (ct_diag == l_bound);



% % % % % % % % % % % % figure (1); hold on;
% % % % % % % % % % % % imshow(uint8(ct_vh));

    idx_vh_l = (ct_vh == l_bound);
%     idx_l = idx_diag_l & idx_vh_l;
    idx_l = idx_vh_l;
%     
%     idx_diag_h = (ct_diag == h_bound);
    idx_vh_h = (ct_vh == h_bound);
%     idx_h = idx_vh_h & idx_diag_h;
    idx_h = idx_vh_h;
%     
% %     ct_diag(idx_l) = -1;
% %     ct_diag(idx_h) = -1; 
% % % % %     ct_diag = reshape(ct_diag,  img_h*img_w, 1);
    ct_vh(idx_l) = -1;
    ct_vh(idx_h) = -1; 
    ct_vh = reshape(ct_vh, img_h*img_w, 1);
    
% %     ct_forhisto = reshape(ct_forhisto, img_h*img_w, 1);
    
% % % ct_forhisto1 = reshape(ct_forhisto1, img_h*img_w, 1);
% % % ct_forhisto2 = reshape(ct_forhisto2, img_h*img_w, 1);

% % %     ct_diag = ct_diag + 1;
    ct_vh = ct_vh + 1;
    
% % %     idx = 1:1:power(16, n_channel);
        idx = 1:1:power(16, 2);
%     ct_diag_hist = hist(ct_diag, idx); ct_diag_hist(1,1) = ct_diag_hist(1,1) - sum(sum(idx_l)) - sum(sum(idx_h));
    ct_vh_hist = hist(ct_vh, idx); ct_vh_hist(1,1) = ct_vh_hist(1, 1) - sum(sum(idx_l)) - sum(sum(idx_h));
    
% % % %     temp1=lbp_histo_samsung(idx,ct_diag,ct_forhisto1);
% % % %     ct_diag_hist=temp1';
% % % %     temp2=lbp_histo_samsung(idx,ct_vh,ct_forhisto2);
% % % %     ct_vh_hist=temp2';
    %%%%%%%%%apatoto%%%
% % % idx = 1:1:power(16, 2);

% %     temp1=lbp_histo_samsung(idx,ct_diag,ct_forhisto1);
% %     ct_diag_hist=temp1';
% %     temp2=lbp_histo_samsung(idx,ct_vh,ct_forhisto2);
% %     ct_vh_hist=temp2';
    
    
    
%     ct_diag_hist = L1_normalize(ct_diag_hist, 1, model);
    
    ct_vh_hist = L1_normalize(ct_vh_hist, 1, model);
% %     ct_hist = [ct_diag_hist ct_vh_hist];     %%% aei khane
ct_hist = [ct_vh_hist];    
end
