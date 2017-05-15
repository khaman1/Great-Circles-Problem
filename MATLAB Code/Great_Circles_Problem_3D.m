function [AdjacencyMatrix, CirclesMat] = Great_Circles_Problem_3D(NUM_OF_GREAT_CIRCLES)

% create a plane 
close all;
%clear all;
clearvars -except NUM_OF_GREAT_CIRCLES;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEFINITIONS

SAVE = 0;

if exist('NUM_OF_GREAT_CIRCLES') == 0
    NUM_OF_GREAT_CIRCLES = 10;   %% The number of great circles to generate
end;


TRANSPARENCY = 0.5;
ENABLE_AXIS = 0;
ENABLE_SPHERE = 1;
ENABLE_LINE_INTERSECTIONS = 0;
ENABLE_PLANES = 0;
ENABLE_SPECIAL_GRAPHS = 0;
VERIFY_ADJACENCY_MATRIX = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NUM_VER = NUM_OF_GREAT_CIRCLES*(NUM_OF_GREAT_CIRCLES-1);
NUM_VER_ON_A_CIRCLE = (NUM_OF_GREAT_CIRCLES-1)*2;
NUM_EDGES = 2*NUM_VER;


if SAVE == 1
    DEFAULT_FOLDER = strcat(pwd,'\Data\');

    COUNTER_FILE = [DEFAULT_FOLDER,'Counter.txt'];
    load(COUNTER_FILE); %% Counter

    COUNTER_FILE = fopen(COUNTER_FILE,'wt');
    fprintf(COUNTER_FILE, num2str(Counter+1));
    fclose(COUNTER_FILE);

    SAVE_FOLDER = [DEFAULT_FOLDER, date, '\', num2str(Counter), '\'];
    mkdir(SAVE_FOLDER);
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pointA = [0,0,0];
pointB = [3,3,2];
pointC = [-1,-1,1];
%drawPlane3d(createPlane(pointA, pointB, pointC));


h=figure(1);hold on; rotate3d on; axis(gca,'vis3d'); view([0.8,2,2]);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);

if ENABLE_AXIS == 1
    text(0,1,-1,'X','color','r','Fontsize',18);
    text(1,0,-1,'Y','color','r','Fontsize',18);
    text(1,1,0,'Z','color','r','Fontsize',18);
else
    axis off; 
end;

if ENABLE_SPHERE == 1
    drawSphere([0 0 0 1], 'facecolor', [0.5 0.5 0.5]); 
    alpha(1 - TRANSPARENCY);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
START = 0;
for i=1:NUM_OF_GREAT_CIRCLES
    START = START + 1;
    
    %k=1/10;
    %k=rand;
    
    if ENABLE_SPECIAL_GRAPHS == 1
        THETA(START) = 179/NUM_OF_GREAT_CIRCLES*i;%round(RandomInRange(0, 180),2);
        %PHI(START)   = 179/NUM_OF_GREAT_CIRCLES*i;%round(RandomInRange(0, 360),2);
        PHI(START)   = k*THETA(START);
    else
        THETA(START) = round(RandomInRange(0, 180),2);
        PHI(START)   = round(RandomInRange(0, 360),2);
    end;
    [Circle(:,:,START)] = drawCircle3dNew(0,0,0,1,THETA(START),PHI(START),sqrt(NUM_VER)*500);
end;

Intersections = 0; Intersection_line=0; alpha2=0;
START=0;

for i=1:NUM_OF_GREAT_CIRCLES-1
    for j=i+1:NUM_OF_GREAT_CIRCLES
        
        START=START+1;
        
        [P_intersect,Intersection_line(START,1:6)] = intersect2Circles_Set(Circle(:,:,i), Circle(:,:,j), ENABLE_LINE_INTERSECTIONS, ENABLE_PLANES);
       
        Intersection_line(START,7:8) = [i j];
        
        drawPoint3d(P_intersect(1:2,1:3), 'marker', 'o',...
            'MarkerFaceColor','r','markerSize', 10);

        P_intersect = sortrows(P_intersect,3);
        P_intersect(1:2,6:7) = [i j; i j];
        
        
        if Intersections ~=0
            Intersections = vertcat(Intersections,P_intersect);
        else
            Intersections = P_intersect;
        end;
        
        for j=1:2
            if ENABLE_SPHERE==1
                text(P_intersect(j,1), P_intersect(j,2),...
                     P_intersect(j,3) + sign(P_intersect(j,3))*0.04,...
                     num2str(numel(Intersections(:,1))-1+(j-1)),...
                     'FontSize', 14, 'Color', 'w');
            else
                text(P_intersect(j,1), P_intersect(j,2),...
                     P_intersect(j,3) + sign(P_intersect(j,3))*0.04,...
                     num2str(numel(Intersections(:,1))-1+(j-1)),...
                     'FontSize', 14, 'Color', 'k');
            end;
        end;

    end;
end;

if NUM_VER ~= numel(Intersections(:,1))
    return;
end;


%% Find the middle points
MIN(1) = 100;
for i=1:NUM_VER
    if MIN(1) > abs(Intersections(i,3))
        MIN(1) = abs(Intersections(i,3));
        MIN(2) = i;
    end;
end;

%% EXPORT MATRIX OF CIRCLES
MATRIX_CIRCLES = ExportMatrixCircles(Intersections);

for i=1:NUM_OF_GREAT_CIRCLES
    MATRIX_CIRCLES(:,:,i) = sortrows(MATRIX_CIRCLES(:,:,i),2);
end;    



%% EXPORT MATRIX OF VERTICES
MATRIX_VERTICES= 0;

START(1:NUM_VER) = 0;
% 
for CIRi=1:NUM_OF_GREAT_CIRCLES
    Order_ver = sortrows(MATRIX_CIRCLES(:,:,CIRi),2);
        
    for i=1:NUM_VER_ON_A_CIRCLE
        current_ver = Order_ver(i,1);

        if i==1

            START(current_ver) = START(current_ver)+1;
            MATRIX_VERTICES(START(current_ver),current_ver) = Order_ver(2,1);      
            START(current_ver) = START(current_ver)+1;
            MATRIX_VERTICES(START(current_ver),current_ver) = Order_ver(NUM_VER_ON_A_CIRCLE,1);   

        elseif i==NUM_VER_ON_A_CIRCLE

            START(current_ver) = START(current_ver)+1;
            MATRIX_VERTICES(START(current_ver),current_ver) = Order_ver(1,1);
            START(current_ver) = START(current_ver)+1;
            MATRIX_VERTICES(START(current_ver),current_ver) = Order_ver(NUM_VER_ON_A_CIRCLE-1,1);

        else

            START(current_ver) = START(current_ver)+1;
            MATRIX_VERTICES(START(current_ver),current_ver) = Order_ver(i+1,1);
            START(current_ver) = START(current_ver)+1;
            MATRIX_VERTICES(START(current_ver),current_ver) = Order_ver(i-1,1);

        end
    end;
end;

for i=1:NUM_VER
    MATRIX_VERTICES(:,i) = sortrows(MATRIX_VERTICES(:,i),1);
end; 


% %% OUTPUT ADJACENCY MATRIX
AdjacencyMatrix = zeros(NUM_VER);
for i=1:NUM_VER
    for j=1:numel(MATRIX_VERTICES(:,1))
        Des_ver = MATRIX_VERTICES(j,i);
        
        AdjacencyMatrix(i,Des_ver) = 1;
        AdjacencyMatrix(Des_ver,i) = 1;
    end;
end;

if VERIFY_ADJACENCY_MATRIX==1
    for i=1:NUM_VER
        if sum(AdjacencyMatrix(i,:)) ~= 4
            disp('ERROR in Adjacency Matrix!!!');
            break;
        end;
    end;
    disp('Adjacency Matrix is CORRECT!');
end;

% %% OUTPUT EDGES
START=0;
for i=1:NUM_VER-1
    for j=i+1:NUM_VER
        if AdjacencyMatrix(i,j) == 1
            START = START+1;
            EDGES(START,1:2) = [i j];
        end;
    end;
end;


if NUM_EDGES ~= numel(EDGES(:,1))
    return;
end;



% %% OUTPUT AdjacencyMatrix to clipboard - MATHEMATICA
AdjacencyMatrix_TEXT = 'AdjacencyMat={';
for i=1:NUM_VER
    
    AdjacencyMatrix_TEXT = [AdjacencyMatrix_TEXT,'{'];
    
    for j=1:NUM_VER-1
        AdjacencyMatrix_TEXT = [AdjacencyMatrix_TEXT, num2str(AdjacencyMatrix(i,j)), ','];
    end;
    
    if i~=NUM_VER
        AdjacencyMatrix_TEXT = [AdjacencyMatrix_TEXT,num2str(AdjacencyMatrix(i,j+1)),'}, '];
    else
        AdjacencyMatrix_TEXT = [AdjacencyMatrix_TEXT,num2str(AdjacencyMatrix(i,j+1)),'}};'];
    end;
end;

clipboard('copy', AdjacencyMatrix_TEXT);

%% Save the figure 1
if SAVE == 1
    name_to_save = '3D Graph';
    savelocation = strcat(SAVE_FOLDER,name_to_save);
    saveas(gcf,savelocation);
end;

%% Save the data mat
if SAVE == 1
    save([SAVE_FOLDER,'Data.mat']);
end;



CirclesMat = MATRIX_CIRCLES(:,1,1);
for i=2:NUM_OF_GREAT_CIRCLES    
    CirclesMat(:,i) = MATRIX_CIRCLES(:,1,i);
end;
CirclesMat = rot90(CirclesMat);