%Function: L1 normalization for mCENTRIST
%Input:
% feaArr - mCENTRIST of the SPM block 
% patchSize - the patch size of BOV model
% model - mCENTRIST model
%Output:
%L1_feaArr - L1 normalized mCENTRIST
% Author: Yang Xiao @ SCE NTU (hustcowboy@gmail.com)
% Created on 2012.6.7
% Last modified on 2012.6.7

function [L1_feaArr] = L1_normalize(feaArr, patchsize, model)
    
if model == 1 || model == 2
    
    feaArr=sqrt(feaArr);
    
    feaMean = mean(feaArr);
    feaArr = feaArr - feaMean;
    
    sq = sum(feaArr.*feaArr);
    if sq > 50
        sq = 1 / sqrt(sq);
    else
        sq = 0;
    end
    L1_feaArr = feaArr * sq;     
end



