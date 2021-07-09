function [data1_s,data2_s, c_lambda] = shiftSpectra(data1,data2, lambda)

    data1 = data1-max(data1); %Normalization of the data is necessary for an accurate computation of the correlation
    data2 = data2-max(data2);
    
    dl = lambda(2)-lambda(1);
    xcorr_window = 5e-9; %in meters
    xcorr_N = round(xcorr_window/dl);

    top_shift = 0; bot_shift = 0;
    datashift = zeros(size(data1));  endi = length(data1);
    datashift(:,1) = data1;
    
    [c,lags]=xcorr(data1,data2,xcorr_N,'normalized');       
    [~,ind]= max(c);
    shift = lags(ind);
    if shift > 0
        datashift(1+shift:endi) = data2(1:endi-shift);
        top_shift = max(shift,top_shift);
    else
        datashift(1:endi+shift) = data2(1-shift:endi);
        bot_shift = min(shift,bot_shift);
    end

    % Crop the shifted data to avoid zero values and the general data to have the same length
    data1_s = data1(1+top_shift:endi);
    data2_s = datashift(1+top_shift:endi);
    c_lambda = lambda(1+top_shift:endi);
    
    endi = endi-top_shift;
    data1_s = data1_s(1:endi+bot_shift);
    data2_s = data2_s(1:endi+bot_shift);
    c_lambda = c_lambda(1:endi+bot_shift);

    R = corrcoef([data1 data2]);
    R_shift = corrcoef([data1_s data2_s]) ;  
  
    %plot([data1_s,data2_s]); 
    %text(1000,-15,sprintf('r=%02f',R_shift(1,2)));
end