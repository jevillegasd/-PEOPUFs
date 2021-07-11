%This functions carries the correlation correction and returns the
%concatenated metrics with and without correcting .

% (C) 2021, Juan Esteban Villegas, NYUAD

function results = multi_HD(lambda, dataset, Looseness)
    dx = lambda(2)-lambda(1); 
    w = 0.05e-9;  % Width of the sech filtering function in nm
    normalization_scale = 2^8-1; %Maximum value of the normalized spectra.
    L = Looseness*normalization_scale;
       
    %% Bitwise HD comparison settings
    len = 2 ;            % Bitlength of the key individual CRPs groups. 
    numbits = 2;
    spacing = 1; 
    ignoreend = 5;    
    
    %% Sample filter setup
    sample_size = 1001; % Input gets remmaped to this number of points
    ts = mod(numbits*sample_size,len);
    add = 0;
    while(mod(ts+add*numbits,len)~=0)
        add= add+1;
    end
    sample_size = sample_size+add;
    
    %%     
    numsamples = size(dataset,2);
    ncmp = nchoosek(numsamples,2);
     
    num_tests = 1e3;            % Number of tests to be carried
    IDX = nchoosek(1:numsamples,2); %All combiantios of device pairs
    
    HDdata = zeros(num_tests,ncmp);
    L2data = HDdata; hHDdata = HDdata; LHDdata = HDdata;
    HDdata_s = HDdata;L2data_s = HDdata; hHDdata_s = HDdata; LHDdata_s = HDdata;
    mu = zeros(ncmp,8); sigma = zeros(ncmp,8); 
    
    for it = 1:ncmp
        %% Preprocess the basedata
        cdata_ref = dataset(:,IDX(it,1)); cdata_ref = cdata_ref-max(cdata_ref);
        cdata_sam = dataset(:,IDX(it,2)); cdata_sam = cdata_sam-max(cdata_sam);
        
        data_ref = filter_conv(cdata_ref, dx, w , sample_size, normalization_scale);
        data_sam = filter_conv(cdata_sam, dx, w , sample_size, normalization_scale);
        
        [data_ref_s, data_sam_s] = shiftSpectra_int(data_ref,data_sam);
        cut = mod(length(data_ref_s),len);  %Crop the dataset to be divisible by len
        data_ref_s = data_ref_s(1:end-cut);
        data_sam_s = data_sam_s(1:end-cut);
        
        dist = measure_distance(data_ref  ,data_sam   , L,  len, numbits, spacing, ignoreend);
        dist2 = measure_distance(data_ref_s,data_sam_s, L,  len, numbits, spacing, ignoreend);
        
        L2data (:,it) = dist(:,1);
        hHDdata(:,it) = dist(:,2);
        LHDdata(:,it) = dist(:,3);
        HDdata (:,it) = dist(:,4);
        
        L2data_s (:,it) = dist2(:,1);
        hHDdata_s(:,it) = dist2(:,2);
        LHDdata_s(:,it) = dist2(:,3);
        HDdata_s (:,it) = dist2(:,4);

        mu(it,:)    = [mean(hHDdata(:, it)) mean(L2data(:, it)) mean(LHDdata(:, it)) mean(HDdata(:, it)) ...
                       mean(hHDdata_s(:, it)) mean(L2data_s(:, it)) mean(LHDdata_s(:, it)) mean(HDdata_s(:, it))];
        sigma(it,:) = [std(hHDdata(:, it))  std(L2data(:, it))  std(LHDdata(:, it))  std(HDdata(:, it)) ...
                       std(hHDdata_s(:, it))  std(L2data_s(:, it))  std(LHDdata_s(:, it))  std(HDdata_s(:, it))];
            
    end
    results.mean     = {mu sigma};
    results.HDData   = {L2data    hHDdata     LHDdata     HDdata};
    results.HDData_s = {L2data_s  hHDdata_s   LHDdata_s   HDdata_s};
end