clear all;
close all;
%%%%%%%%%%%%%%excel Open%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sheet = 1;
users_filename =  'C:\Users\giorg\Downloads\multiagentsystems\users.xls';
userRange = 'A2:K1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename =  'C:\Users\giorg\Downloads\multiagentsystems\items.xls'
itemRange = 'A2:K501';
items_mv = xlsread(items_filename,sheet,itemRange);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=8;
b=2;
TopN = 500;
NoUsers=1000;
NoItems=500;
NoOfGroups=100;
g=[4 6 8 10 12];
%Create groups of gc users

    NoUsersPerGroup=g(5);

    %uncomment for random groups
    %groups=randi([1 1000],NoUsersPerGroup,NoOfGroups);
    
    
    similarityList=findSimilarityList(users_mv(:,3:10),NoUsers);

    %pick 100 random users
    rusers=randperm(NoUsers,NoOfGroups);
    %create 100 similar groups, with users most similar to the 100 random users.
    %AKA we pick the g-1 most similar users to each random user to form each group.
    similarTeams=zeros(NoUsersPerGroup,NoOfGroups);
    for i=1:length(rusers)
      [~,idx]=sort(similarityList(rusers(i),:),'descend');
      similarTeams(:,i)=[rusers(i) idx(1:NoUsersPerGroup-1)];
    end

    %pick 100 random users
    rusers=randperm(NoUsers,NoOfGroups);
    %create 100 divergent groups, with users least similar to the 100 random users.
    %AKA we pick the g-1 least similar users to each random user to form each group.
    divergentTeams=zeros(NoUsersPerGroup,NoOfGroups);
    for i=1:length(rusers)
        [~,idx]=sort(similarityList(rusers(i),:),'ascend');
        divergentTeams(:,i)=[rusers(i) idx(1:NoUsersPerGroup-1)];
    end

    groups=divergentTeams;
    %groups=similarTeams;

    [pref_list,r]=findPrefTable(users_mv(:,3:10),items_mv(:,3:10),TopN,NoUsers,NoItems);
    %user satisfaction for i item
    %);
    selected_items=zeros(1,NoOfGroups);
    average_satisfaction=zeros(1,NoOfGroups);

    for t=1:NoOfGroups% for all groups 
        %find group's feasible items
        [budgets,feasible_items]=findFeasibleItemsList(users_mv,items_mv,groups(:,t),NoUsersPerGroup,NoItems);
        [NoFeasibleItems,~] = size(feasible_items);%teams number of feasible items 
        %making a matrix for all the groups satisfaction vectors for each item
        users_satisfaction=zeros(NoUsersPerGroup,NoFeasibleItems); 

        if (NoFeasibleItems~=0)

            %for all feasible items find each player's sastisfaction in the group
            for i=1:NoFeasibleItems

               item=feasible_items(i,:);%feasible item number i
               item_idx=item(1)+1;%feasible item index
               rg=[];
               %find all the groups ratings for this item
               for u=1:NoUsersPerGroup
                   user=groups(u,t);%for each user in group
                   ru_i=r(item_idx,user);%find users rating for this item
                   rg=[rg ru_i];
               end
               %calculate the cost of each user for the chosen item
               x=costDistributingMechanism(groups(:,t),rg,item,budgets,NoUsersPerGroup);

               for u=1:NoUsersPerGroup%compute satisfaction of each user
                   user=groups(u,t);% select user number u from group number t
                   ru_max=max(r(:,user));%find user's max rating
                   ru_i=r(item_idx,user);%find users rating for this item
                   bu=budgets(u);%budget of user u
                   users_satisfaction(u,i)=a^(-(ru_max-ru_i)/ru_max)*b^((bu-x(u))/bu);
               end

            end
            mean_satisfaction=mean(users_satisfaction);
            [MaxValue,Index] =max(mean_satisfaction);

            selected_items(t)=feasible_items(Index);%%%%%%??????????????????
            average_satisfaction(t)=MaxValue;
        else
            selected_items(t)=0;
        end

    end
    
    userRange = 'A1:CV1';
    
    xlswrite('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_similar_g5.xlsx',average_satisfaction,userRange)

