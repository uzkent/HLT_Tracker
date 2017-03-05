function l = getLikelihood2D(r, A)

l = exp(-r'*inv(A)*r/2)/sqrt(det(4.*pi.*pi.*A));