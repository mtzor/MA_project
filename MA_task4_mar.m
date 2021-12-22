clear all;
close all;
%%%%%%%%%%%%%%excel Open%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sheet = 1;

users_filename =  'C:\Users\mtzortzi\Downloads\users.xls';
userRange = 'A2:K1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename =  'C:\Users\mtzortzi\Downloads\items.xls';
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
end

%%%%Find the items that can be bought with the budget of the group 
feasible_items=[];
for k=1:NoItems
    if items_mv(k,11)<=group_budget
        feasible_items=[feasible_items;items_mv(k,:)];
    end    
end

%%%Choose one random item
ind = +ceil(rand * size(feasible_items,1));
sel_item = feasible_items(ind,:);

%%KL divergence algorithm for each user with this item
 NoItems=1
 [f_list,r]=findPrefTable(users_mv(:,3:10),items_mv(:,3:10),1,NoUsers,NoItems);
       
 %%%%%%%Mechanism for distributing the cost that each player should pay
 
   %sorting users according to their rankings from the most displeased to
   %the most pleased of the team
    user_rankings=[teams transpose(r)];
    [~,sortingIndex] = sort( user_rankings(:,2),'ascend');
    user_rankings= user_rankings(sortingIndex,:);
    
    %initialising user payment as the users budget
    x_init=zeros(NoUsers,1);
    for k=1:NoUsers
        indx=user_rankings(k,1)+1;
        x_init(k)=users_mv(indx,11);
    end 
   
   %finding if the sum of budgets is greater than the cost and distributing
   %the remainder of money starting from the most displeased person of the
   %team   
   ratings=sum(r);
   rmax=max(r);
   item_cost=sel_item(11);
   excess_money=group_budget-item_cost;
   
     for k=1:NoUsers
         indx=user_rankings(k,1)+1;
         % if excess_money>
          %end
        current_ur=user_rankings(k,:);
        user_budget=users_mv(user+1,10);
        x(k)=(user_budget/group_budget)*item_cost

     
     end 
ra=sum(x)