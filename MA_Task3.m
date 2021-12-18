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
