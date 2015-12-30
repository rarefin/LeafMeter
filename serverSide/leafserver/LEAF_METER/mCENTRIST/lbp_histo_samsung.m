function out = lbp_histo_samsung(histvals,in,forhisto)
m = size(histvals,2);
n = 1;%size(in,2);
out = zeros(m,n);

for i = 1:m
%    out(i,:) = sum((in == histvals(i)).*forhisto);


out(i) = sum(forhisto((in==i)));
% temp=find(in == histvals(i));
%    out(i,:) = sum(forhisto(temp));

end
 
% f_min = min(out);    f_max = max(out);    f_tmp = f_max-f_min;
%     r = 1./ (f_max - f_min);    r(f_tmp < 1e-10) = 1;
%     out = (out - repmat(f_min,1,1)).*repmat(r,1,1);
% 
% out;
% for i = 1:n
%    out(:,i) = out(:,i)./sum(out(:,i));
% 
% % temp=find(in == histvals(i));
% %    out(i,:) = sum(forhisto(temp));
% 
% end


% out=(out-min( out))./(max(out)-min(out));
% out=out./norm(out);
% out=out(2:end);