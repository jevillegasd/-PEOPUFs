% Generates a color plot for a matrix of cross correlation cofficients.

% (C) 2021, Juan Esteban Villegas, NYUAD

function plotcorr(A)
    imagesc(A)
    colormap(gca,'winter');
    colorbar();
    %caxis([0,1]);
    axis equal; axis tight;
    xticks(1:length(A));
    yticks(1:length(A));
    
    for(i=1:length(A))
        for(j=1:length(A))
           t = string(A(i,j)); 
           xpos = i+0.04-length(char(t))*0.04;
           text(xpos,j,t); 
        end
    end