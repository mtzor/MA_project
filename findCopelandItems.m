function CopelandItems=findCopelandItems(teams,NumOfGroups,NoUsers,NoItems,pref_list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%findCopelandItems is a function that finds the best item for each group from a list of items.
%               The function computes the the copeland count of each
%               item for each group in teams and suggests one item per
%               team.The copeland method is a pairwise comparison method in
%               which the score of an item is calculated by calculating the
%               number of pairwise wins each item in a group has. 
%
%ARGUMENTS
%
%teams:        The groups of users to which we need to suggest an item (an item for each group).
%          
%NumOfGroups:  The number of groups we are suugesting an item to.
%          
%NoUsers:      The number of users in each group
%         
%NoItems:      The total number of items on  which the copeland method is computed
%    
%pref_list:    All the users' lists of preferences.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
copelandItem=zeros(NoItems,NumOfGroups);%for each g in vector
    for k=1:NumOfGroups % for each team compute the copeland score
        for i=1:NoItems-1 % for each item in their list except the last one compare with
            for j=i+1:NoItems % every other item except i
                Ci=0;
                Cj=0;
                for u=1:NoUsers %for each user of the team compare every pair of two items
                    %count how many users prefer i over j 
                    %and how many prefer j over i
                         
                    user=teams(u,k);
                    user_pref_list=pref_list(:,user);
                        
                    i_place=find(user_pref_list==i);
                    j_place=find(user_pref_list==j);
                        
                    if (i_place<j_place)%player prefers i
                        Ci=Ci+1;
                    elseif(j_place<i_place)%player prefers j
                        Cj=Cj+1;
                    end

                end
                %see now who has the greatest count (for this teamn) and give them a point
                if    (Ci>Cj)% if the count of all the players of the team that prefer i is greater
                    copelandItem(i,k)=copelandItem(i,k)+1;
                elseif(Cj>Ci)% if the count of all the players of the team that prefer j is greater
                    copelandItem(j,k)=copelandItem(j,k)+1;     
                else 
                    copelandItem(i,k)=copelandItem(i,k)+0.5;
                    copelandItem(j,k)=copelandItem(j,k)+0.5;
                end
            end
        end
    end
    [~,CopelandItems] = max(copelandItem);
end