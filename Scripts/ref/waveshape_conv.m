
function out_data = waveshape_conv(data, dx, filter_w , sample_size)
    %filter_w = 0.16e-9;
    %dx =   1.0000e-11;
    wav = data.x;
    norm = min(data.data);
    scale = max(data.data)-norm; %Input normalized to this value
    
    filter_res = 6;                             %The filter total width is this times lager than the sech FWHM
    len = (filter_res*round(filter_w/dx)+1);    %Length of the vector with the filtering function
    x = linspace(-filter_res/2*filter_w,filter_res/2*filter_w, len); 
    
    u = sech(2*log(sqrt(2)+1).*(x/filter_w));   %SECH function with a filter_w FWHM
    v = data.data;
    w = conv(u,v)./(filter_w/dx*2);

    crop_i = (length(u)-1)/2;
    w2 = w(crop_i+1:end-crop_i)-norm;
    w2 = w2;%.*scale/max(w2);
    w2(w2<0)=0;
    
    N = length(v); dN = floor(N/sample_size+1);
    out_data = downsample(w2,dN,0);
    out_data(out_data<0)=0;
    
%     % plotting 
%      x2 = downsample(wav,dN,0);
%      figure(1); clf; plot(wav,v-norm); 
%      hold on; plot(wav,w2);
%      plot(x2,out_data); hold off;