# MA_project

##Social Choice Mechanisms for Recommender Systems.

1. Kullback-Leibler Divergence Criterion utilised to compute the scores of each item for each a user.
2. a. Created random groups of users and suggested and item for each group based on two different scoring mechanisms.
      Copeland method and Borda Count were used to suggest an item for each group of users.   
      Measured satisfaction of users fora each method. Used mean user rating for each item as satisfaction metric.
   b. Implemented multi-winner election mechanism, Reweighted Approval Voting, in order to recommend k items to each group.
3. a. Generated similar and divergent groups using the Pearson Correlation Coefficient (PCC) metric as a similarity metric between users. 
   b. Repeated 2.a. procedure for similar and divergent groups of users.
4. a. For each group we computed all feasible items.
   b. Designed and implemented a mechanism that fairly divides the total cost of an item among the users in a group,
   based on their budget and their rating on this item.
5. Used the paying mechanism proposed above, to suggest one feasible item per group, that maximizes the users’ satisfaction.


Further deatails graphs and metrics are provided in the report document within this repository.
    
