%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Planificación de caminos con algoritmo A*
% Retícula con celdas del mismo tamaño
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Adquisición o construcción de mapa (retícula): MAP
% Opciones: 
%   0: Mapa ya en memoria
%   1: Crear nuevo mapa interacticamente
%   2: Desde un fichero en el que está guardado

mapa=input('¿Nuevo mapa? (en memoria-0/crear-1/en fichero-2): ');
if mapa==1
    create_map
elseif mapa==0
    draw_map
else
    %fichero=input('Nombre fichero: ');
    load('laberinto.mat','escenaastar','escena') 
    MAP=escenaastar';
  % escribir estados inicial y final
xTarget = 18; yTarget = 18;
xStart = 2; yStart = 14;
    % xTarget=19; yTarget= 16;

    draw_map
    % 1,7       1,17       14,2      16,20  20,15
end

% búsqueda con vecindad:4/8
vecindad= 4; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creación de listas OPEN y CLOSED para A*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LISTA OPEN
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN=[];

% LISTA CLOSED
%--------------
%X val | Y val |
%--------------
CLOSED=[];
MAX_X=size(MAP,1);
MAX_Y=size(MAP,2);
% Inicializa CLOSED con los obstáculos
k=1;%Dummy counter
for i=1:MAX_X
    for j=1:MAX_Y
        if(MAP(i,j) == -1)
            CLOSED(k,1)=i; 
            CLOSED(k,2)=j; 
            k=k+1;
        end
    end
end
CLOSED_COUNT=size(CLOSED,1);

% Inicializa OPEN con el primer nodo (posición Inicio)
% xStart=Start(1,1); yStart=Start(1,2);
% xTarget=Target(1,1); yTarget=Target(1,2);

xNode=xStart;
yNode=yStart;
OPEN_COUNT=1;
path_cost=0;
goal_distance=sqrt((xNode - xTarget)^2 +  (yNode - yTarget)^2);
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,xNode,yNode,path_cost,goal_distance,goal_distance);
OPEN(OPEN_COUNT,1)=0;
CLOSED_COUNT=CLOSED_COUNT+1;
CLOSED(CLOSED_COUNT,1)=xNode;
CLOSED(CLOSED_COUNT,2)=yNode;
Path=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algoritmo de búsqueda A*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while((xNode ~= xTarget || yNode ~= yTarget) && Path == 1)
%  Expande nodo con las celdas vecinas
%  Opciones: 4-vecindad/8-vecindad
 exp_nodo=expande_nodo(xNode,yNode,path_cost,xTarget,yTarget,CLOSED,MAX_X,MAX_Y,vecindad);
 exp_count=size(exp_nodo,1);
 % Actualiza OPEN con los nodos sucesores
 % Formato Lista OPEN
 %--------------------------------------------------------------------------
 % IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
 %--------------------------------------------------------------------------

 % Formato Lista EXPANDED
 %--------------------------------
 %|X val |Y val ||h(n) |g(n)|f(n)|
 %--------------------------------
 for i=1:exp_count
     %no introducir abiertos repetidos, y si está , qeduarte solo con el de
     %fn minimo
     if size(OPEN(OPEN(:,1) == 1 & OPEN(:,2)==exp_nodo(i, 1) & OPEN(:,3) == exp_nodo(i, 2),:),1) > 0
         [ col_min col_argmin ] = min(OPEN(:,8),[],  1 );
         if col_min >exp_nodo(i, 5)
             OPEN(col_argmin,:)=insert_open(exp_nodo(i, 1),exp_nodo(i, 2),xNode,yNode,exp_nodo(i, 3), exp_nodo(i, 4),exp_nodo(i, 5));
         end
     else
         OPEN_COUNT = OPEN_COUNT + 1 ;
         OPEN(OPEN_COUNT,:)=insert_open(exp_nodo(i, 1),exp_nodo(i, 2),xNode,yNode,exp_nodo(i, 3), exp_nodo(i, 4),exp_nodo(i, 5));
     end
 end; %End of i for
 
 %Find out the node with the smallest fn 
  index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget);
  if (index_min_node ~= -1)    
   %Set xNode and yNode to the node with minimum fn
   xNode=OPEN(index_min_node,2);
   yNode=OPEN(index_min_node,3);
   path_cost=OPEN(index_min_node,6);%Update the cost of reaching the parent node
  %Move the Node to list CLOSED
  CLOSED_COUNT=CLOSED_COUNT+1;
  CLOSED(CLOSED_COUNT,1)=xNode;
  CLOSED(CLOSED_COUNT,2)=yNode;
  OPEN(index_min_node,1)=0; % lo elimina de OPEN
  else
      %No path exists to the Target!!
      Path=0;%Exits the loop!
  end;%End of index_min_node check

end;%End of While Loop

% Obtiene el camino óptimo y su longitud a partir del último nodo (el objetivo) hasta el
% nodo que corresponde a la celda inicial. Para ello recorre la lista donde
% está la solución

% camino_optimo
%%%%%%%%%%%%%%%%%%%%% COMPLETAR %%%%%%%%%%%%%%%%%%%
j = 1;
Optimal_path=[];
Optimal_path(j,1) = xTarget;
Optimal_path(j,2) = yTarget;
while xStart ~= Optimal_path(j,1) || yStart ~= Optimal_path(j,2)
    siguiente = OPEN(OPEN(:,1) == 0 & OPEN(:,2)==Optimal_path(j,1) & OPEN(:,3) == Optimal_path(j,2),:);
    if size(siguiente,1) > 1
        % escoger el de menor coste OPEN(:,6)
        [ col_min col_argmin ] = min(siguiente(:,6),[],  1 );
         siguiente = siguiente(col_argmin,:);
    end
    j = j + 1;
    Optimal_path(j,1) = siguiente(1, 4);
    Optimal_path(j,2) = siguiente(1, 5);
    Optimal_path
end
 % Dibuja el camino óptimo si existe, en variable Optimal_path
if Path  
 p=plot(Optimal_path(j,1)+.5,Optimal_path(j,2)+.5,'ro');
 j=j-1;
 for i=j:-1:1
  pause(.25);
  set(p,'XData',Optimal_path(i,1)+.5,'YData',Optimal_path(i,2)+.5);
 drawnow ;
 end;
 plot(Optimal_path(:,1)+.5,Optimal_path(:,2)+.5,'r','LineWidth',2);
else
 pause(1);
 h=msgbox('Sorry, No path exists to the Target!','warn');
 uiwait(h,5);
end
title('camino A* (red line)')






