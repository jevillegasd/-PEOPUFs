h = figure
metric =3;
haxis = [0, 1.0];

subplot(1,3,1), 
    h = plotHD(intraAu1_dev1.HDData_s{metric}(:,1),'Loose HD',haxis); h.BinWidth = 0.01; hold on;
    h = plotHD(interAu1_dev1{1}.HDData_s{metric}(:,1)); h.BinWidth = 0.01;   h.FaceColor = '#57068c'; grid on;

subplot(1,3,2), 
    h = plotHD(intraAu1_dev2.HDData_s{metric}(:,1),'Loose HD',haxis); h.BinWidth = 0.01; hold on;
    h = plotHD(interAu1_dev2{2}.HDData_s{metric}(:,1)); h.BinWidth = 0.01;   h.FaceColor = '#57068c'; grid on;

subplot(1,3,3), 
    h = plotHD(intraAu1_dev3.HDData_s{metric}(:,1),'Loose HD',haxis); h.BinWidth = 0.01; hold on;
    h = plotHD(interAu1_dev3{2}.HDData_s{metric}(:,1)); h.BinWidth = 0.01;   h.FaceColor = '#57068c'; grid on;

hold off