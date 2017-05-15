clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEFINITION

NUM_OF_GREAT_CIRCLES = 5;   %% The number of great circles to generate
EDGE = 0;                   %% EDGE LIST
EDGE_CNT = 0;               %% Number of EDGE LIST
ellipse_tilt = 0;           %% ellipse_tilt(i,1) is the tilt of the great circle ith


Current_time = strrep(datestr(now), ':', '-');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVED CONFIGURATION
SAVE = 0;

if SAVE == 1
    SAVE_FOLDER = strcat('C:\Users\Kha\Dropbox\Lam viec\Graph Theory\Great Circles Problem\MATLAB Code\');
    DATA_FOLDER = SAVE_FOLDER; %strcat(SAVE_FOLDER,'Data');
    FIGURE_FOLDER = strcat(SAVE_FOLDER,'Figures\', num2str(NUM_OF_GREAT_CIRCLES), ' Circles\');
    
    mkdir(SAVE_FOLDER);
    mkdir(DATA_FOLDER);
    mkdir(FIGURE_FOLDER);
    %copyfile('Great_Circles_Problem.m',DATA_FOLDER);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE 1

figure(1);  
set(gcf,'units','normalized','outerposition',[0 0 1 1]);

axis([-1.1 1.1 -1.1 1.1]);
%title(['Great Circles graph with intersections (', num2str(NUM_OF_GREAT_CIRCLES), ' great circles)'], 'FontSize', 12);
hold on
set(gca,'xcolor',get(gcf,'color'));
set(gca,'ycolor',get(gcf,'color'));
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate ellipses
for i=1:NUM_OF_GREAT_CIRCLES
    ellipse_tilt(i,1) = (i-1)/NUM_OF_GREAT_CIRCLES - 0.5; 
    %ellipse_tilt(i,1) = RandomInRange(-0.5, 0.5);
    ellipse_tilt(i,2) = i;
    [x(i,:),y(i,:)] = ellipse(0,0,500,1000, pi*ellipse_tilt(i,1));
end;

Sorted_ellipse_tilt = sortrows(ellipse_tilt,1);


axis tight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find intersections
CNT=0;
for i=1:NUM_OF_GREAT_CIRCLES
    for j=i+1:NUM_OF_GREAT_CIRCLES

        %% Adjacency list is used for knowing what circles made what intersections
        
        CNT = CNT + 1; 
        Intersection(1:2,CNT) = InterX([x(i,1:end/2);y(i,1:end/2)] , [x(j,1:end/2);y(j,1:end/2)]);
        Intersection(3:4,CNT) = [i,j]; 
        
        CNT = CNT + 1;
        Intersection(1:2,CNT) = InterX([x(i,end/2:end);y(i,end/2:end)] , [x(j,end/2:end);y(j,end/2:end)]);
        Intersection(3:4,CNT) = [i,j];        
    end;
end;

plot(Intersection(1,:),Intersection(2,:),'ro','MarkerSize', 10);% , 'LineWidth', 1); %% Plot out the intersections found

for i=1:numel(Intersection(1,:))
    text(Intersection(1,i), Intersection(2,i)-20, num2str(i), 'FontSize', 13);
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVE FIGURE 1

if SAVE == 1
    
    name_to_save = 'Great Circles graph';
    name_to_save = [name_to_save, ' - ', Current_time, ')'];
    savelocation = strcat(FIGURE_FOLDER,name_to_save);
    saveas(gcf,savelocation);
    print(gcf, '-dbmp', [savelocation,'.bmp']);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% FIGURE 2 - Create a new figure for an equivalent graph with connected edges
% figure(2);
% plot(Intersection(1,:),Intersection(2,:),'ro','MarkerSize', 8); %% Plot out the intersections found
% title(['Equivalent graph with connected edges (', num2str(NUM_OF_GREAT_CIRCLES), ' great circles)'], 'FontSize', 12);
% axis([-1.1 1.1 -1.1 1.1]);
% set(gca,'xcolor',get(gcf,'color'));
% set(gca,'ycolor',get(gcf,'color'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CNT = 1;
for i=1:NUM_OF_GREAT_CIRCLES
    LIST = 0; CNT = 1;
    for j=1: numel(Intersection(3,:))
    
         if Intersection(3,j) == i
             LIST(CNT,1) = j;
             CNT = CNT + 1;
         end;
         
        if Intersection(4,j) == i
            LIST(CNT,1) = j;
            CNT = CNT + 1;
        end;
        
    end;

    [EDGE,EDGE_CNT] = Point_Loc(LIST, i, ellipse_tilt(i,1), Intersection, x(i,:),y(i,:), EDGE, EDGE_CNT, 0);
end;


EDGE = sortrows(EDGE,1);
EDGE= unique(EDGE,'rows');


axis tight;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Export EDGEs to SAGE
% TEXT = ['edges = [', '(', num2str(EDGE(1,1)), ',', num2str(EDGE(1,2)), ')'];
% 
% for i=2:numel(EDGE(:,1))
%     TEXT = [TEXT,', (', num2str(EDGE(i,1)), ',', num2str(EDGE(i,2)), ')'];
% end;
% 
% TEXT = [TEXT,']']
% clipboard('copy', TEXT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Export EDGEs to MATHEMATICA
% TEXT = ['edges = {', '{', num2str(EDGE(1,1)), ',', num2str(EDGE(1,2)), '}'];
% 
% for i=2:numel(EDGE(:,1))
%     TEXT = [TEXT,', {', num2str(EDGE(i,1)), ',', num2str(EDGE(i,2)), '}'];
% end;
% 
% TEXT = [TEXT,'}']
% clipboard('copy', TEXT);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Export AdjacencyMatrix to MATHEMATICA


AdjacencyMatrix = zeros(numel(Intersection(1,:)));
for i=1:numel(EDGE(:,1))
    AdjacencyMatrix(EDGE(i,1),EDGE(i,2)) = 1;
    AdjacencyMatrix(EDGE(i,2),EDGE(i,1)) = 1;
end;

AdjacencyMatrix_TEXT = 'AdjacencyMat={';
for i=1:numel(Intersection(1,:))
    
    AdjacencyMatrix_TEXT = [AdjacencyMatrix_TEXT,'{'];
    
    for j=1:numel(Intersection(1,:))-1
        AdjacencyMatrix_TEXT = [AdjacencyMatrix_TEXT, num2str(AdjacencyMatrix(i,j)), ','];
    end;
    
    if i ~= numel(Intersection(1,:))
        AdjacencyMatrix_TEXT = [AdjacencyMatrix_TEXT,num2str(AdjacencyMatrix(i,j+1)),'}, '];
    else
        AdjacencyMatrix_TEXT = [AdjacencyMatrix_TEXT,num2str(AdjacencyMatrix(i,j+1)),'}}'];
    end;
end;

AdjacencyMatrix_TEXT
clipboard('copy', AdjacencyMatrix_TEXT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WANT_COLOR = 1;
% 
% if WANT_COLOR == 1
%     
%     hold on;
%     
%     VERTICES_COLORS = inputdlg('The color of vertices from SAGEMATH:', 'Input');
%     
%     if isempty(VERTICES_COLORS) ~= 1
%         VERTICES_COLORS = strjoin(VERTICES_COLORS);
%         VERTICES_COLORS = strrep(VERTICES_COLORS, '[[', '[');
%         VERTICES_COLORS = strrep(VERTICES_COLORS, ']]', '];');
%         VERTICES_COLORS = strrep(VERTICES_COLORS, '], [', '];. [');
%         VERTICES_COLORS = strsplit(VERTICES_COLORS,'. ');
% 
%         eval(['RED = ', VERTICES_COLORS{1}]);
%         eval(['BLUE = ', VERTICES_COLORS{2}]);
%         eval(['GREEN = ', VERTICES_COLORS{3}]);
% 
% 
%         for i=1:numel(RED);
%             plot(Intersection(1,RED(i)), Intersection(2,RED(i)), '.r', 'MarkerSize',30)
%         end;
% 
%         for i=1:numel(BLUE);
%             plot(Intersection(1,BLUE(i)), Intersection(2,BLUE(i)), '.b', 'MarkerSize',30)
%         end;
% 
%         for i=1:numel(GREEN);
%             plot(Intersection(1,GREEN(i)), Intersection(2,GREEN(i)), '.g', 'MarkerSize',30)
%         end;
%     end;
%     
% end;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% SAVE FIGURE 2
% 
% if SAVE == 1
%     name_to_save = 'Equivalent graph with connected edges';
%     name_to_save = [name_to_save, ' - ', Current_time, ')'];
%     savelocation = strcat(FIGURE_FOLDER,name_to_save);
%     saveas(gcf,savelocation);
%     print(gcf, '-dbmp', [savelocation,'.bmp']);
% end;



Color_List = Redraw_Great_Circles_Problem(NUM_OF_GREAT_CIRCLES);

NODES_IN_1_LINE = NUM_OF_GREAT_CIRCLES-1;
TOTAL_VERTICES  = (NODES_IN_1_LINE+1)*NODES_IN_1_LINE;



START=0;
END = NODES_IN_1_LINE;
TEMP=0;
TEMP2=TOTAL_VERTICES+(NODES_IN_1_LINE+1);
CNT = 0;
LAST_LINE = 0;
for i=1:TOTAL_VERTICES/2
    TEMP = TEMP + 1;
    CNT  = CNT + 1;
    
    if CNT > END
        
        LINE = floor(TEMP/NODES_IN_1_LINE);
        CNT  = LINE+1;
        TEMP = TEMP + LINE;
        TEMP2= TOTAL_VERTICES-LINE;
        %'OK'
    else
        TEMP2 = TEMP2 - (NODES_IN_1_LINE+1);
    end;
    
    
    START = START + 1;
    Final_Color(START,1:3) = Color_List(TEMP,1:3);
    
    
    START = START + 1;
    Final_Color(START,1:3) = Color_List(TEMP2,1:3);
    
    
end;


START = 0;
for i=NUM_OF_GREAT_CIRCLES:-1:1
    for j=1:i-1
        Ellipse_1 = Sorted_ellipse_tilt(i,2);         
        Ellipse_2 = Sorted_ellipse_tilt(j,2);         
        if Ellipse_1 < Ellipse_2
            MIN = Ellipse_1;
            MAX = Ellipse_2;
        else
            MIN = Ellipse_2;
            MAX = Ellipse_1;
        end;
        
        for k=1:numel(Intersection(1,:))
            if Intersection(3,k) == MIN && Intersection(4,k) == MAX
                break;
            end;
        end;
%         [num2str(i), ',', num2str(j), ',', num2str(k)]
        START = START + 1;
        New_Intersection(1:4,START) = Intersection(1:4,k);
        
        START = START + 1;
        New_Intersection(1:4,START) = Intersection(1:4,k+1);
    end;   
end;

figure(1)
for i=1:numel(Intersection(1,:))
    plot(New_Intersection(1,i),New_Intersection(2,i),'ro','MarkerSize', 10, 'MarkerFaceColor', Final_Color(i,1:3));% , 'LineWidth', 1); %% Plot out the intersections found
end;