% Downsamples a input dataset, using a sech as a filter.

function features = data_filter(data, dx, w , sample_size, scale)
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
        
    features = zeros(sample_size,1);    
    for m2=1:sample_size
        m = (m2-1)*dN+1;            % Index on the original datasel
        x = (((1-m)+(n-1))*dx)';    
        filter = sech(2*log(sqrt(2)+1)*(x/w));
        mult = filter(:).*data;     
        features(m2) = mean(mult);  
    end
    
    features = round( (features/max(abs(features)))*scale);        
    features(features<0) = 0;         
    
end
