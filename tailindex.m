function [ML,MLsd,QQ,QQsd] = tailindex(x)

k = length(x)-1;

[ML MLsd h1 h2 h3 h4 h5 h6 h7 h8 h9 h10] = TailHill(x,k);
[h11 h12 h13 h14 h15 QQ QQsd h17 h18 h19 h20] = TailZipf(x,k);

end
