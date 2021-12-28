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

teams=randi([1 1000],NoUsers,NumOfGroups);
%find budgets of players in each group and feasible items for the group
[budgets,feasible_items]=findFeasibleItemsList(users_mv,items_mv,teams,NoUsers,NoItems);

 %%%Choose one random item
ind = +ceil(rand * size(feasible_items,1));
sel_item = feasible_items(ind,:);

%%KL divergence algorithm for each user with this item
 NoItems=1
 [~,r]=findPrefTable(users_mv(:,3:10),sel_item(1,3:10),1,NoUsers,NoItems);
 
 %implementation of our mechanism to distribute the cost of an item to a groups users
 x=costDistributingMechanism(teams,r,sel_item,budgets,NoUsers);

