clear all;
close all;

sheet = 1;
TopN = 500;
NoUsers=1000;
NoItems=500;
thresh=6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%importing items and users gaussians
users_filename =  'C:\Users\mtzortzi\Downloads\users.xls';
userRange = 'C2:J1001';
users_mv = xlsread(users_filename,sheet,userRange);

items_filename = 'C:\Users\mtzortzi\Downloads\items.xls';
itemRange = 'C2:J501';
items_mv = xlsread(items_filename,sheet,itemRange);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
g=[5,10,15,20];
NumOfGroups=10;
gc=g(1);

TotalNum=gc*NumOfGroups;
teams=randi([1 1000],gc,NumOfGroups);% making random teams of gc users
%finding users preference lists and ratings for every item
[pref_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems);

r_thresh=ratings>6;% for every user find all items with ratings more than 6 
item_approvals=sum(r_thresh,2);% add rows to get approval for each item


%%%%Group items based on their approval count %%%%%%%%%%
checked_nums=[];
C={};
for i=1:NoItems % for each item
    number=item_approvals(i);% get number of approvals
    if(ismember(number,checked_nums)==false)% if we havent checked it yet
       
        is_equal_indexes=find(item_approvals==number);%find indeces of it 
        C{1,end+1} = number;%add team to cell
        C{2,end} =is_equal_indexes ;% add number to cell
        checked_nums=[checked_nums number];% add number to checked ones
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sort groups of items based on their number of approvals
[~, idx] = sort([C{1,:}],'descend');
C = C(:, idx);

K=50;
S=zeros(1,K);
%applying the Reweighted Approval Method by 
%sorting groups based on their values, 
%choosing one candidate item from the group with highest value
%adding the candidate to the chosen selection
%and halfing the groups value
%repeating k times
for i=1:K
   %sort by voter appreciation
    [~, idx] = sort([C{1,:}],'descend');
    C = C(:, idx);
    %chose one from the first group
    Si=cell2mat(C(2,1));%chosen group
    candidate_indx=randi([1 size(Si,1)],1);%random candidate index in group
    candidate=Si(candidate_indx);%random candidate
    S(i)=candidate;%adding candidate to chosen group
    
    half_value=cell2mat(C(1,1))/2;% halfing groups value
    C(1,1)=num2cell(half_value);
end




