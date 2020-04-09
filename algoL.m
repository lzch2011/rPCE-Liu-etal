function [ ensemble ] = algoL( vecteur )

%%%%%%%% Algorithm L

vecteur=sort(vecteur);

M=length(vecteur);

vl=vecteur;
ensemble=vl;
h=M-1;

while h~=0 && vl(h)>=vl(h+1)
    h=h-1;
end

while h>0
    l=M;
    while vl(h)>=vl(l)
        l=l-1;
    end
    pivot=vl(l);
    vl(l)=vl(h);
    vl(h)=pivot;
    
    r=h+1;
    l=M;
    
    while r<l
        pivot=vl(l);
        vl(l)=vl(r);
        vl(r)=pivot;
        r=r+1;
        l=l-1;
    end
    
    ensemble=[ensemble;vl];
    
    h=M-1;
    
    while h~=0 && vl(h)>=vl(h+1)
        h=h-1;
    end
end