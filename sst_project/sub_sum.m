%fast method to compute the sum of sub mtarices inside a big matrix
% in this case the routine computes the sum of all mxn submtarices inside
% the bix matrix A
function sub_sum_A = sub_sum(A,m,n)


B = padarray(A,[m n]);
s = nancumsum(B,1);
c = s(1+m:end-1,:)-s(1:end-m-1,:);
s = nancumsum(c,2);
sub_sum_A = s(:,1+n:end-1)-s(:,1:end-n-1);