h = figure
 metric =3; device = 4;
haxis = [0, 1.0];

subplot(1,3,1), 
        [xd,pd] = plotHD(resultsAu1_dev1{1}.HDData_s{metric}(:,device),'Loose HD',haxis); grid on; hold on;
        [xd,pd] = plotHD(resultsAu0_dev1{2}.HDData_s{metric}(:,device)); grid on;
        
subplot(1,3,2), 
        [xd,pd] = plotHD(resultsAu1_dev2{1}.HDData_s{metric}(:,device),'Loose HD',haxis); grid on; hold on;
        [xd,pd] = plotHD(resultsAu0_dev2{2}.HDData_s{metric}(:,device)); grid on;
        
subplot(1,3,3), 
        [xd,pd] = plotHD(resultsAu1_dev3{1}.HDData_s{metric}(:,device),'Loose HD',haxis); grid on; hold on;
        [xd,pd] = plotHD(resultsAu0_dev3{2}.HDData_s{metric}(:,device)); grid on;
