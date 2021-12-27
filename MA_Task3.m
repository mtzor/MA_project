clear all;
close all;

%read user data
sheet = 1;
NoUsers=1000;
users_filename = 'C:\Users\mtzortzi\Downloads\users.xls';
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);
%opts = detectImportOptions(users_filename);
%opts.SelectedVariableNames = [3:10];
%opts.DataRange = '2:1001';
%users_mv = readmatrix(users_filename,opts);

%create similarityList, a list that describes how
%similar each user is to each other.
similarityList=findSimilarityList(users_mv,NoUsers);

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

%%%%%%%%%%%%%%%%%%rerun task 2a%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TopN = 500;
NoItems=500;
% opts.DataRange = '2:501';
% items_filename = 'C:\Users\Kyriakos\Desktop\polloi007\ergasia\items.xls';
% items_mv = readmatrix(items_filename,opts);
items_filename = 'C:\Users\mtzortzi\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);

[pref_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

%find borda items for simillar teams
IB=findBordaItems(similarTeams,NumOfGroups,groupSize,NoItems,pref_list);
%find copeland items for simillar teams
IC=findCopelandItems(similarTeams,NumOfGroups,groupSize,NoItems,pref_list)

is=(IC==IB)%see which borda item recommendations are the same as copeland 
si=sum(is);%count the number for similar groups

%average score for borda mechanism on simillar teams
SBavgScoret=averageScoreTable(similarTeams,NumOfGroups,groupSize,IB,ratings);
%average score for copeland mechanism on simillar teams
SCavgScoret=averageScoreTable(similarTeams,NumOfGroups,groupSize,IC,ratings);

%find borda items for divergent teams
IB=findBordaItems(divergentTeams,NumOfGroups,groupSize,NoItems,pref_list);
%find copeland items for divergent teams
IC=findCopelandItems(divergentTeams,NumOfGroups,groupSize,NoItems,pref_list);

id=(IB==IC);%see which borda item recommendations are the same as copeland 
di=sum(id);%count the number for divergent groups

%average score for borda mechanism on divergent teams
DBavgScoret=averageScoreTable(divergentTeams,NumOfGroups,groupSize,IB,ratings);
%average score for copeland mechanism on divergent teams   
DCavgScoret=averageScoreTable(divergentTeams,NumOfGroups,groupSize,IC,ratings);

%Average score of each mechanism
sbAvgScore=mean(SBavgScoret);
scAvgScore=mean(SCavgScoret);
dbAvgScore=mean(DBavgScoret);
dcAvgScore=mean(DCavgScoret);