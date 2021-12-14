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

g=[5,10,15,20];
NumOfGroups=100;
gc=g(1);

TotalNum=gc*NumOfGroups;
teams=randi([1 1000],gc,NumOfGroups);
[pref_list,~]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

bordaItem=zeros(NoItems,NumOfGroups);%for each g in vector
%for j=1:4
   % gj=g(j);
    teams=randi([1 1000],gc,NumOfGroups);
    for k=1:NumOfGroups % for each team compute the borda score
        for u=1:gc %for each user
            user=teams(u,k);
            for i=1:NoItems % for each item in their list
                pref_item=pref_list(i,user);
                score=NoItems-i;
                bordaItem(pref_item,k)=bordaItem(pref_item,k)+score;
            end
        end
    end
%end
[~,IB] = max(bordaItem);

copelandItem=zeros(NoItems,NumOfGroups);%for each g in vector
    for k=1:NumOfGroups % for each team compute the copeland score
        for u=1:gc %for each user compare every two items
            user=teams(u,k);
            user_pref_list=pref_list(:,user);
            for i=1:NoItems-1 % for each item in their list except the last one compare with
                for j=i+1:NoItems % every other item except i
                    i_place=find(user_pref_list==i);
                    j_place=find(user_pref_list==j);
                    if (i_place<j_place)
                      copelandItem(i,k)=copelandItem(i,k)+1;
                    elseif(j_place<i_place)
                      copelandItem(j,k)=copelandItem(j,k)+1;     
                    else 
                        copelandItem(i,k)=copelandItem(i,k)+0.5;
                        copelandItem(j,k)=copelandItem(j,k)+0.5;
                    end

                end
            end
        end
    end
    [~,IC] = max(copelandItem);

