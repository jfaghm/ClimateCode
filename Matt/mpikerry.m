function [pmin,vmax,capea,ifl] = mpikerry(sst,psl,p,t,r)

%function [pmin,vmax,ifl]=mpikerry(sst,psl,p,t,r);
%This algorithm was written by Kerry Emanuel at MIT
%inputs
% sst in degrees Celsius
% psl (central pressure) in mb
% p is 1-D array of pressure (in mb)
% t is 1-D array of temperature (in C)
% r is 1-D array of mixing ratio (g/kg)
% note: p,t,r must indexed from surface upwards
%
%outputs
% pmin is minimum central pressure in mb
% vmax is max surface wind in m/s
% ifl: 1=ok, 0=no convergence, 2=CAPE routine failed
%

%These constants have been changed to what they are set to in the Fortran
%code found on Dr. Emanuel's website.
ckcd=0.9;   %ratio of C_k to C_d  (originally 0.5)
sig=0.0;    %0=reversible ascent, 1=pseudo-adiabatic ascent (originally 0.5
idiss=1;    %0=no dissipative heating (this was originally set to 0)
b=2;      %exponent in assumed profile of azimuthal velocity (v=v_m(r/r_m))^b (originally 2)
nk=1;       %level from which parcel lifts (originally 1)
vreduc=.8;  %factor to reduce gradient wind to 10m (wind originally .8)

sstk=sst+273.15;
eso=6.112*exp(17.67*sst/(243.5+sst));
t=t+273.15;

%default values
vmax=0;
pmin=psl;
ifl=1;
np=0;
pm=950;

%find CAPE
tp=t(nk);
rp=r(nk);
pp=p(nk);

[capea,toa,iflag]=cape(tp,rp,pp,t,r,p,sig);
if iflag~=1
    ifl=2;
end

%return
%begin iteration to find minimum pressure
flagit=0;
%it=0;
while flagit==0
%    it=it+1
    tp=t(nk);
    pp=min(pm,1000);
    rp=0.622*r(nk)*psl/(pp*(0.622+r(nk))-r(nk)*psl);
    [capem,tom,iflag]=cape(tp,rp,pp,t,r,p,sig);
    if iflag~=1
        ifl=2;
    end
    rat=sstk/tom;
    if idiss==0
        rat=1;
    end
    tp=sstk;
    pp=min(pm,1000);
    rp=0.622*eso/(pp-eso);
    [capems,toms,iflag]=cape(tp,rp,pp,t,r,p,sig);
    if iflag~=1
        ifl=2;
    end
    rso=rp;
    tv1=t(1)*(1+r(1)/0.622)/(1+r(1));
    tvav=0.5*(tv1+sstk*(1+rso/0.622)/(1+rso));
    cat=capem-capea+0.5*ckcd*rat*(capems-capem);
    cat=max(cat,0);
    pnew=psl*exp(-cat/(287.04*tvav));
    if (abs(pnew-pm)>0.2)
        pm=pnew;
        np=np+1;
        if np>1000 || pm<400
            pmin=psl;
            ifl=0;
            flagit=1;
        end
    else
        catfac=0.5*(1+1/b);
        cat=capem-capea+ckcd*rat*catfac*(capems-capem);
        cat=max(cat,0);
        pmin=psl*exp(-cat/(287.04*tvav));
        flagit=1;
    end
end
fac=max(0,(capems-capem));
vmax=vreduc*sqrt(ckcd*rat*fac);
