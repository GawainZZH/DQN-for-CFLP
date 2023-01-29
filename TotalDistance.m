function TD = TotalDistance(Dist, State)


m = length(State);
%n = length(loc);
% State = [0,0,1,0,1,0,0,0];
loc = find(State~=0);
target = zeros(m,1);
distance = zeros(m,1);

for i = 1:m
    temp = Dist(i,loc);
    [~ ,b] = min(temp);
    target(i) = loc(b);
    distance(i) = Dist(i,target(i));
end

TD = sum(distance);



    

