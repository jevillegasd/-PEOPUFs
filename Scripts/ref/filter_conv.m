%Filter the input data applying a low pass filter based on a convolution
% with a gaussian function and resamples the result to sample_size values.

% (C) 2021, Juan Esteban Villegas, NYUAD
% Based on work by Alabi Bojesomo, NYUAD, 2020
% and shared in https://github.com/DfX-NYUAD/peo-PUF
% The GNU General Public License v3.0 apply for this and any derived code.

function out_data = filter_conv(data, dx, w , sample_size, scale)
    if nargin<5
        scale = max(data);     % Input normalized to this value, this in the scale of the maximum insertion loss
    end
    
    norm = min(data);
    data = data-norm;
    filter_res = 6;                             %The filter total width is this times lager than the sech FWHM
    len = (filter_res*round(w/dx)+1);    %Length of the vector with the filtering function
    x = linspace(-filter_res/2*w,filter_res/2*w, len); 
    
    u = sech(2*log(sqrt(2)+1).*(x/w));   %SECH function with a filter_w FWHM
    v = data;
    s = conv(u,v)./(w/dx*2);
    s2 = s*scale/max(s);
    
    crop_i = (length(u)-1)/2;
    s2 = s2(crop_i+1:end-crop_i);
    s2(s2<0)=0;
    
    N = length(v); dN = floor(N/sample_size+1);
    out_data = downsample(s2,dN,0);
    out_data(out_data<0)=0;
   