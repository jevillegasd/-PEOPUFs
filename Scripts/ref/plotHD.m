% Plots an histogram with Hamming Distance and a gaussian fit of the
% dataset.

% (C) 2021, Juan Esteban Villegas, NYUAD
% Based on work by Alabi Bojesomo, NYUAD, 2020
% and shared in https://github.com/DfX-NYUAD/peo-PUF
% The GNU General Public License v3.0 apply for this and any derived code.

function h1 = plotHD(data, xlab, axis, color, print_label)

    if nargin <2, xlab ='Hamming Distance'; end
    if nargin <3, axis = [0 1]; end
    if nargin <4, color  =''; end
    if nargin <5, print_label =0; end

    bins = 15;
    mu = mean(data);
    sigma = std(data);
    gm = makedist('Normal','mu',mu,'sigma',sigma);

    h1 = histogram(data,15,'Normalization','probability');
    if ~isempty(color)
        h1.FaceColor = color;
    end
    xd = deal((h1.BinEdges(1:end-1)+h1.BinEdges(2:end))/2);
    yd = pdf(gm,xd); pd = yd/sum(yd);


    %bar(xh,ph)
    hold on
    h = plot(xd,pd,'LineWidth',1,'color','red');
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    xlabel(xlab)
    ylabel('Probability')
    set(gca,'PlotBoxAspectRatio', [2 1 1])

    if (mu<1)
    if mu<0.5 
        xlim(axis);
        label_xpos = mu+2*sigma+0.05;
    else
        xlim(axis);
        label_xpos = mu-2*sigma-0.4;
    end
    else
    %xlim([mu-10*sigma mu+10*sigma])
    xlim([0 500]); 
    xticks([0:100:500]);
    lim = xlim;
    if mu>(lim/2) 
        label_xpos = lim(1)+sigma;
    else
        label_xpos = max(xd);
    end
    end
    ylimits = ylim;

    if print_label
    text(label_xpos,0.8*ylimits(2),['\mu = ',num2str(mu)],'color','red')
    text(label_xpos,0.65*ylimits(2),['\sigma = ',num2str(sigma)],'color','red')
    end

    grid on;
    set(gca,'fontname','times') ; set(gca,'FontSize',7)
    hold off
end