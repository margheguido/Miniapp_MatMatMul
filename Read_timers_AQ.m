close all
clear all
clc


%% 

formatSpec = '%f';
fileID = fopen('Output/timers_AQ.dat', 'r');
T_AQ = fscanf(fileID, formatSpec);

T_AQ1 = T_AQ(1:2:end);

T_AQ2 = T_AQ(2:2:end);

%%

figure(1)
plot(T_AQ1,'-*')
hold on 
plot(T_AQ2,'-o')

 xlabel('Processors')
 ylabel('Time')
 legend('MatMatMul', 'MatMul')
  saveas(gcf,'MatMul.png')


