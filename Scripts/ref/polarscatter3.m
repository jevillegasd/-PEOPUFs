function h = polarscatter3(theta,phi,rho, varargin )
    maxr=0.7; stepr = 0.1;
    %if nargin>2, maxr = max(max(rho),maxr); end

    %% Plot axis
    clrh = 0;
    if ~ishold, clf, clrh = 1; end 
    hold on;
    
     if clrh
        for r = stepr:stepr:maxr
       
            [tax_x,tks_y] = pol2cart(linspace(0,2*pi,101),r);
            tax_z = zeros(length(tax_x),1); 
            pax_x = tax_x ; pax_y = tax_z; pax_z = tks_y;
            
            if abs(r-0.5)<1e-10
                plot3(pax_x,pax_y,pax_z,'--','Color','#606060','LineWidth',1)
                plot3(tax_x,tks_y,tax_z,'--','Color','#606060','LineWidth',1)
            elseif abs(r-0.2)<1e-10
                plot3(pax_x,pax_y,pax_z,'-','Color','#b432bb','LineWidth',0.4)
                plot3(tax_x,tks_y,tax_z,'-','Color','#b432bb','LineWidth',0.4) 
            else
                plot3(pax_x,pax_y,pax_z,'-','Color','#AAAAAA','LineWidth',0.1)
                plot3(tax_x,tks_y,tax_z,'-','Color','#AAAAAA','LineWidth',0.1) 
            end
            
             if abs(r-maxr)<1e-10
                patch(pax_x,pax_y,pax_z,'w','FaceAlpha',0.6)
                patch(tax_x,tks_y,tax_z,'w','FaceAlpha',0.6)
            end
        end
       

        %% Plot ticks
        r = maxr;
        for d = 0:pi/10:2*pi
            [tks_x,tks_y] = pol2cart([d d],[r r+0.05]); 
            cero = [0 0];
            plot3(tks_x,tks_y,cero,'-','Color','#606060','LineWidth',1,'DisplayName','')
            plot3(tks_x ,cero,tks_y,'-','Color','#606060','LineWidth',1,'DisplayName','')
        end
        
        %% Plot axis
        plot3(-1:1,[0,0,0],[0,0,0],'-','Color','#000000','LineWidth',1,'DisplayName','')
        plot3([0,0,0],-1:1,[0,0,0],'-','Color','#000000','LineWidth',1,'DisplayName','')
        plot3([0,0,0],[0,0,0],-1:1,'-','Color','#000000','LineWidth',1,'DisplayName','')
    
        lim = maxr+0.1; move = 0.8;
        xlim([-lim lim]), ylim([-lim+move lim+move]), zlim([-lim+move lim+move])
        set(gca,'xtick',[]),set(gca,'ytick',[]),set(gca,'ztick',[]);
        axis square; axis off; view([135,23])
        %legend on;
     end
     
     %% Plot scater of points
     if nargin <2
         return;
     end
     [x,y,z] = sph2cart(theta,phi,rho);
     if nargin<4
         h = plot3(x,y,z);
     else
         h = plot3(x,y,z,varargin{:});
     end
     
     if clrh, hold off; end
end
