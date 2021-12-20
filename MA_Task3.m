clear all;
close all;

%read user data
sheet = 1;
NoUsers=1000;

users_filename = 'C:\Users\Kyriakos\Desktop\polloi007\ergasia\users.xls';
opts = detectImportOptions(users_filename);
opts.SelectedVariableNames = [3:10];
opts.DataRange = '2:1001';

users_mv = readmatrix(users_filename,opts);

%create similarityList, a list that describes how
%similar each user is to each other. As for the
%similarity metric we are using the Pearson
%Correlation Coefficient (PCC) 
similarityList=zeros(NoUsers,NoUsers);
for i=1:NoUsers
    %Use the data, that we have already calculated
    %We skip calculating similarity between i and i
    %because we don't care about it, so we assign the 
    %value of 0, which is of least significance to us.
    %If we were to calculate it, it would be 1.
    for j=1:i    
        similarityList(i,j)=similarityList(j,i);
    end
    %calculate similarity compared to the rest of the users
    for j=(i+1):NoUsers-1
        %?k(Mi[k] ? avg{Mi}) · (Mj [k] ? avg{Mj})
        S1=0.0;
        for k=1:size(users_mv,2)
            S1= S1+(users_mv(i,k)-mean(users_mv(i,:)))*(users_mv(j,k)-mean(users_mv(j,:)));
        end
        
        %??k(Mi[k] ? avg{Mi})^2 ·??k(Mj [k] ? avg{Mj})^2
        S2i=0.0;
        S2j=0.0;
        for k=1:size(users_mv,2)
            S2i=S2i+(users_mv(i,k)-mean(users_mv(i,:)))^2;
            S2j=S2j+(users_mv(j,k)-mean(users_mv(j,:)))^2;
        end
        S2=(S2i^0.5)*(S2j^0.5);
        similarityList(i,j)=S1/S2;
    end
end

g=[5,10,15,20];
groupSize=g(1);
NumOfGroups=100;

%pick 100 random users
rusers=randperm(NoUsers,NumOfGroups);
%create 100 similar groups, with users most similar to the 100 random users.
%AKA we pick the g-1 most similar users to each random user to form each group.
similarTeams=zeros(groupSize,NumOfGroups);
for i=1:length(rusers)
    [A,I]=maxk(similarityList(rusers(i),:),groupSize-1);
    similarTeams(:,i)=[rusers(i) I];
end

%pick 100 random users
rusers=randperm(NoUsers,NumOfGroups);
%create 100 divergent groups, with users least similar to the 100 random users.
%AKA we pick the g-1 least similar users to each random user to form each group.
divergentTeams=zeros(groupSize,NumOfGroups);
for i=1:length(rusers)
    [B,I]=mink(similarityList(rusers(i),:),groupSize-1);
    divergentTeams(:,i)=[rusers(i) I];
end

%rerun task 2a
TopN = 500;
NoItems=500;
opts.DataRange = '2:501';
items_filename = 'C:\Users\Kyriakos\Desktop\polloi007\ergasia\items.xls';
items_mv = readmatrix(items_filename,opts);

[pref_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);
bordaItem=zeros(NoItems,NumOfGroups);%for each g in vector
for k=1:NumOfGroups % for each team compute the borda score
    for u=1:groupSize %for each user
        user=similarTeams(u,k);
        for i=1:NoItems % for each item in their list
            pref_item=pref_list(i,user);
            score=NoItems-i;
            bordaItem(pref_item,k)=bordaItem(pref_item,k)+score;
        end
    end
end

[~,IB] = max(bordaItem);


copelandItem=zeros(NoItems,NumOfGroups);%for each g in vector
for k=1:NumOfGroups % for each team compute the copeland score
    for u=1:groupSize %for each user compare every two items
        user=similarTeams(u,k);
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

SBavgScoret=zeros(1,NumOfGroups);%similar teams borda average score table
for sg=1:length(similarTeams)   %for each group
    tempavgScore=0.0;
    for u=1:groupSize   %for each user
        tempavgScore=tempavgScore+ratings(IB(sg),similarTeams(u,sg));
    end
    SBavgScoret(sg)=tempavgScore/groupSize;
end
    
SCavgScoret=zeros(1,NumOfGroups);%similar teams copeland average score table
for sg=1:length(similarTeams)   %for each group
    tempavgScore=0.0;
    for u=1:groupSize   %for each user
        tempavgScore=tempavgScore+ratings(IC(sg),similarTeams(u,sg));
    end
    SCavgScoret(sg)=tempavgScore/groupSize;
end

bordaItem=zeros(NoItems,NumOfGroups);%for each g in vector
for k=1:NumOfGroups % for each team compute the borda score
    for u=1:groupSize %for each user
        user=divergentTeams(u,k);
        for i=1:NoItems % for each item in their list
            pref_item=pref_list(i,user);
            score=NoItems-i;
            bordaItem(pref_item,k)=bordaItem(pref_item,k)+score;
        end
    end
end

[~,IB] = max(bordaItem);


copelandItem=zeros(NoItems,NumOfGroups);%for each g in vector
for k=1:NumOfGroups % for each team compute the copeland score
    for u=1:groupSize %for each user compare every two items
        user=divergentTeams(u,k);
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



DBavgScoret=zeros(1,NumOfGroups);%divergent teams borda average score table
for sg=1:length(divergentTeams)   %for each group
    tempavgScore=0.0;
    for u=1:groupSize   %for each user
        tempavgScore=tempavgScore+ratings(IB(sg),divergentTeams(u,sg));
    end
    DBavgScoret(sg)=tempavgScore/groupSize;
end
    
DCavgScoret=zeros(1,NumOfGroups);%divergent teams copeland average score table
for sg=1:length(divergentTeams)   %for each group
    tempavgScore=0.0;
    for u=1:groupSize   %for each user
        tempavgScore=tempavgScore+ratings(IC(sg),divergentTeams(u,sg));
    end
    DCavgScoret(sg)=tempavgScore/groupSize;
end

%Average score of each mechanism
sbAvgScore=mean(SBavgScoret);
scAvgScore=mean(SCavgScoret);
dbAvgScore=mean(DBavgScoret);
dcAvgScore=mean(DCavgScoret);