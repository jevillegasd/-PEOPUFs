% (C) 2021, Juan Esteban Villegas, NYUAD
% Based on work by Alabi Bojesomo, NYUAD, 2020
% and shared in https://github.com/DfX-NYUAD/peo-PUF
% The GNU General Public License v3.0 apply for this and any derived code.

function results = HD_Compute(lambda, all_data, cmp, numbits, len, names,titles)
    %cmp = 4;            % Reference measurement for HD computation
    %len = 3;            % Bitlength of the key responses. 
    sample_size = 1001; % Input gets remmaped to this number of points
    key_size = 128;
     
    dx = lambda(2)-lambda(1); 
    %We first increase the sample size to make sure that the total length
    %is divisible by both len and numbits. Alternatively one could crop or
    %pad the last set to meet the requirement of len.
    
    ts = mod(numbits*sample_size,len);
    add = 0;
    while(mod(ts+add*numbits,len)~=0)
        add= add+1;
    end
    sample_size = sample_size+add;
       
    figure(1); clf;
    for it_user = 1:length(all_data)
        data = all_data{it_user};
        processed_raw = zeros(sample_size, size(data,2));
        
        % Generate all key responses for the device (subsampled )
        for it = 1:size(data,2)
            cdata = data(:,it);
            w = 0.02e-9;  % Width of the sech filtering function in nm

            processed_raw(:,it) = data_filter(cdata, dx, w , sample_size, 32);
            binary = getKey(processed_raw(:,it),numbits,1,1);
            cell_key(it,:) = cell2mat({binary}); 
        end

        % Apply random challenges to each  
        
        % when len is different than numbits, several responses can be connected
        % together to form a single challenge repsonse pair.

        num = size(cell_key,2)/len; % Same as the length of the raw data if no cropping or subsampling is done
        grp = ceil(key_size/len);   % Number of challenge response pairs needed to build a key_size long key;

        num_tests = 1e3;            % Number of tests to be carried
        % These are the challenge-response pairs of key_size size that we will compare

        figure(it_user);
        clf,  hold on;
        for it = 1:size(data,2)
            HDdata = zeros(num_tests,1);
            data_ref = reshape(cell_key(cmp,:),len,[]); % Each column is one sample from the keyset
            data_sam = reshape(cell_key(it,:) ,len,[]); 

            for itt= 1:num_tests
                pos = randperm(num,grp);
                subset{1} = reshape(data_ref(:,pos),1,[]);
                subset{2} = reshape(data_sam(:,pos),1,[]);
                HDdata(itt) = pdist(double(cell2mat(subset(:)))-double('0'),'Hamming');
            end
            clear subset;

            HD(it).mean = mean(HDdata); 
            HD(it).sigma = std(HDdata);
            HD(it).comment = strcat(names(cmp), " / " , names(it));

            subplot(ceil((size(data,2)-1)/2),2,it);

            [xd,pd] = plotHD(HDdata); grid on;
            title(HD(it).comment);
            text(max(xd),0.8*max(pd),['\mu = ',num2str(HD(it).mean)],'color','red')
            text(max(xd),0.6*max(pd),['\sigma = ',num2str(HD(it).sigma)],'color','red')
            text(max(xd),0.4*max(pd),HD(it).comment,'color','red') 
        end
        results{it_user} = HD;
        sgtitle(titles{it_user});
        hold off; 
    end


end