   
    load('20210427_Spectra_3.mat');
    data(:,2) = max(data(:,2))-data(:,2);
    alldata{1}=data;
    load('20210427_Spectra_2.mat')
    data(:,2) = max(data(:,2))-data(:,2);
    alldata{2}=data;
    load('20210427_ref_Spectra_1.mat')
    data(:,2) = max(data(:,2))-data(:,2);
    alldata{3}=data;
    load('20210427_ref_Spectra_3.mat')
    data(:,2) = max(data(:,2))-data(:,2);
    alldata{4}=data;
    load('20210427_ref_Spectra_2.mat')
    data(:,2) = max(data(:,2))-data(:,2);
    alldata{5}=data;
    load('20210427_Spectra_1.mat')
    data(:,2) = max(data(:,2))-data(:,2);
    alldata{6}=data;
    
    
    figure(1); clf; hold on;
    for i = 1:3
        s = alldata{i};
        plot(s(:,1),s(:,2));  
    end
    
    for i = 4:6
        s = alldata{i};
        plot(s(:,1),s(:,2),'--');  
    end
    
    hold off;