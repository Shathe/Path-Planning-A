function exp_nodo = add_expanded(x,y,exp_nodo, coste_acumulado, Closed, xTarget,yTarget, coste_paso)

distancia = sqrt((yTarget - y)^2 + (xTarget - x)^2);
if  ~is_member(x,y,Closed);
    coste_total = coste_acumulado + coste_paso;
    
    exp_nodo = [exp_nodo ; x y coste_total distancia (distancia + coste_total) ];
end                           