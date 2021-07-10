function [mu, sigma] = LHD_Compute(lambda, all_data, mode, Looseness , names,titles)
    plot = 1;
    if nargin < 5
        names = [''];
        titles = [''];
        plot = 0; 
    end

    key_size = 128;                 %Size in bits of the generated CRP grouped as response.
    normalization_scale = 2^8-1;    %Maximum value of the normalized spectra.
    w = 0.02e-9;  % Width of the sech filtering function in nm
     
    len = 2 ;            % Bitlength of the key individual CRPs groups. 
    numbits = 2;
    spacing = 1; 
    ignoreend = 5;
    
    % For bitwise HD calculation, we extract numbits bits from the
    % amplitude at specific wavelengths. To built the key we extract from
    % this data len number of bits at a random position, in the case len> numbits,
    % the key blocks will combine several consecutive responses until
    % building a block of size len. 
    
    sample_size = 1001; % Input gets remmaped to this number of points
    
    %We first increase the sample size to make sure that the total length
    %is divisible by both len and numbits. Alternatively one could crop or
    %pad the last set to meet the requirement of len.
    
    ts = mod(numbits*sample_size,len);
    add = 0;
    while(mod(ts+add*numbits,len)~=0)
        add= add+1;
    end
    sample_size = sample_size+add;
    L = round(Looseness*normalization_scale);
    dx = lambda(2)-lambda(1); 
    
    %We first increase the sample size to make sure that the total length
    %is divisible by both len and numbits. Alternatively one could crop or
    %pad the last set to meet the requirement of len.
    
    
    reps = 1;
    if strcmp(mode,'all') && iscell(all_data), reps = length(all_data); end
     
    for it_out = 1:reps
        if iscell(all_data), data = all_data{it_out};
        else, data = all_data;
        end
        
        processed_raw = zeros(sample_size, size(data,2));
       
        
        % Generate all subsampled responses
        for it = 1:size(data,2)
            cdata = data(:,it);
            
            %Low pass filter in the data using a convolution with a gaussian function 
            %with a normalized output.
            processed_raw(:,it) = data_filter(cdata, dx, w , sample_size, normalization_scale);
            
            binary = getKey(processed_raw(:,it),numbits,spacing,ignoreend);
            cell_key(it,:) = cell2mat({binary}); 
        end
        
        if strcmp(mode,'pairwise')
            processed_raw2 = zeros(sample_size, size(data,2));
            data2 = all_data{2};
            for it = 1:size(data2,2)
                cdata = data2(:,it);
                processed_raw2(:,it) = data_filter(cdata, dx, w , sample_size, normalization_scale);
                binary = getKey(processed_raw2(:,it),numbits,spacing,ignoreend);
                cell_key2(it,:) = cell2mat({binary}); 
            end  
        end
        
        % Apply random challenges to each 
        grp = key_size;             % Number of challenge response pairs needed to build a key_size long key;
        num = sample_size;
        
        % For the bitwise HD, we need fewer spectral combinations.
        num_bitHD = size(cell_key,2)/len; % Same as the length of the raw data if no cropping or subsampling is done
        grp_bitHD = ceil(key_size/len);
        
        num_tests = 1e3;            % Number of tests to be carried
        % These are the challenge-response pairs of key_size size that we will compare
        
        if strcmp(mode,'all') 
            num_cmp = size(data,2)-1;
        else
            num_cmp = size(data,2);
        end
        
        for it = 1:num_cmp
            HDdata = zeros(num_tests,1);
            L2data = HDdata; hHDdata = HDdata; LHDdata = HDdata;
            cmp = 1; %Reference measurement we are comapring to
            
            if strcmp(mode,'all') 
                data_ref = processed_raw(:,cmp); % Each column is one sample from the keyset
                data_sam = processed_raw(:,it+1); 
            else
                data_ref = processed_raw(:,it); % Compares the equivalent data by pairs
                data_sam = processed_raw2(:,it); 
            end
            
            data_ref2 = reshape(cell_key(cmp,:),len,[]); % Each column is one sample from the keyset
            data_sam2 = reshape(cell_key(it+1,:),len,[]); 
            
            for itt= 1:num_tests
                pos = randperm(num,grp);
                pos2 = randperm(num_bitHD,grp_bitHD);
                
                subset{1} = reshape(data_ref(pos),1,[]);
                subset{2} = reshape(data_sam(pos),1,[]);
                
                subset_bitHD{1} = reshape(data_ref2(:,pos2),1,[]);
                subset_bitHD{2} = reshape(data_sam2(:,pos2),1,[]);
                
                L2data(itt)  = pdist(cell2mat(subset(:)));            %Euclidean Distance
                hHDdata(itt) = pdist(cell2mat(subset(:)), 'Hamming'); %Hard Hamming Distance
                LHDdata(itt) = pdist_LDH(cell2mat(subset(:)),L);      %Loose Hamming Distance
                HDdata(itt)  = pdist(double(cell2mat(subset_bitHD(:))),'Hamming');  %Bitwise Hamming Distance
            end
            clear subset;

            mu(it,:)    = [mean(hHDdata) mean(L2data) mean(LHDdata) mean(HDdata)];
            sigma(it,:) = [std(hHDdata)  std(L2data)  std(LHDdata)  std(HDdata) ];
            
            if plot
                comment = strcat(names(cmp), " / " , names(it+1));
                figure(it_out); clf,  hold on;
            % Plot baseline HD
                subplot(num_cmp,4,(it-1)*4+1);
                plotHD(hHDdata); grid on;
                title(strcat(comment, ' - HD'));
                         
            % Plot euclidean distance  
                subplot(num_cmp,4,(it-1)*4+2);
                plotHD(L2data, 'l^2'); grid on;
                title(strcat(comment, ' - Euclidian Dist.'));
                
            % Plot Loose HD    
               subplot(num_cmp,4,(it-1)*4+3);
               plotHD(LHDdata, 'Hamming Dist.'); grid on;
                title(sprintf('%s - Loose HD (%1.2f)', comment, Looseness));
              
            % Plot bitHD
                subplot(num_cmp,4,(it-1)*4+4);
                plotHD(HDdata, 'Hamming Dist.'); grid on;
                title(sprintf('%s - Bitwise HD', comment));
            end
        end
        results{it_out,:} = {mu sigma};
        
        if plot
            sgtitle(titles{it_out});
            hold off; 
        end
    end
end