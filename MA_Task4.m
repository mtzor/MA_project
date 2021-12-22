clear all;
close all;



%%%%%%%%%%%%%%excel Open%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sheet = 1;

users_filename =  'C:\Users\giorg\Downloads\multiagentsystems\users.xls';
userRange = 'A2:K1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename =  'C:\Users\giorg\Downloads\multiagentsystems\items.xls';
itemRange = 'A2:K501';
items_mv = xlsread(items_filename,sheet,itemRange);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NumOfGroups=1;
g=[5,10,15,20];
NoUsers=g(4);
NoItems=500;

teams=randi([0 999],NoUsers,NumOfGroups);
budget_of_group=0

%%%Count the sum of budgets of the chosen team
for k=1:NoUsers
    user=teams(k);
    user_budget=users_mv(user+1,11);
      budget_of_group=  user_budget +budget_of_group;
end


%%%%Find the items that can be bought with the budget of the group and put
%%%%them in a array%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%% 
feasible_items=[]
for k=1:NoItems
    
    if items_mv(k,11)<=budget_of_group
        feasible_items=[feasible_items;items_mv(k,:)]
    end    
end


%%%Choose one random item
ind = +ceil(rand * size(feasible_items,1));
sel_item = feasible_items(ind,:);



%%KL divergence algorithm for each user with this item
 NoItems=1
D=8;
 
    rmax=10;
    
    COV_u = 2*eye(D);
    COV_i = eye(D);
    
    r=zeros(NoItems,NoUsers);
    
    for u=1:NoUsers
       for i=1:NoItems
           KL=0.5*log(det(inv(COV_u)*COV_i))+0.5*trace(inv(inv(COV_u)*COV_i))-0.5*D +0.5*(users_mv(u,[3:10])-items_mv(i,[3:10]))*inv(COV_i)*transpose(users_mv(u,[3:10])-items_mv(i,[3:10]));
           r(i,u) = rmax - (KL/rmax);     
       end
    end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
 %%%%%%%Mechanism for distributing the cost that each player should pay
    ratings=sum(r)
    rmax=max(r)
    item_cost=sel_item(11)
    %group_ratings=[r;tranverse(teams)]
    
    group_budget=0
   for k=1:NoUsers
    user=teams(k);
    user_budget=users_mv(user+1,10);
    group_budget=user_budget+group_budget
   
   end 
   
   for k=1:NoUsers
    user=teams(k);
    user_budget=users_mv(user+1,10);
    x(k)=(user_budget/group_budget)*item_cost
   
   end 
ra=sum(x)