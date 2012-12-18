function y = running_average ( x, n, usenan )
% function y = running_ave ( x, n, usenan ) ;
%
%  x = input matrix or vector
%  n = number of points used in averaging, default is 5;
%      when n < 0; cyclic boundary conditions are assumed
%      otherwise, first and last values are repeated in averaging
%-------------------------------------- Alexis Lau (Feb 1992)
%  usenan = when set to true, missing boundary values are replaced
%      by NaNs.
%-------------------------------------- Alexis Lau (Feb 1993)
  
  if ~exist('n'); n=0; end;
  if ~exist('usenan'); usenan=0; cyclic=0; end;

  [mx,nx] = size(x);
  if (mx==1);
    x=x'; inverted=1; [mx,nx]=size(x);
  else
    inverted=0;
  end;
  
  if n==0; n=5; end;
  if n<0; n=-n; cyclic=1; else cyclic=0; end;
  n = min(n,mx);
%------------------------------------------------
  y = x;
  if n ~= 1; n1=n-1; ni=fix(n1/2); nj=n1-ni;

    if usenan
      x = [ NaN*ones(ni,1)*x(1,:) ; x ; NaN*ones(nj,1)*x(mx,:) ];
    elseif cyclic
      x = [       x(mx-ni+1:mx,:) ; x ; x(1:nj,:) ];
    else
      x = [     ones(ni,1)*x(1,:) ; x ; ones(nj,1)*x(mx,:) ];
    end
  
    for i=1:mx;
      y(i,:) = mean2(x(i:i+n1,:));
    end;
  end
  
  if inverted; y = y'; end
