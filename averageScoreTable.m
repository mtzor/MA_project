function [AvgScoret]=averageScoreTable(Teams,NumOfGroups,groupSize,SuggestedItems,ratings)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%WRITE HERE COMMENTS SIMILAR TO THE FOLLOWING
%averageScoreTable is a function that computes the average score of the
%                  items selected for each team by  a mechanism
%
%
%ARGUMENTS
%
%Teams:            the teams as selected to be divergent or similar
%           
%NumOfGroups:      number of groups of players 
%          
%groupSize:        number of users in each team
%          
%SuggestedItems:   Items suggested for each group by our mechanism
%          
%ratings:          ratings for all users and all items
%           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AvgScoret=zeros(1,NumOfGroups);%similar teams borda average score table
    for sg=1:length(Teams)   %for each group
        tempavgScore=0.0;
        for u=1:groupSize   %for each user
            tempavgScore=tempavgScore+ratings(SuggestedItems(sg),Teams(u,sg));
        end
        AvgScoret(sg)=tempavgScore/groupSize;
    end
end