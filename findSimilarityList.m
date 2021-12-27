function similarityList=findSimilarityList(users_mv,NoUsers)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%findSimilarityList is a function that creates a similarity List, a list that describes how
%                   similar each user is to each other. As for the
%                   similarity metric we are using the Pearson
%                   Correlation Coefficient (PCC) 
%
%ARGUMENTS
%
%users_mv:          the users D dimentional gaussian means in correspondence
%                   to certain charactceristics or tags         
%NoUsers:           The number of users in each group
%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
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
        for j=(i+1):NoUsers
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

end