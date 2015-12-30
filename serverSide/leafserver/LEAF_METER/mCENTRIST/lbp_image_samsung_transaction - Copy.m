% Local binary patterns 
function [out,forhisto]=lbp_image_samsung_transaction(in,type,kk)
% function [H]=lbp_image_samsung_transaction(in,type)
% in=imfilter(in,ones(2,2)/4,'replicate');
% figure(1); hold on;
% imshow(uint8(in));

[rows,cols]=size(in);


   r=rows+4;
   c=cols+4;
   A = zeros(r,c);
   B=zeros(r,c);
   r0=3:r-2;
   c0=3:c-2;
   A(r0,c0) = in;

%    radius 2 interpolation coefficients for +-45 degree lines
%    alpha = 2-sqrt(2);
% %    alpha = 0.5;
%    beta = 1-alpha;


%    d0 = A(r0,c0-2) - in;
%    d2 = A(r0+2,c0) - in;
%    d4 = A(r0,c0+2) - in;
%    d6 = A(r0-2,c0) - in;
%    d1 = alpha*A(r0+1,c0-1) + beta*A(r0+2,c0-2) - in;
%    d3 = alpha*A(r0+1,c0+1) + beta*A(r0+2,c0+2) - in;
%    d5 = alpha*A(r0-1,c0+1) + beta*A(r0-2,c0+2) - in;
%    d7 = alpha*A(r0-1,c0-1) + beta*A(r0-2,c0-2) - in;

   d0 = A(r0,c0-1) - in;
   d2 = A(r0+1,c0) - in;
   d4 = A(r0,c0+1) - in;
   d6 = A(r0-1,c0) - in;
   d1 = A(r0+1,c0-1)  - in;
   d3 = A(r0+1,c0+1)  - in;
   d5 = A(r0-1,c0+1)  - in;
   d7 = A(r0-1,c0-1)  - in;


   d = [d0(:),d1(:),d2(:),d3(:),d4(:),d5(:),d6(:),d7(:)];
   
%    temp=zeros(size(d,1),8);
% 
%    code = 2.^(7:-1:0)';
%    dd=d';
%    forhisto1=(max(dd)-min(dd))^0.5;
%     th=forhisto1 ;
%       for i=1:size(d,1)
%         for j=1:8
%        temp(i,j)=(d(i,j))>=th(i);
%         end
%       end
   


%  temp=zeros(size(d,1),8);

   code = 2.^(7:-1:0)';
%    dd=d';
%    forhisto1=sqrt(max(dd)-min(dd));

if kk~=0
   forhisto1 = ( max(d,[],2) - min(d,[],2)).^(0.5);
    th=forhisto1/kk;

     A = th(:,ones(8, 1));
     forhisto = reshape(forhisto1,rows,cols);
else
%     forhisto1=ones(size(d,1),1);
    A=0;
    forhisto=1;
end
%    temp=d>=A;
   
      

out = reshape((d>=A)*code,rows,cols); %sho
%    forhisto = reshape(forhisto1,rows,cols);
   
   
%    out = reshape((d>=0)*code,rows,cols);

   
%    figure(1);hold on;
%    imshow(uint8(out))
%    figure(2);hold on;
%    imshow(uint8(forhisto))
%    figure(3);hold on;
%    imshow(uint8(in))

