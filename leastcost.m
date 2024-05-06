clc
clear all
cost=[2 10 4 5;6 12 8 11;3 9 5 7];
supply=[12;25;20];
demand=[25;10;15;5];
[m,n] = size(cost);
if(sum(supply)==sum(demand))
    disp('balanced problem')
else
    disp('unbalanced problem')
    if(sum(supply)<sum(demand))
        cost(end+1,:)=zeros(1,n)
        supply(end+1)=sum(demand)-sum(supply)
    elseif (sum(supply)>sum(demand))
        cost(:,end+1)=zeros(m,1)
        demand(end+1)=sum(supply)-sum(demand)
    end
end
disp('The balanced problem is: ');
%balanced = [cost supply';demand sum(supply)]
[m,n] = size(cost);
x = zeros(m,n);
Icost = cost;
while any(supply~=0)||any(demand~=0)
    min_cost=min(cost(:))
    [r,c] = find(cost ==min_cost)
    y = min(supply(r),demand(c))
    [aloc,index]=max(y)
    rr = r(index);
    cc = c(index);
    x(rr,cc)=aloc
    supply(rr) = supply(rr)-aloc
    demand(cc) = demand(cc)-aloc
    cost(rr,cc)=Inf;
end
if nnz(x)==m+n-1
    disp('Non degenerate solution');
else
    disp('Degenerate Solution');
end
final_cost = Icost.*x
Final_cost = sum(final_cost(:))
