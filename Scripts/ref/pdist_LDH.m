function Y = pdist_LDH(X,L)

    for i = 2:size(X,1)
        vect = abs(X(1,:)-X(i,:))>=L;
        Y(i-1) = sum(vect)/size(X,2);
    end