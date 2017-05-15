TEXT='';

for i=1:10
    TEXT=[TEXT, 'g[', num2str(i), '] '];
end;

clipboard('copy', TEXT);

