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
NoUsers=g(2);
NoItems=500;

teams=randi([0 999],NoUsers,NumOfGroups);
group_budget=0;

%%%Find total budget of the chosen team
for k=1:NoUsers
    user=teams(k);
    user_budget=users_mv(user+1,11);
    group_budget=  user_budget +group_budget;
    budgets(k) =user_budget;
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
 [~,r]=findPrefTable(users_mv(:,3:10),sel_item(1,3:10),1,NoUsers,NoItems);

  c=(r-min(r))/(max(r)-min(r));%normalised weight based on rating e [0,1]
  item_cost=sel_item(11);
  weighted_budgets=c.*budgets;
  budget_cost=sum(weighted_budgets); %total budget of all users based on their rating and budget

  if budget_cost<item_cost% if the weighted sum is not enough to cover the cost

        weight=(item_cost)/budget_cost%recalculate weight to cover the cost
        x=c.*budgets*weight%payment vector initialisation based on normalised ratings and weight to cover cost
        money_deficit=0%amount of money that users cannot pay because it is over budget after the multiplication with the weight
        y=sum(x);
        % find the users that are expected to cover more than they have and
        % make them pay their budget
        for i=1:NoUsers
            if budgets(i)<x(i)%if they are expected to pay more than they have
                x(i)=budgets(i);%pay all your budget
            end
        end
        z=sum(x);
        money_deficit=item_cost-z;%what they could not pay based on their budget
        
        %rearrange users, teams, their budgets and expected payments based on
        %their ratings. From the most satisfied to the least
        r_users=[r; transpose(teams) ;budgets;x];
        [~,index]=sort(r_users(1,:),'descend');
        r_users=r_users(:,index);
        
        %make the players pay for the money deficit starting with the most satisfied ones 
        for i=1:NoUsers% for each user
            if money_deficit>0    %if we still need to cover some costs     
                if r_users(3,i) > r_users(4,i)%if budget greater than requested payment

                    if (money_deficit<(r_users(3,i)-r_users(4,i)))    %if the money needed left is less or equal than the players remaining money                  
                        r_users(4,i)=r_users(4,i)+money_deficit;%pay the previous cost plus the deficit
                        money_deficit=0;%no more money needed
                    else%f the money needed left is more than the players remainder money 
                        money_deficit=money_deficit-(r_users(3,i)-r_users(4,i));%reduce the deficit by the money the player gave
                        r_users(4,i)=r_users(3,i); %make them pay their budget                    
                    end                
                end
            end
        end
        x=r_users(4,:);
        y=sum(x);
  end
 %%%CHECKED WORKS WELL
 if budget_cost>=item_cost%if the budget is over the  item price
    weight=(item_cost)/budget_cost;%weight to reduce to item price
    x=c.*budgets*weight;%payment vector x
    y=sum(x);% make sure that sum x equals to item price
 end
