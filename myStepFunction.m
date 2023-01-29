function [NextObs,Reward,IsDone,LoggedSignals] = myStepFunction(Action,LoggedSignals)

global t TempReward RealDistance Stateinfo

% 提取参数

Dist = LoggedSignals.Dist;
flag = LoggedSignals.Flag;
State = LoggedSignals.State;
R = LoggedSignals.R;

Node = Action;
 

if State(Node) == 1
    TD = TotalDistance(Dist, State);
    flag = flag+1;
    Reward = -1.5;
else
    State(Node) = 1;
    flag = flag+1; % update the flag signal
    TD = TotalDistance(Dist, State);
    Reward = -(TD - R);

end

TempReward(t,flag) = Reward;
RealDistance(t,flag) = TD;


LoggedSignals.R = TD;
LoggedSignals.State = State;
LoggedSignals.Flag = flag;
NextObs = LoggedSignals.State;


if sum(State)==4
    Stateinfo(t,:) = State';
    t = t + 1;
    save('D:\MATLAB\bin\IEEM2023\results.mat')
    IsDone = true;
else
    IsDone = false;
end


