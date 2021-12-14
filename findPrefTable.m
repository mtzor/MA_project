function [f_list,ratings]=findPrefTable(users_mv,items_mv,TopN,NoUsers,NoItems)
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