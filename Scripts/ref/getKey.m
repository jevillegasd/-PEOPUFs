function key = getKey(data,len,spacing, ignoreend)
%data : spectral power data to get keys from
%len : [6] length of bits per instance
%spacing : {[1],2}      Spacing between extracted bits
%This function extract len number of bits from the most significant bits of
%the value stored in data.
%Original Version: Github
%Modified by J.Villegas, May 2021

    if ~exist('len','var')
        len = 6;
    end

    if ~exist('spacing','var')
        spacing = 1;
    end
    if ~exist('ignoreend','var')
        ignoreend = 0;
    end

    
%     gCode = dec2bin(bitshift(data,-1));     %Remove the LSB (sort of High Pass  filter)
%     m = max(data);                          %Maximum value in the data vector
%     MSB = nextpow2(m);                      %Length in bits of that value
% 
    
    binCode = dec2bin(data);
    s = size(binCode,2);
    gCode = bin2gray(binCode);            %Transform into Gray Code
    
    start = s-(ignoreend+spacing*len)+1;
    stop  = s-ignoreend;
    
    key_t = gCode(:,start:spacing:stop)';
    key = key_t(:)';
end

function gray = bin2gray(bin)
%Input is a char, can take arrays
    gray = repmat('0',size(bin,1),size(bin,2));
    for j = 1:size(bin,1)
        b = bin(j,:);
        g =  repmat('0',1,length(b));
        g(1) = b(1);
        for i = 2 : size(b,2)
            x = xor(str2num(b(i-1)), str2num(b(i)));
            g(i) = num2str(x);
        end
        gray(j,:) = g;
    end
end