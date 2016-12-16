function result = is_member(x,y,A)

result = sum(ismember(A, [x y], 'rows'));

end