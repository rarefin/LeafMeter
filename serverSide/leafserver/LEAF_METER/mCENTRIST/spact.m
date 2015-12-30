% Function: SPACT for mCENTRIST
% Input:
% feaData - mCENTRIST descriptor
% pca_num - number of chosen eigenvectors
% Output:
% vect - normalized chosen eigen vectors
% Author: Yang Xiao @ SCE NTU (hustcowboy@gmail.com)
% Created on 2012.6.14
% Last modified on 2014.1.13

function [vect] = spact(feaData, pca_num)

% data validation check
idx = isnan(feaData);
feaData(idx) = 1;

cov_matrix = feaData' * feaData;       %covariance matrix without subtracting mean

[vect, val] = eig(cov_matrix);             %obtain eigenvalue and eigenvectors of covariance matrix
val = diag(val);                                %obtain eigenvalue as one-dimensional vector
[junk, rindices] = sort(-1*val);           %sort "val" in decreasing order
val = val(rindices);
vect = vect(:,rindices);


 vect = vect(:,1:pca_num);

%normalize vect
[v_row, v_col] = size(vect);
for ii = 1:v_col
    vect_mean = mean(vect(:,ii));
    vect(:,ii) = vect(:,ii) - vect_mean;
    vect_mean = mean(vect(:,ii).*vect(:,ii));
    vect(:,ii) = vect(:,ii) / sqrt(vect_mean);
end


%%%vect=feaData; %%% WADUD