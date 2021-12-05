sheet = 1;
TopN = 500;
NoUsers=50;
NoItems=500;

users_filename = 'C:\Users\giorg\Downloads\users.xls';
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename = 'C:\Users\giorg\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);

%users_mv(5,:)%%
p = randperm(1000,5)
pref_list=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);