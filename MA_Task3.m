clear all;
close all;

%%Its a constant that we change its value to cache or not our results
compute_cached=1%%Default is Zero

%read user data
sheet = 1;
NoUsers=1000;
%users_filename = 'C:\Users\mtzortzi\Downloads\users.xls';
users_filename = 'C:\Users\giorg\Downloads\multiagentsystems\users.xls';
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);
%opts = detectImportOptions(users_filename);
%opts.SelectedVariableNames = [3:10];
%opts.DataRange = '2:1001';
%users_mv = readmatrix(users_filename,opts);

%create similarityList, a list that describes how
%similar each user is to each other.

if compute_cached==0
    similarityList=findSimilarityList(users_mv,NoUsers);
    userRange = 'A1:ALL1000';
    xlswrite('C:\Users\giorg\Downloads\multiagentsystems\similarityList.xlsx',similarityList,userRange)
else
    userRange = 'A1:ALL1000';
    similarityList=xlsread('C:\Users\giorg\Downloads\multiagentsystems\similarityList.xlsx',userRange)
end

g=[5,10,15,20];
groupSize=g(1);
NumOfGroups=100;
if compute_cached==0


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

    userRange = 'A1:CV5';
    xlswrite('C:\Users\giorg\Downloads\multiagentsystems\similarTeams.xlsx',similarTeams,userRange)

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
    userRange = 'A1:CV5';
    xlswrite('C:\Users\giorg\Downloads\multiagentsystems\divergentTeams.xlsx',divergentTeams,userRange)

else
    userRange = 'A1:CV5';    
    similarTeams=xlsread('C:\Users\giorg\Downloads\multiagentsystems\similarTeams.xlsx',userRange)
    userRange = 'A1:CV5';
    divergentTeams=xlsread('C:\Users\giorg\Downloads\multiagentsystems\divergentTeams.xlsx',userRange)
end
%%%%%%%%%%%%%%%%%%rerun task 2a%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TopN = 500;
NoItems=500;
% opts.DataRange = '2:501';
% items_filename = 'C:\Users\Kyriakos\Desktop\polloi007\ergasia\items.xls';
% items_mv = readmatrix(items_filename,opts);
items_filename = 'C:\Users\giorg\Downloads\multiagentsystems\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);

[pref_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

if compute_cached==0
    %find borda items for simillar teams
    IB=findBordaItems(similarTeams,NumOfGroups,groupSize,NoItems,pref_list);
    %find copeland items for simillar teams
    IC=findCopelandItems(similarTeams,NumOfGroups,groupSize,NoItems,pref_list)

    userRange = 'A1:CV1';
    xlswrite('C:\Users\giorg\Downloads\multiagentsystems\IBsimilar.xlsx',IB,userRange)
    xlswrite('C:\Users\giorg\Downloads\multiagentsystems\ICsimilar.xlsx',IC,userRange)

else
    IB=xlsread('C:\Users\giorg\Downloads\multiagentsystems\IBsimilar.xlsx',userRange)
    IC=xlsread('C:\Users\giorg\Downloads\multiagentsystems\ICsimilar.xlsx',userRange)
end

is=(IC==IB)%see which borda item recommendations are the same as copeland 
si=sum(is);%count the number for similar groups

%average score for borda mechanism on simillar teams
SBavgScoret=averageScoreTable(similarTeams,NumOfGroups,groupSize,IB,ratings);
%average score for copeland mechanism on simillar teams
SCavgScoret=averageScoreTable(similarTeams,NumOfGroups,groupSize,IC,ratings);



if compute_cached==0
    %find borda items for divergent teams
    IB=findBordaItems(divergentTeams,NumOfGroups,groupSize,NoItems,pref_list);
    %find copeland items for divergent teams
    IC=findCopelandItems(divergentTeams,NumOfGroups,groupSize,NoItems,pref_list);
 
    userRange = 'A1:CV1';
    xlswrite('C:\Users\giorg\Downloads\multiagentsystems\IBdivergent.xlsx',IB,userRange)
    xlswrite('C:\Users\giorg\Downloads\multiagentsystems\ICdivergent.xlsx',IC,userRange)

else
    IB=xlsread('C:\Users\giorg\Downloads\multiagentsystems\IBdivergent.xlsx',userRange)
    IC=xlsread('C:\Users\giorg\Downloads\multiagentsystems\ICdivergent.xlsx',userRange)
end


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



