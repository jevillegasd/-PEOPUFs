clf, hold off;
h(1) = polarscatter3(angles2(:,1)*2,angles2(:,2)*2,resTM(:,3),...
    'x','Color','r','MarkerSize',4,'DisplayName','HD to TM response');
hold on;
h(2) = polarscatter3(angles2(:,1)*2,angles2(:,2)*2,resTMs(:,3),...
    'o','Color','r','MarkerSize',4,'DisplayName','HD to Shifted TM response');
h(3) =polarscatter3(angles2(:,1)*2,angles2(:,2)*2,resTE(:,3),...
    'x','Color','b','MarkerSize',4,'DisplayName','HD to TE response');
h(4) =polarscatter3(angles2(:,1)*2,angles2(:,2)*2,resTEs(:,3),...
    'o','Color','b','MarkerSize',4,'DisplayName','HD to Shifted TE response');

    hleg = legend([h]);
    legend boxoff;

exportgraphics(gcf,'test.png','Resolution',1200,'BackgroundColor','#CCCCCC')