function dist = measure_distance(data_ref,data_sam,L, len, numbits, spacing, ignoreend)
    % Computes HD metrics for a pair of measurements
    
    % For bitwise HD calculation, we extract numbits bits from the
    % amplitude at specific wavelengths. To built the key we extract from
    % this data len number of bits at a random position, in the case len> numbits,
    % the key blocks will combine several consecutive responses until
    % building a block of size len. 
    
    if nargin < 6
        len =2 ;            % Bitlength of the key individual CRPs groups. 
        numbits = 2;        % Size in bits of the extracted features.
        spacing = 1; ignoreend = 0;
    end
    
    key_size = 128;     %Size in bits of the generated CRP grouped as response.
    
    %input_ref = input_ref - max(input_ref);
    %input_sam = input_sam - max(input_sam);
    
    %data_ref = data_filter(input_ref, dx, w , sample_size, normalization_scale);
    %data_sam = data_filter(input_sam, dx, w , sample_size, normalization_scale);

    binary = getKey(data_ref,numbits,spacing,ignoreend);
    cell_key_ref = cell2mat({binary}); 
    binary = getKey(data_sam,numbits,spacing,ignoreend);
    cell_key_sam = cell2mat({binary}); 
        
    key_ref = reshape(cell_key_ref,len,[]); % Each column is one sample from the keyset
    key_sam = reshape(cell_key_sam,len,[]); 
        num_bitHD = size(cell_key_ref,2)/len; % Same as the length of the raw data if no cropping or subsampling is done
        grp_bitHD = ceil(key_size/len);

    %% Compute the HD 
    num = length(data_ref);    num_tests = 1e3; grp = key_size;             % Number of challenge response pairs needed to build a key_size long key;
    
    for itt= 1:num_tests
        pos = randperm(num,grp);
        pos2 = randperm(num_bitHD,grp_bitHD);

        subset{1} = reshape(data_ref(pos),1,[]);
        subset{2} = reshape(data_sam(pos),1,[]);

        subset_bitHD{1} = reshape(key_ref(:,pos2),1,[]);
        subset_bitHD{2} = reshape(key_sam(:,pos2),1,[]);

        L2data (itt)  = pdist(cell2mat(subset(:)));                %Euclidean Distance
        hHDdata(itt) = pdist(cell2mat(subset(:)), 'Hamming');      %Hard Hamming Distance
        LHDdata(itt) = pdist_LDH(cell2mat(subset(:)),L);           %Loose Hamming Distance
        HDdata (itt)  = pdist(double(cell2mat(subset_bitHD(:))),'Hamming');  %Bitwise Hamming Distance
    end
    
    dist = [L2data', hHDdata', LHDdata', HDdata'];
    clear subset;
end