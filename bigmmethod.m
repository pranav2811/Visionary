clc
 

 M = 10^5; 
 
! c=[3 2 1 0 0 0 -M -M];
! b=[30;60;40]; 
! A= [ 4 1 1 -1 0 0 1 0 ; 2 3 1 0 1 0 0 0; 1 2 1 0 0 -1 0 1];

cost=[-1 3 0 0 0 -M 0];
bv=[6;4;5];
A=[1 2 -1 0 0 1 2; 3 1 0 1 0 0 3; 1 0 0 0 1 0 4];
zjcj = cost(bv)*A-cost; 

Table = [zjcj; A];

Simptable = array2table(Table,'VariableNames',{'x1','x2','s1','s2','s3','a1','sol'});

Run = 1;
while(Run)
   if(any(zjcj(1:end-1)<0))
       zc = zjcj(1:end-1);
       [leave_value, pvtcol] = min(zc);
       
       if(all(A(:,pvtcol)<=0))
           error('ubounded solution');
       else
           sol = A(:,end);
           col = A(:,pvtcol);
           
           for i=1:size(A,1)
               if col(i) > 0
                   ratio(i) = sol(i)/col(i);
               else
                   ratio(i) = inf;
               end
           end
           [leave_val , pvt_row] = min(ratio);
       end
       bv(pvt_row) = pvtcol;
       pvt_key = A(pvt_row,pvtcol);
       A(pvt_row,:)=A(pvt_row,:)/pvt_key;
       
       for i = 1:size(A,1)
           if i ~= pvt_row
               A(i,:)=A(i,:)-A(i,pvtcol)*A(pvt_row,:);
           end
       end
       zjcj = cost(bv)*A-cost; 
       Table = [zjcj; A];
       Simptable = array2table(Table,'VariableNames',{'x1','x2','s1','s2','s3','a1','sol'});
   else
       Run = 0;
       opt_val = zjcj(end);
       
       if(any(bv >= 6) && opt_val < -1000)
          fprintf('Infeasible solution');
       else
          fprintf('The optimal value is %i',opt_val);
       end
   end      
end