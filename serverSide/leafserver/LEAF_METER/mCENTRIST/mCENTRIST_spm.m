% Function: extract mCENTRIST with SPM structure
% Input:
% block_img - multi-channel SPM block images
% model - mCENTRIST extraction model (1-tip paper; 2-better performance can be achieved)
% Output:
% mCENTRIST - mCENTRIST descriptor with SPM structure
% Author: Yang Xiao @ C2I SCE NTU (hustcowboy@gmail.com)
% Created on 2012.7.20
% Last modified on 2014.1.13

function [mCENTRIST] = mCENTRIST_spm(block_img, model)

[n_channel, blk_num] = size(block_img);
[img_h, img_w] = size(block_img{1,1});

if model == 1   % this model is used in tip paper
    
%     dmCENTRIST = 512;       % mCENTRIST dimensionality
%     mCENTRIST = zeros(blk_num*nchoosek(n_channel,2), dmCENTRIST);


%%%%%%%%%%%%%%%%uporer dui line change 
% % % %     and nicher dui line add kora hoise


     dmCENTRIST = 256;       % mCENTRIST dimensionality
    mCENTRIST = zeros(blk_num*1, dmCENTRIST);



    ct_idx = cell(n_channel, blk_num);
    for ii = 1:n_channel
        for jj = 1:blk_num
            ct_idx{ii, jj} = cell(1,8);
            
            for kk = 1:8
                ct_idx{ii, jj}{1,kk} = zeros(img_h, img_w);
            end
        end
    end
    
    
    
    forhisto_idx = cell(n_channel, blk_num);
    for ii = 1:n_channel
        for jj = 1:blk_num
%             forhisto_idx{ii, jj} = cell(1,8);
%             
%             for kk = 1:8
% %                 forhisto_idx{ii, jj}{1,kk} = zeros(img_h, img_w);
                    forhisto_idx{ii, jj} = zeros(img_h, img_w);
%             end
        end
    end
    
    
    %% Extract single channel census transform index
%     if block_no_ii < 3
%     for ii = 1:1%n_channel
%         for jj = 1:1%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},1*ii);
%         end
%         
%         for jj = 2:5%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},4*ii);
%         end
%         
%         for jj = 6:6%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},2*ii);
%         end
%         for jj = 7:22%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},16*ii);
%         end
%         
%         for jj = 23:blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},8*ii);
%         end
%         
% 
%     end  

for ii = 1:n_channel
        for jj = 1:blk_num
            [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0,0,0);
        end
        
% %         for jj = 2:5%blk_num
% %             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0,0,0.5);
% %         end
% %         
% %         for jj = 6:6%blk_num
% %             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0,0,0.5);
% %         end
% %         for jj = 7:22%blk_num
% %             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0,0,0.5);
% %         end
% %         
% %         for jj = 23:blk_num
% %             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0,0,0.5);
% %         end
% %         

end 

% % % for ii = 2:3%n_channel
% % %         for jj = 1:1%blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.5,0.5,0.5);
% % %         end
% % %         
% % %         for jj = 2:5%blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.5,0.5,0.5);
% % %         end
% % %         
% % %         for jj = 6:6%blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.5,0.5,0.5);
% % %         end
% % %         for jj = 7:22%blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.5,0.5,0.5);
% % %         end
% % %         
% % %         for jj = 23:blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.5,0.5,0.5);
% % %         end
% % %         
% % % 
% % % end
% % % 
% % % 
% % % for ii = 4:n_channel
% % %         for jj = 1:1%blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.7,0.5);
% % %         end
% % %         
% % %         for jj = 2:5%blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.7,0.5);
% % %         end
% % %         
% % %         for jj = 6:6%blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.7,0.5);
% % %         end
% % %         for jj = 7:22%blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.7,0.5);
% % %         end
% % %         
% % %         for jj = 23:blk_num
% % %             [ct_idx{ii, jj},forhisto_idx{ii, jj},ct_idx_org_img{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.7,0.5);
% % %         end
% % %         
% % % 
% % % end


    


% for ii = 1:n_channel
%         for jj = 1:1%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.7,0.5);
%         end
%         
%         for jj = 2:5%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.7,0.5);
%         end
%         
%         for jj = 6:6%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.7,0.5);
%         end
%         for jj = 7:22%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.7,0.5);
%         end
%         
%         for jj = 23:blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.7,0.5);
%         end
%         
% 
%     end 



% for ii = 4:n_channel
    
