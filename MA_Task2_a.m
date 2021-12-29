clear all;
close all;

sheet = 1;
TopN = 500;  
NoUsers=1000;
NoItems=500;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%importing items and users gaussians
users_filename =  'C:\Users\mtzortzi\Downloads\users.xls';
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename = 'C:\Users\mtzortzi\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NoPerGroup=[5,10,15,20];
NumOfGroups=100;
gc=NoPerGroup(3);
%creating random teams
teams=randi([1 1000],gc,NumOfGroups);
[pref_list,r]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

%computing the best item for each team using the borda count 
IB=findBordaItems(teams,NumOfGroups,gc,NoItems,pref_list);

%computing the best item for each team using the copeland method 
IC=findCopelandItems(teams,NumOfGroups,gc,NoItems,pref_list);
I=(IC==IB);
y=sum(I);

%average score of each mechanism
%find the ratings of all users in each team for the team's proposed item
%find the mean of the ratings for each team
rb_mean=zeros(1,NumOfGroups);
rc_mean=zeros(1,NumOfGroups);
for g=1:NumOfGroups
    chosen_itemB=IB(g);
    chosen_itemC=IC(g);
    
    ratingsB=zeros(1,gc);
    ratingsC=zeros(1,gc);
   for u=1:gc
       user=teams(u,g);
       ratingsB(u)=r(chosen_itemB,user);
       ratingsC(u)=r(chosen_itemC,user);
   end
   
   rb_mean(g)=mean(ratingsB);
   rc_mean(g)=mean(ratingsC);
end

copeland_wins=rc_mean>rb_mean;
copeland_sum=sum(copeland_wins);


