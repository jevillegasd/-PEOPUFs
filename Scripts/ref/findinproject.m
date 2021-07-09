function idx = findinproject(dev_inda,dev_port,data)
    idx = [];
    for dev_ind = dev_inda
        ind = 1;    
        for meas = data
            if iscell(meas), meas=meas{1}; end

            if meas.var(1) == dev_ind && (meas.var(2) == dev_port || meas.var(2) == 0)
                idx = [idx ind];
                break;
            end
            ind = ind+1;
        end
       
    end
end