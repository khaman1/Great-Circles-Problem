clc;
clear all;

%%% Copy text to Notepad++, then find and replace ' \\\r\n' to ' '
RAW = importdata('TEXT.txt');

TEXT='';
for i=1:numel(RAW)
    MyCell = RAW(i,1);
    TEXT = [TEXT, MyCell{1}];
end;

%TEXT = '{True, False, False, True, True, False, False, False, False, False, False, False, False, False, False, True, False, True, False, False}, {False, True, False, False, False, False, True, True, True, True, False, False, False, False, False, False, False, False, True, False}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}, {True, False, False, True, True, False, False, False, False, False, False, False, False, False, False, True, False, True, False, False}, {True, False, False, True, True, False, False, False, False, False, False, False, False, False, False, True, False, True, False, False}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}, {False, True, False, False, False, False, True, True, True, True, False, False, False, False, False, False, False, False, True, False}, {False, True, False, False, False, False, True, True, True, True, False, False, False, False, False, False, False, False, True, False}, {False, True, False, False, False, False, True, True, True, True, False, False, False, False, False, False, False, False, True, False}, {False, True, False, False, False, False, True, True, True, True, False, False, False, False, False, False, False, False, True, False}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}, {True, False, False, True, True, False, False, False, False, False, False, False, False, False, False, True, False, True, False, False}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}, {True, False, False, True, True, False, False, False, False, False, False, False, False, False, False, True, False, True, False, False}, {False, True, False, False, False, False, True, True, True, True, False, False, False, False, False, False, False, False, True, False}, {False, False, True, False, False, True, False, False, False, False, True, True, True, True, True, False, True, False, False, True}';
TEXT = strrep(TEXT, 'True', '1');
TEXT = strrep(TEXT, 'False', '0');
TEXT = strrep(TEXT, ' \', ' ');
TEXT = strrep(TEXT, '}, {', '; ');
TEXT = strrep(TEXT, '{', '[');
TEXT = strrep(TEXT, '}', ']')


MAT = str2num(TEXT);

for i=1:numel(MAT(:,1))
    MAT(i,i) = 0;
end;

START = 0; 
for i=1:numel(MAT(:,1))
    FLAG=0;
    for j=1:i-1
        if MAT(i,j) == 1
            FLAG = 1;
            break;
        end;
    end;
    
    if FLAG == 0
        START = START + 1;
        OUTPUT(START) = i;
    end;
end;

OUTPUT_TEXT='{i,{';
for i=1:numel(OUTPUT)-1
    OUTPUT_TEXT = [OUTPUT_TEXT, num2str(OUTPUT(i)), ', '];
end;

OUTPUT_TEXT = [OUTPUT_TEXT, num2str(OUTPUT(i+1)), '}}']    
clipboard('copy', OUTPUT_TEXT);


OUTPUT_TEXT='';
for i=1:numel(OUTPUT)
    OUTPUT_TEXT = [OUTPUT_TEXT,'GColored[', num2str(OUTPUT(i)), ']\n'];
%     if mod(i,4)==0
%         OUTPUT_TEXT = [OUTPUT_TEXT, ''];
%     end;
end;

sprintf(OUTPUT_TEXT)