function [f_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%findPrefTable is a function that computes the the preference list of a
%number of users responding to a number of items and each users rating for each of
%those items
%
%ARGUMENTS
%
%users_mv:  the users D dimentional gaussian means in correspondence
%           to certain charactceristics or tags
%items_mv:  the items D dimentional gaussian means in correspondence
%           to certain charactceristics or tags
%TopN:      the number of the top most preferable items we want the
%           function to compute
%NoUsers:   the number of the first N users whose preferences are computed
%           in this function
%NoItems:   the total number of items on  which the preferences are computed
%           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    D=8;
    rmax=10;
    
    COV_u = 2*eye(D);
    COV_i = eye(D);
    
    r=zeros(NoItems,NoUsers);
    for u=1:NoUsers
       for i=1:NoItems
           KL=0.5*log(det(inv(COV_u)*COV_i))+0.5*trace(inv(inv(COV_u)*COV_i))-0.5*D +0.5*(users_mv(u,:)-items_mv(i,:))*inv(COV_i)*transpose(users_mv(u,:)-items_mv(i,:));
           r(i,u) = rmax - (KL/rmax);     
       end
    end


    f_item=zeros(TopN,NoUsers);
    for c=1:NoUsers
        [~,sortingIndex] = sort( r(:,c),'descend');
        [f_item(:,c),~] = ind2sub(size(r(:,c)),sortingIndex(1:TopN));
    end
    
    f_list=f_item;
    ratings=r;
end