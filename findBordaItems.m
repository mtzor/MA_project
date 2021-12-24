function BordaItems=findBordaItems(teams,NumOfGroups,NoUsers,NoItems,pref_list)
   
bordaItem=zeros(NoItems,NumOfGroups);%for each g in vector
%for j=1:4
   % gj=g(j);
    teams=randi([1 1000],NoUsers,NumOfGroups);
    for k=1:NumOfGroups % for each team compute the borda score %%%%%%%%%%%%%%%%%%%%%CHECK IF BORDA AND COPELAND ITEM ARE DIFFERENT FOR A SPECIFIC TEAM
        for u=1:NoUsers %for each user
            user=teams(u,k);
            for i=1:NoItems % for each item in their list
                pref_item=pref_list(i,user);
                score=NoItems-i;
                bordaItem(pref_item,k)=bordaItem(pref_item,k)+score;
            end
        end
    end
%end
[~,BordaItems] = max(bordaItem);
end
