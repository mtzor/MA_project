function [sel_item,r]=recursiveFunction(users_mv,NoUsers,feasible_items)

%%%Choose one random item
ind = +ceil(rand * size(feasible_items,1));
sel_item = feasible_items(ind,:);

%%KL divergence algorithm for each user with this item
 NoItems=1
 [f_list,r]=findPrefTable(users_mv(:,3:10),sel_item(1,3:10),1,NoUsers,NoItems);
end 