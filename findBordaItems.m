function BordaItems=findBordaItems(teams,NumOfGroups,NoUsers,NoItems,pref_list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%findBordaItems is a function that finds the best item for each group from a list of items.
%               The function computes the the borda count of each
%               item for each group in teams and suggests one item per
%               team. The one with the highest borda count
%
%ARGUMENTS
%
%teams:        The groups of users to which we need to suggest an item (an item for each group).
%          
%NumOfGroups:  The number of groups we are suugesting an item to.
%          
%NoUsers:      The number of users in each group
%         
%NoItems:      The total number of items on  which the borda count is computed
%    
%pref_list:    All the users' lists of preferences.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
bordaItem=zeros(NoItems,NumOfGroups);%for each g in vector

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

[~,BordaItems] = max(bordaItem);
end
