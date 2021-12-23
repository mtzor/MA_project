clear all;
close all;

sheet = 1;
TopN = 500;
NoUsers=1000;
NoItems=500;
thresh=6;

users_filename =  'C:\Users\mtzortzi\Downloads\users.xls';
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename = 'C:\Users\mtzortzi\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);

g=[5,10,15,20];
NumOfGroups=10;
gc=g(1);

TotalNum=gc*NumOfGroups;
teams=randi([1 1000],gc,NumOfGroups);
[pref_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

r_thresh=ratings>6;

