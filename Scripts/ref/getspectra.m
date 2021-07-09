 function retr = getspectra(s)
    retr = [];
    for ss=s
        retr = [retr ss.spectra(:,2)];
    end