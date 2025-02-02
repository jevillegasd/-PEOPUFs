%Formats and prints a table with means and standard deviations for distance
%metrics (ED, LHD and BHD).

% (C) 2021, Juan Esteban Villegas, NYUAD
function tout = display_results(avg, sigma)

    metrics = {'ED';'LHD';'BHD'}; clear out;
    for j = 2:4 %metric
        for i = 1:size(avg,1) %device design
            if avg(i,j)>1
                s = sprintf('%2.1f\x00B1 %2.1f (%2.1f\x00B1 %2.1f) \t', ...
                avg(i,j),sigma(i,j),avg(i,j+4),sigma(i,j+4));
            else
                s = sprintf('%2.3f\x00B1 %2.3f (%2.3f\x00B1 %2.3f) \t', ...
                avg(i,j),sigma(i,j),avg(i,j+4),sigma(i,j+4));
            end
            fprintf(s);
            out{j-1,i+1}= s;
        end
        out{j-1,1} = metrics{j-1};
        disp(' ');
    end
    
    if avg(i,j)>1
        tout = cell2table( out, ...
        'VariableNames',{'Metric' 'Design 1' 'Design 2' 'Design 3'});
    end
end