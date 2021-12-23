clear all;
close all;
%%%%%%%%%%%%%%excel Open%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sheet = 1;

%gg
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
group_budget=0;

%%%Find total budget of the chosen team
for k=1:NoUsers
    user=teams(k);
    user_budget=users_mv(user+1,11);
    group_budget=  user_budget +group_budget;
    budgets(k,1) =user_budget
end

%%%%Find the items that can be bought with the budget of the group 
feasible_items=[];
for k=1:NoItems
    if items_mv(k,11)<=group_budget
        feasible_items=[feasible_items;items_mv(k,:)];
    end    
end

      
 budget_cost=0
 item_cost=1
 i=0
 while(budget_cost<item_cost)
     [sel_item,r]=recursiveFunction(users_mv,NoUsers,feasible_items)
     c=r/10
     item_cost=sel_item(11)
     budget_cost=c*budgets 
     i=i+1
 end
 
 if budget_cost>=item_cost
    weight=(item_cost)/budget_cost
    x(:,1)=c*budgets(:,1)*weight
    y=sum(x)
 end
