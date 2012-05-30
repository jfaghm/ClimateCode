function [caped,tob,iflag] = cape(tp,rp,pp,t,r,p,sig);

%function [caped,tob,iflag] = cape(tp,rp,pp,t,r,p,sig);
%This algorithm was written by Kerry Emanuel at MIT
%inputs
% tp parcel temperature (in K)
% rp parcel mixing ratio (in g/g)
% pp parcel pressure (in mb)
% t is 1-D array of temperature (in K)
% r is 1-D array of mixing ratio (g/g)
% p is 1-D array of pressure (in mb)
% sig seen in mpikerry
%
%outputs
% caped is calculated value of CAPE
% tob is temp at level of neutral buoyancy 
% iflag: 1=ok, 0=improper sounding, 2=routine did not converge
%

%default values
caped=0;
tob=t(1);
iflag=1;

%check sounding is suitable
if rp<1e-6 || tp<200
    iflag=0;
    caped=nan;
    tob=nan;
    return
end

%assign values of thermodynamic constants
cpd=1005.7;
cpv=1870.0;
cl=2500;
cpvmcl=cpv-cl;
rv=461.5;
rd=287.04;
eps=rd/rv;
alvo=2.501e6;

%define various parcel quantities, including reversible entropy
tpc=tp-273.15;
esp=6.112*exp(17.67*tpc/(243.5+tpc));
evp=rp*pp/(eps+rp);
rh=evp/esp;
rh=min(rh,1);
%rh=0.78;
alv=alvo-cpvmcl*tpc;
s=(cpd+rp*cl)*log(tp)-rd*log(pp-evp)+alv*rp/tp-rp*rv*log(rh);

%find lifted condensation level 
chi=tp/(1669-122*rh-tp);
plcl=pp*(rh^chi);

%begin updraft loop
ncmax=0;
tvrdif=zeros(length(t),1);
jmin=1e6;

for j=1:length(t)
    if p(j)>59 && p(j)<pp
        jmin=min(jmin,j);       
        if p(j)>=plcl   %below LCL
            tg=tp*(p(j)/pp)^(rd/cpd);
            rg=rp;
            tlvr=tg*(1+rg/eps)/(1+rg);
            tvrdif(j)=tlvr-t(j)*(1+r(j)/eps)/(1+r(j));
        else            %above LCL
            tg=t(j);
            tjc=t(j)-273.15;
            es=6.112*exp(17.67*tjc/(243.5+tjc));
            rg=eps*es/(p(j)-es);
            nc=0; flagit=0;
            while flagit==0
                nc=nc+1;
                alv=alvo-cpvmcl*(tg-273.15);
                sl=(cpd+rp*cl+alv*alv*rg/(rv*tg*tg))/tg;
                em=rg*p(j)/(eps+rg);
                sg=(cpd+rp*cl)*log(tg)-rd*log(p(j)-em)+alv*rg/tg;
                if nc<3; ap=0.3; else ap=1; end
                tgnew=tg+ap*(s-sg)/sl;
                if abs(tgnew-tg)>0.001
                    tg=tgnew;
                    tc=tg-273.15;
                    enew=6.112*exp(17.67*tc/(243.5+tc));
                    if nc>500 || enew>(p(j)-1)
                        iflag=2; caped=nan; tob=nan; return;
                    end
                    rg=eps*enew/(p(j)-enew);
                else
                    flagit=1;
                end
            end
            ncmax=max(nc,ncmax);
            rmean=sig*rg+(1-sig)*rp;
            tlvr=tg*(1+rg/eps)/(1+rmean);
            tvrdif(j)=tlvr-t(j)*(1+r(j)/eps)/(1+r(j));
        end
    end
end

na=0;
pa=0;

%find maximum level of positive buoyancy
inb=1;
for j=length(t):-1:jmin
    if tvrdif(j)>0
        inb=max(inb,j);
    end
end
if inb==1 %no CAPE
    return
elseif inb>1
    for j=jmin+1:inb
        pfac=rd*(tvrdif(j)+tvrdif(j-1))*(p(j-1)-p(j))/(p(j)+p(j-1));
        pa=pa+max(pfac,0);
        na=na-min(pfac,0);
    end
    
    %find area between parcel pressure and first level above it
    pma=(pp+p(jmin));
    pfac=rd*(pp-p(jmin))/pma;
    pa=pa+pfac*max(tvrdif(jmin),0);
    na=na-pfac*min(tvrdif(jmin),0);
    
    %find residual positive area above inb and to
    pat=0;
    tob=t(inb);
    if inb<length(t)
        pinb=(p(inb+1)*tvrdif(inb)-p(inb)*tvrdif(inb+1))/(tvrdif(inb)-tvrdif(inb+1));
        pat=rd*tvrdif(inb)*(p(inb)-pinb)/(p(inb)+pinb);
        tob=(t(inb)*(pinb-p(inb+1))+t(inb+1)*(p(inb)-pinb))/(p(inb)-p(inb+1));
    end
    
    %find CAPE
    caped=pa+pat-na;
    caped=max(caped,0);
end
