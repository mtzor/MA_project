clear all;
close all;

%read user data
sheet = 1;
NoUsers=1000;

users_filename = 'C:\Users\mtzortzi\Downloads\users.xls';

%opts = detectImportOptions(users_filename);
%opts.SelectedVariableNames = [3:10];
%opts.DataRange = '2:1001';

%users_mv = readmatrix(users_filename,opts);
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);

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
    for j=(i+1):NoUsers
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
  %  [A,I]=maxk(similarityList(rusers(i),:),groupSize-1);
  %  similarTeams(:,i)=[rusers(i) I];
  [~,idx]=sort(similarityList(rusers(i),:),'descend');
  similarTeams(:,i)=[rusers(i) idx(1:groupSize-1)];
end

%pick 100 random users
rusers=randperm(NoUsers,NumOfGroups);
%create 100 divergent groups, with users least similar to the 100 random users.
%AKA we pick the g-1 least similar users to each random user to form each group.
divergentTeams=zeros(groupSize,NumOfGroups);
for i=1:length(rusers)
    %[B,I]=mink(similarityList(rusers(i),:),groupSize-1);
    %divergentTeams(:,i)=[rusers(i) I];
    [~,idx]=sort(similarityList(rusers(i),:),'ascend');
    divergentTeams(:,i)=[rusers(i) idx(1:groupSize-1)];
end

%rerun task 2a
TopN = 500;
NoItems=500;
% opts.DataRange = '2:501';
% items_filename = 'C:\Users\Kyriakos\Desktop\polloi007\ergasia\items.xls';
% items_mv = readmatrix(items_filename,opts);
items_filename = 'C:\Users\mtzortzi\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);

[pref_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

IB=findBordaItems(similarTeams,NumOfGroups,groupSize,NoItems,pref_list);

IC=findCopelandItems(similarTeams,NumOfGroups,groupSize,NoItems,pref_list)

is=(IC==IB)
si=sum(is);

SBavgScoret=averageScoreTable(similarTeams,NumOfGroups,groupSize,IB,ratings);

SCavgScoret=averageScoreTable(similarTeams,NumOfGroups,groupSize,IC,ratings);

IB=findBordaItems(divergentTeams,NumOfGroups,groupSize,NoItems,pref_list);

IC=findCopelandItems(divergentTeams,NumOfGroups,groupSize,NoItems,pref_list);

id=(IB==IC);
di=sum(id);

DBavgScoret=averageScoreTable(divergentTeams,NumOfGroups,groupSize,IB,ratings);
    
DCavgScoret=averageScoreTable(divergentTeams,NumOfGroups,groupSize,IC,ratings);

%Average score of each mechanism
sbAvgScore=mean(SBavgScoret);
scAvgScore=mean(SCavgScoret);
dbAvgScore=mean(DBavgScoret);
dcAvgScore=mean(DCavgScoret);