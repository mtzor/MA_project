function x=costDistributingMechanism(group,r,sel_item,budgets,NoUsers)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%costDistributingMechanism is a function is the implementation of 
%                          our mechanism to distribute the cost of an item to a groups users
%
%ARGUMENTS
%
%group:             the group of users on which we need to distribute the
%                   cost
%  
%r:                 the users ratings on the selected item
%
%sel_item:          the item whose cost needs to be divided
%
%budgets:           the group users' budgets
%                   
%NoUsers:           The number of users in each group
%          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
c=(r-min(r))/(max(r)-min(r));%normalised weight based on rating
  item_cost=sel_item(11);
  weighted_budgets=c.*budgets;
  budget_cost=sum(weighted_budgets); %total budget of all users based on their rating and budget

  if budget_cost<item_cost% if the weighted sum is not enough to cover the cost

        weight=(item_cost)/budget_cost;%recalculate weight to cover the cost
        x=c.*budgets*weight;%payment vector initialisation based on normalised ratings and weight to cover cost
        money_deficit=0;%amount of money that users cannot pay because it is over budget after the multiplication with the weight
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
        
        %rearrange users group their budgets and expected payments based on
        %their ratings. From the most satisfied to the least
        r_users=[r; transpose(group) ;budgets;x];
        [~,index]=sort(r_users(1,:),'descend');
        r_users=r_users(:,index);
        
        %make the players pay for the money deficit starting with the most satisfied ones 
        for i=1:NoUsers% for each user
            if money_deficit>0    %if we still need to cover some costs     
                if r_users(3,i) > r_users(4,i)%if budget grater than requested payment

                    if (money_deficit<(r_users(3,i)-r_users(4,i)))    %if the money needed left is less than the players remainder money                  
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
 
 if budget_cost>=item_cost%if the budget is over the  item price
    weight=(item_cost)/budget_cost;%weight to reduce to item price
    x=c.*budgets*weight;%payment vector x
    y=sum(x);% make sure that sum x equals to item price
 end