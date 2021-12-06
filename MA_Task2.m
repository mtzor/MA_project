clear all;
close all;

sheet = 1;
TopN = 500;
NoUsers=1000;
NoItems=500;

users_filename =  'C:\Users\mtzortzi\Downloads\users.xls';
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename = 'C:\Users\mtzortzi\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);

g=[5,10,15,2];
NumOfGroups=100;

TotalNum=g(1)*NumOfGroups;
teams=randi([1 1000],g(1),100);
pref_list=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

bordaItem=zeros(NoItems,NumOfGroups,4);%for each g in vector
for j=1:4
    gj=g(j);
    teams=randi([1 1000],gj,100);
    for k=1:NumOfGroups % for each team compute the borda score
        for u=1:g(1) %for each user
            user=teams(u,k);
            for i=1:NoItems % for each item in their list
                pref_item=pref_list(i,user);
                score=NoItems-i;
                bordaItem(pref_item,k)=bordaItem(pref_item,k)+score;
            end
        end
    end
end

[~,I] = max(bordaItem);

