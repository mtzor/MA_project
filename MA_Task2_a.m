clear all;
close all;

sheet = 1;
TopN = 500;  
NoUsers=1000;
NoItems=500;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%importing items and users gaussians
users_filename =  'C:\Users\mtzortzi\Downloads\users.xls';
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename = 'C:\Users\mtzortzi\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

g=[5,10,15,20];
NumOfGroups=100;
gc=g(1);
%creating random teams
teams=randi([1 1000],gc,NumOfGroups);
[pref_list,~]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

%computing the best item for each team using the borda count 
IB=findBordaItems(teams,NumOfGroups,gc,NoItems,pref_list);

%computing the best item for each team using the copeland method 
IC=findCopelandItems(teams,NumOfGroups,gc,NoItems,pref_list);
I=(IC==IB);
y=sum(I);
