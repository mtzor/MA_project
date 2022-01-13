clear all;
close all;

%%Its a constant that we change its value to cache or not our results
compute_cached=0%%Default is Zero

g=[5,10,15,20];
groupSize=g(4);
%read user data
sheet = 1;
NoUsers=1000;
src='C:\Users\mtzortzi\Downloads\MA_proj';%%%%%     CHANGE THIS TO THE SOURCE FOLDER IN YOUR PC %%%%%%%%%
users_filename = strcat(src,'\users.xls');
items_filename = strcat(src,'\items.xls');

similarityList_filename=strcat(src,'\similarityList.xlsx');
similarTeams_filename=strcat(src,'\similarTeams.xlsx');
divergentTeams_filename=strcat(src,'\divergentTeams.xlsx');

IBsimilar_filename=strcat(src,'\IBsimilar.xlsx');
ICsimilar_filename=strcat(src,'\ICsimilar.xlsx');
IBdivergent_filename=strcat(src,'\IBdivergent.xlsx');
ICdivergent_filename=strcat(src,'\ICdivergent.xlsx');

userRange = 'C2:J1001';     users_mv = xlsread(users_filename,sheet,userRange);
itemRange = 'C2:J501';     items_mv = xlsread(items_filename,sheet,itemRange);

%create similarityList, a list that describes how similar each user is to each other
if compute_cached==0
    similarityList=findSimilarityList(users_mv,NoUsers);
    userRange = 'A1:ALL1000';
    xlswrite(similarityList_filename,similarityList,userRange);
else
    userRange = 'A1:ALL1000';
    similarityList=xlsread(similarityList_filename,userRange);
end

NumOfGroups=100;
if compute_cached==0
   
    rusers=randperm(NoUsers,NumOfGroups); %pick 100 random users
    %create 100 similar groups, with users most similar to the 100 random users.
    %AKA we pick the g-1 most similar users to each random user to form each group.
    similarTeams=zeros(groupSize,NumOfGroups);
    for i=1:length(rusers)

      [~,idx]=sort(similarityList(rusers(i),:),'descend');
      similarTeams(:,i)=[rusers(i) idx(1:groupSize-1)];
    end

    userRange = 'A1:CV5';
    xlswrite(similarTeams_filename,similarTeams,userRange)

    rusers=randperm(NoUsers,NumOfGroups);%pick 100 random users
    %create 100 divergent groups, with users least similar to the 100 random users.
    %AKA we pick the g-1 least similar users to each random user to form each group.
    divergentTeams=zeros(groupSize,NumOfGroups);
    for i=1:length(rusers)
        [~,idx]=sort(similarityList(rusers(i),:),'ascend');
        divergentTeams(:,i)=[rusers(i) idx(1:groupSize-1)];
    end
    userRange = 'A1:CV5';
    xlswrite(divergentTeams_filename,divergentTeams,userRange)

else
    userRange = 'A1:CV5';    
    similarTeams=xlsread(similarTeams_filename,userRange)
    userRange = 'A1:CV5';
    divergentTeams=xlsread(divergentTeams_filename,userRange)
end
%%%%%%%%%%%%%%%%%%rerun task 2a%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TopN = 500;
NoItems=500;

[pref_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

if compute_cached==0
    IB=findBordaItems(similarTeams,NumOfGroups,groupSize,NoItems,pref_list); %find borda items for simillar teams
    IC=findCopelandItems(similarTeams,NumOfGroups,groupSize,NoItems,pref_list); %find copeland items for simillar teams

    userRange = 'A1:CV1';
    xlswrite(IBsimilar_filename,IB,userRange);
    xlswrite(ICsimilar_filename,IC,userRange);

else
    IB=xlsread(IBsimilar_filename,userRange);
    IC=xlsread(ICsimilar_filename,userRange);
end

is=(IC==IB);%see which borda item recommendations are the same as copeland 
si=sum(is);%count the number for similar groups

SBavgScoret=averageScoreTable(similarTeams,NumOfGroups,groupSize,IB,ratings);%average score for borda mechanism on simillar teams
SCavgScoret=averageScoreTable(similarTeams,NumOfGroups,groupSize,IC,ratings);%average score for copeland mechanism on simillar teams

if compute_cached==0
    
    IB=findBordaItems(divergentTeams,NumOfGroups,groupSize,NoItems,pref_list);%find borda items for divergent teams
    IC=findCopelandItems(divergentTeams,NumOfGroups,groupSize,NoItems,pref_list);%find copeland items for divergent teams
 
    userRange = 'A1:CV1';
    xlswrite(IBdivergent_filename,IB,userRange);
    xlswrite(ICdivergent_filename,IC,userRange);

else
    IB=xlsread(IBdivergent_filename,userRange);
    IC=xlsread(ICdivergent_filename,userRange);
end

id=(IB==IC);%see which borda item recommendations are the same as copeland 
di=sum(id);%count the number for divergent groups

DBavgScoret=averageScoreTable(divergentTeams,NumOfGroups,groupSize,IB,ratings);%average score for borda mechanism on divergent teams
DCavgScoret=averageScoreTable(divergentTeams,NumOfGroups,groupSize,IC,ratings);%average score for copeland mechanism on divergent teams 

%Average score of each mechanism
sbAvgScore=mean(SBavgScoret)
scAvgScore=mean(SCavgScoret)
dbAvgScore=mean(DBavgScoret)
dcAvgScore=mean(DCavgScoret)
