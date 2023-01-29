function [InitialObservation, LoggedSignals] = myResetFunction()



coord = [0.77,0.85; 0.32,0.75; 0.20,0.59; 0.85,0.48; 0.38,0.43; 0.58,0.40; 0.87,0.26; 0.26,0.21];

 for i = 1:length(coord)
     for j = 1:length(coord)
        d(i,j) = sqrt((coord(i,1)-coord(j,1))^2+(coord(i,2)-coord(j,2))^2);
     end
 end
 
DG = sparse(d);
Dist = graphallshortestpaths(DG);


LoggedSignals.Dist = Dist;
LoggedSignals.State = zeros(length(coord), 1);
LoggedSignals.Flag = 0;
LoggedSignals.R = 0;
InitialObservation = LoggedSignals.State;
LoggedSignals.Stateinfo = zeros(1,8);

end