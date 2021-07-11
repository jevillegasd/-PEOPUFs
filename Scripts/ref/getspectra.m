%returns spectrum from a 'smp' tyope of structure.

% (C) 2021, Juan Esteban Villegas, NYUAD
function retr = getspectra(s)
    retr = [];
    for ss=s
        retr = [retr ss.spectra(:,2)];
    end