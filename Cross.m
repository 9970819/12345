function chrom = Cross(chrom, fa, fb, fmax, favg, Pcmax, Pcmin)
% Input parameters include individual fitness fa, fb, maximum fitness fmax, average fitness favg, and crossover probabilities Pcmax and Pcmin
[nx,ny] = size(chrom);
for i = 1:2:nx-mod(nx,2)
    f = max(fa(i), fb(i)); % Maximum fitness among the two individuals
    if f >= favg
        Pc = Pcmax - (Pcmax - Pcmin) * (f - favg) / (fmax - favg);
    else
        Pc = Pcmax;
    end
    
    if Pc >= rand % Decide whether to perform crossover based on the calculated Pc
        % Note: Ensure that the start and end points do not participate in the crossover operation
        a = chrom(i,:);
        b = chrom(i+1,:);
        if length(unique(a(2:end-1))) == length(unique(b(2:end-1)))
            [a_mid,b_mid] = intercross(a(2:end-1),b(2:end-1));
            chrom(i,2:end-1) = a_mid;
            chrom(i+1,2:end-1) = b_mid;
        end
    end
end
chrom;

function [a,b]=intercross(a,b)
L=length(a);   % Length of a and b
r1=0;
r2=0;
while r1==r2
    r1=randsrc(1,1,[1:L]);
    r2=randsrc(1,1,[1:L]);
end
s=min([r1,r2]);
e=max([r1,r2]);
aa=a(s:e);
a0=a(s:e);
bb=b(s:e);
b0=b(s:e);
a(s:e)=[];     % Remove the crossover segment
b(s:e)=[];
lon=length(a); % Length of a and b after removing the crossover segment
lo=e-s+1;      % Length of the crossover segment
for i=1:lo     % Remove duplicate elements in the crossover segment
    for j=1:lo
        if aa(i)==bb(j)
            aa(i)=0;
            bb(j)=0;
        end
    end
end
i0=find(aa==0);
aa(i0)=[];
i1=find(bb==0);
bb(i1)=[];
loo=length(aa);     % Length after removing duplicate elements in the crossover segment
for i2=1:loo
    for j2=1:lon
        if bb(i2)==a(j2)
            a(j2)=aa(i2);
            break;
        end
    end
end
for i3=1:loo
    for j3=1:lon
        if aa(i3)==b(j3)
            b(j3)=bb(i3);
            break;
        end
    end
end

% Reassemble the segments after crossover into a complete path
a=[a(1:s-1),b0,a(s:lon)];
b=[b(1:s-1),a0,b(s:lon)];