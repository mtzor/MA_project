function [group_budgets,feasibleItemList]=findFeasibleItemsList(users_mv,items_mv,teams,NoUsers,NoItems)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%findFeasibleItemsList      function that returns all budgets of players in a group 
%                           and the feasible items of a group based on their
%                           total budget
%
%ARGUMENTS
%
%users_mv:          the users D dimentional gaussian means in correspondence
%                   to certain charactceristics or tags     
%items_mv:          the items D dimentional gaussian means in correspondence
%                   to certain charactceristics or tags 
%teams:             the teams of users on which we need to compute the
%                   feasible items
%NoUsers:           The number of users in each group
%         
%NoItems:           The total number of items to consider
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
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
    group_budgets=budgets;
    feasibleItemList=feasible_items;
end