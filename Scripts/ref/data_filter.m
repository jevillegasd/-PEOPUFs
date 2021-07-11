% Downsamples a input dataset, using a sech as a filter.

% (C) 2021, Juan Esteban Villegas, NYUAD
% Based on work by Alabi Bojesomo, NYUAD, 2020
% and shared in https://github.com/DfX-NYUAD/peo-PUF
% The GNU General Public License v3.0 apply for this and any derived code.

function out_data = data_filter(data, dx, w , sample_size, scale)
    norm  = min(data);    
    data = data-norm; % Substracting norm is equivalent to normalizing given that power is in log
    
    if nargin<5
        scale = max(data);     % Input normalized to this value, this in the scale of the maximum insertion loss
    end
    
    data  = data(:);            
    N     = length(data);       
    dN    = round(N/sample_size);

    filter = zeros(N,1);        % This is the low pass filter applied.
    n = 1:N;
        
    out_data = zeros(sample_size,1);    
    for m2=1:sample_size
        m = (m2-1)*dN+1;            % Index on the original datasel
        x = (((1-m)+(n-1))*dx)';    
        filter = sech(2*log(sqrt(2)+1)*(x/w));
        mult = filter(:).*data;     
        out_data(m2) = mean(mult);  
    end
    
    out_data = round( (out_data/max(abs(out_data)))*scale);        
    out_data(out_data<0) = 0;         
    
end