%      for ii = 2:2%n_channel
%         for jj = 1:1%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.5);
%         end
%         
%         for jj = 2:5%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.5);
%         end
%         
%         for jj = 6:6%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.5);
%         end
%         for jj = 7:22%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.5);
%         end
%         
%         for jj = 23:blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.7,0.5);
%         end
%         
%      end
%         
% 
%      
%      for ii = 3:3%n_channel
%         for jj = 1:1%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.5);
%         end
%         
%         for jj = 2:5%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.5);
%         end
%         
%         for jj = 6:6%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.5);
%         end
%         for jj = 7:22%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.5);
%         end
%         
%         for jj = 23:blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.1,0.5);
%         end
%         
% 
%     end 
% % 
% % %     
%      for ii = 4:n_channel
%         for jj = 1:1%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.5,1);
%         end
%         
%         for jj = 2:5%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.5,1);
%         end
%         
%         for jj = 6:6%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.5,1);
%         end
%         for jj = 7:22%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.5,1);
%         end
%         
%         for jj = 23:blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},0.5,1);
%         end
%         
%      end

     
     
     
%     for ii = 5:n_channel
%     
%        
%         for jj = 1:1%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},1);
%         end
%         
%         for jj = 2:5%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},4);
%         end
%         
%         for jj = 6:6%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},2);
%         end
%         for jj = 7:22%blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},8);
%         end
%         
%         for jj = 23:blk_num
%             [ct_idx{ii, jj},forhisto_idx{ii, jj}] = census_idx(block_img{ii,jj},8);
%         end
%         
%     end
        
    
% % %  f_min = min(tr_fea);    f_max = max(tr_fea);    f_tmp = f_max-f_min;
% % %     r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
% % %     tr_fea = (tr_fea - repmat(f_min,length(tr_idx),1)).*repmat(r,length(tr_idx),1);

% % % % % % % % % % % % % % % % % % % das norm
% % % % for ii = 1:n_channel
% % % %     for kk=1:blk_num
% % % %         
% % % %         temp_forhisto= forhisto_idx{ii, kk}(:);
% % % %         f_min = min(temp_forhisto);    f_max = max(temp_forhisto);    f_tmp = f_max-f_min;
% % % %         r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
% % % %         forhisto_idx{ii, kk} = reshape((temp_forhisto - f_min).*(r*255),img_h, img_w);
% % % %     end
% % % % end














% end
    
    %% Extract mCENTRIST
%     chan_idx = zeros(1,2);   % channel index for mCENTRIST extraction
chan_idx = zeros(1,1);   % channel index for mCENTRIST extraction aei khane
    nCount = 1;
    
    for ii = 1:n_channel     
        chan_idx(1,1) = ii;
        
%         for jj = ii+1:n_channel
%             chan_idx(1,2) = jj;
        
            for kk = 1:blk_num
% % %                 mCENTRIST(nCount,:) = mCENTRIST_blk(ct_idx,forhisto_idx, chan_idx, kk, model, ct_idx_org_img);
                  mCENTRIST(nCount,:) = mCENTRIST_blk(ct_idx,forhisto_idx, chan_idx, kk, model);
                nCount = nCount + 1;
            end
%         end
    end
  
elseif model == 2      % '2' is different from '1' at the output data structure for PCA. (PCA is executed for each channel combination separately in '2')
    
    dmCENTRIST = 256 * 2 * nchoosek(n_channel,2);  % mCENTRIST dimensionality
    mCENTRIST = zeros(blk_num, dmCENTRIST);
    ct_idx = cell(n_channel,blk_num);
    for ii = 1:n_channel
        for jj = 1:blk_num
            ct_idx{ii, jj} = cell(1,8);
            
            for kk = 1:8
                ct_idx{ii, jj}{1,kk} = zeros(img_h, img_w);
            end
        end
    end
    
    %% Extract single channel census transform index
    for ii = 1:n_channel     
        nCount = 1;
        
        for jj = 1:blk_num
            [ct_idx{ii, jj}] = census_idx(block_img{ii,jj});
            nCount = nCount + 1;
        end
    end
    
    %% Extract mCENTRIST
    chan_idx = zeros(1,2);   % channel index for mCENTRIST extraction
    
    for kk = 1:blk_num
        nCount = 1;
        
        for ii = 1:n_channel      
            chan_idx(1,1) = ii;
            
            for jj = ii+1:n_channel
                chan_idx(1,2) = jj;               
                mCENTRIST(kk,(nCount-1)*512+1:nCount*512) = mCENTRIST_blk(ct_idx, chan_idx, kk, model);
                nCount = nCount + 1;
            end        
        end
    end    
end



