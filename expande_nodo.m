function exp_nodo=expande_nodo(node_x,node_y,hn,xTarget,yTarget,CLOSED,MAX_X,MAX_Y,vecindad)
    % Función que expande un nodo con las celdas vecinas
    % Devuelve la lista de sucesoras expandidas y su valor de coste fn
    % Las sucesoras no pueden ser las que están en la lista CLOSED, ni la
    % propia.
    % El argumento de entrada "vecindad" selecciona la 4/8 vecindad

     % Formato del nodo expandido
     %--------------------------------
     %|X val |Y val ||h(n) |g(n)|f(n)|  
     % , h-> coste actual g-> heuristica f-> suma
     %--------------------------------
   
   exp_nodo=[];
    % vecindad 4
    % Expandes los nodos

    if MAX_X > node_x 
        x = (node_x + 1); y = node_y;
        exp_nodo = add_expanded(x,y,exp_nodo,hn,CLOSED, xTarget,yTarget, 1);
    end
    
    if MAX_Y > node_y 
        x = (node_x ); y = node_y + 1;
        exp_nodo = add_expanded(x,y,exp_nodo,hn,CLOSED, xTarget,yTarget, 1);

    end
    
    if  node_x > 1
        x = (node_x - 1); y = node_y;
        exp_nodo = add_expanded(x,y,exp_nodo,hn,CLOSED, xTarget,yTarget, 1);

    end
    
    if  node_y > 1 
        x = (node_x ); y = node_y - 1;
        exp_nodo = add_expanded(x,y,exp_nodo,hn,CLOSED, xTarget,yTarget, 1);
    end
        

    
   if vecindad == 8
       % vecindad 8
      % Expandes los nodos
        if MAX_X > node_x && MAX_Y > node_y
            x = node_x + 1; y = node_y + 1;
            exp_nodo = add_expanded(x,y,exp_nodo,hn,CLOSED, xTarget,yTarget, sqrt(2) );
        end

        if  node_y > 1 && node_x > 1
            x = node_x -1 ; y = node_y - 1;
            exp_nodo = add_expanded(x,y,exp_nodo,hn,CLOSED, xTarget,yTarget, sqrt(2));
        end

        if  node_x > 1 && MAX_Y > node_y 
            x = (node_x - 1); y = node_y + 1;
            exp_nodo = add_expanded(x,y,exp_nodo,hn,CLOSED, xTarget,yTarget, sqrt(2));
        end

        if  MAX_X > node_x && node_y > 1 
            x = (node_x + 1); y = node_y - 1;
            exp_nodo = add_expanded(x,y,exp_nodo,hn,CLOSED, xTarget,yTarget, sqrt(2));
        end

    
   end
   