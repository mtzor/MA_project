     close all;
     clear all;
     
userRange = 'A1:CV1';
average_satisfaction_random_g1=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_random_g1.xlsx',userRange)
average_satisfaction_random_g2=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_random_g2.xlsx',userRange)
average_satisfaction_random_g3=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_random_g3.xlsx',userRange)
average_satisfaction_random_g4=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_random_g4.xlsx',userRange)
average_satisfaction_random_g5=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_random_g5.xlsx',userRange)

average_satisfaction_similar_g1=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_similar_g1.xlsx',userRange)
average_satisfaction_similar_g2=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_similar_g2.xlsx',userRange)
average_satisfaction_similar_g3=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_similar_g3.xlsx',userRange)
average_satisfaction_similar_g4=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_similar_g4.xlsx',userRange)
average_satisfaction_similar_g5=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_similar_g5.xlsx',userRange)

average_satisfaction_divergent_g1=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_divergent_g1.xlsx',userRange)
average_satisfaction_divergent_g2=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_divergent_g2.xlsx',userRange)
average_satisfaction_divergent_g3=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_divergent_g3.xlsx',userRange)
average_satisfaction_divergent_g4=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_divergent_g4.xlsx',userRange)
average_satisfaction_divergent_g5=xlsread('C:\Users\giorg\Downloads\multiagentsystems\average_satisfaction_divergent_g5.xlsx',userRange)


%%%%%%%%%%%%%%%average_satisfaction_random
figure;
stem([1:100],average_satisfaction_random_g1,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_random_g2,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_random_g3,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_random_g4,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_random_g5,'linestyle','none');


title('Avg Sat random');
legend('Groups of 4','Groups of 6','Groups of 8','Groups of 10','Groups of 12');
xlabel('group');
ylabel('avg sat');
hold off;


%%%%%%%%%%%%%%%average_satisfaction_similar
figure;
stem([1:100],average_satisfaction_similar_g1,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g2,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g3,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g4,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g5,'linestyle','none');

title('Avg Sat similar');
legend('Groups of 4','Groups of 6','Groups of 8','Groups of 10','Groups of 12');
xlabel('group');
ylabel('avg sat');
hold off;


%%%%%%%%%%%%%%%average_satisfaction_divergent
figure;
stem([1:100],average_satisfaction_divergent_g1,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g2,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g3,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g4,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g5,'linestyle','none');

title('Avg Sat divergent');
legend('Groups of 4','Groups of 6','Groups of 8','Groups of 10','Groups of 12');
xlabel('group');
ylabel('avg sat');
hold off;


average_satisfaction_similar_g1
average_satisfaction_divergent_g1

%%%%%%%%%%%%%%%average_satisfaction_g1
figure;
stem([1:100],average_satisfaction_random_g1,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g1,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g1,'linestyle','none');


title('Avg Sat g=4 for random divergent similar');
legend('random','similar','divergent');
xlabel('group');
ylabel('avg sat');
hold off;

%%%%%%%%%%%%%%%average_satisfaction_g2
figure;
stem([1:100],average_satisfaction_random_g2,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g2,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g2,'linestyle','none');


title('Avg Sat g=6 for random divergent similar');
legend('random','similar','divergent');
xlabel('group');
ylabel('avg sat');
hold off;

%%%%%%%%%%%%%%%average_satisfaction_g3
figure;
stem([1:100],average_satisfaction_random_g3,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g3,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g3,'linestyle','none');


title('Avg Sat g=8 for random divergent similar');
legend('random','similar','divergent');
xlabel('group');
ylabel('avg sat');
hold off;

%%%%%%%%%%%%%%%average_satisfaction_g4
figure;
stem([1:100],average_satisfaction_random_g4,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g4,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g4,'linestyle','none');


title('Avg Sat g=10 for random divergent similar');
legend('random','similar','divergent');
xlabel('group');
ylabel('avg sat');
hold off;

%%%%%%%%%%%%%%%average_satisfaction_g5
figure;
stem([1:100],average_satisfaction_random_g5,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_similar_g5,'linestyle','none');
hold on ;
stem([1:100],average_satisfaction_divergent_g5,'linestyle','none');


title('Avg Sat g=12 for random divergent similar');
legend('random','similar','divergent');
xlabel('group');
ylabel('avg sat');
hold off;