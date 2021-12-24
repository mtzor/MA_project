function CopelandItems=findCopelandItems(teams,NumOfGroups,NoUsers,NoItems,pref_list)
   
copelandItem=zeros(NoItems,NumOfGroups);%for each g in vector
    for k=1:NumOfGroups % for each team compute the copeland score
            for i=1:NoItems-1 % for each item in their list except the last one compare with
                for j=i+1:NoItems % every other item except i
                     for u=1:NoUsers %for each user compare every two items
                        user=teams(u,k);
                        user_pref_list=pref_list(:,user);
                        
                        i_place=find(user_pref_list==i);
                        j_place=find(user_pref_list==j);
                        
                        if (i_place<j_place)
                          copelandItem(i,k)=copelandItem(i,k)+1;
                        elseif(j_place<i_place)
                          copelandItem(j,k)=copelandItem(j,k)+1;     
                        else 
                            copelandItem(i,k)=copelandItem(i,k)+0.5;
                            copelandItem(j,k)=copelandItem(j,k)+0.5;
                    end

                end
            end
        end
    end
    [~,CopelandItems] = max(copelandItem);
end