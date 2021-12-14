
sheet = 1;
TopN = 10;
NoUsers=50;
NoItems=500;

users_filename = 'C:\Users\mtzortzi\Downloads\users.xls';
userRange = 'C2:J51';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename = 'C:\Users\mtzortzi\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);

[pref_list,~]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);