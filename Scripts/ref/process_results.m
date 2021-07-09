avg = zeros(4,length(results{1}));
std = avg;

figure('Name','Average Hamming Distance');
hold on;
x = var(2:end);
for dev = 1:2
    avg(dev,:) = [results{dev}.mean]';
    std(dev,:) = [results{dev}.sigma];
    
    xx=linspace(x(1),x(end),1000);
    yy=interp1(x,avg(dev,:),xx,'PCHIP' );  % use whatever method suits you the best
    plot(xx,yy);
end
legend (['60 deg';'';'45 deg';'';'30 deg';'';'15 deg']);
for dev = 1:2
    plot(x,avg(dev,:),'o');
end

legend (['60 deg';'';'45 deg';'';'30 deg';'';'15 deg']);
hold off
set(gca,'fontsize', 18);
set(gca,'fontname', 'times')
grid on

% 
% xticks = var(2:end);
% figure('Name','Average Hamming Distance');
% surf(xticks, [1 2 3 4], avg);
% 
% % Plot format
%     xlabel('Input power (dBm)'); 
%     ylabel('Device ID');
%     shading interp; colormap('jet'); colorbar;
%     xlim([ -20 -3]); view([0 0 -90]);
%     set(gca,'fontsize', 18);
%     set(gca,'fontname', 'times');
%     %title("Average Hamming Distance")
%     
% average = zeros(1,4);
% for dev = 1:4
%     avg_d(dev,:) = [results{dev}.mean]';
%     std_d(dev,:) = [results{dev}.sigma];
% end
% 
% disp("mu = " + mean(mean(avg_d)) + ", std = " + mean(mean(std_d)))
% 
% 
% 
% figure();   
% [xd,pd] = plotHD(savedData); grid on;
% 
% text(max(xd),0.7*max(pd),['\mu = ',num2str(HD_info(it-1).mean)],'color','red')
% text(max(xd),0.6*max(pd),['\sigma = ',num2str(HD_info(it-1).sigma)],'color','red')
% text(max(xd),0.4*max(pd),HD_info(it-1).comment,'color','red') 
% set(gca,'fontsize', 18);
% set(gca,'fontname', 'times');