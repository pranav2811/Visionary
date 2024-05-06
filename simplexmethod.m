clc 
clear all
A=[3 -1 1 1 0 0 7;-1 2 0 0 1 0 6;-4 3 8 0 0 1 10]
cost=[-1 3 -3 0 0 0 0]
bv=[4 5 6]
ZjCj = cost(bv)*A-cost
Table = [ZjCj ; A]
simple_table=array2table(Table,'VariableNames',{'x1','x2','x3','s1','s2','s3','sol'})
run=1
while run
if any((ZjCj(1:end-1))<0)
   zc=ZjCj(1:end-1)
     [leave_value pvtcol] = min(zc)
 if all(A(:,pvtcol)<=0)
    error('unbounded sol')
  else
    sol=A(:,end)
    col=A(:,pvtcol)
    for i=1:size(A,1)
        if col(i)>0 
            ratio(i)=sol(i)/col(i)
        else
            ratio(i)=inf
        end
    end
    [leave_value pvtrow]=min(ratio)
 end
 bv(pvtrow)=pvtcol
 pvtkey=A(pvtrow,pvtcol)
 A(pvtrow,:)=A(pvtrow,:)/pvtkey
 
      for i=1:size(A,1)
          if i~=pvtrow
              A(i,:)=A(i,:)-A(i,pvtcol)*A(pvtrow,:)
          end
      end
      ZjCj = cost(bv)*A-cost
      table2=[ZjCj;A];
      simplex_table=array2table(table2,'VariableNames',{'x1','x2','x3','s1','s2','s3','sol'})    
else
    run=0
    optimalValue=ZjCj(end);
    fprintf('optimal value is %f',optimalValue);
 end
end