global t TempReward RealDistance Stateinfo FirstS

iteration = 200;

TempReward = zeros(iteration,8);
RealDistance = zeros(iteration,8);
Stateinfo = zeros(iteration,8);
FirstS = zeros(iteration,8);

t = 1;

ObsInfo = rlNumericSpec([8 1]);
ActionInfo = rlFiniteSetSpec(1:8);

env = rlFunctionEnv(ObsInfo,ActionInfo,'myStepFunction','myResetFunction');

obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

dnn = [
    featureInputLayer(obsInfo.Dimension(1),'Normalization','none','Name','state')
    fullyConnectedLayer(32,'Name','CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(32, 'Name','CriticStateFC2')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(length(actInfo.Elements),'Name','output')];

% figure
% plot(layerGraph(dnn))

criticOpts = rlRepresentationOptions('LearnRate',0.0001,'GradientThreshold',1);
critic = rlQValueRepresentation(dnn,obsInfo,actInfo,'Observation',{'state'},criticOpts);

agentOpts = rlDQNAgentOptions(...
    'UseDoubleDQN',false, ...    
    'TargetSmoothFactor',1, ...
    'TargetUpdateFrequency',3, ...   
    'ExperienceBufferLength',10000, ...
    'DiscountFactor',0.8, ...
    'MiniBatchSize',32);

agent = rlDQNAgent(critic,agentOpts);


trainOpts = rlTrainingOptions(...
    'MaxEpisodes',iteration, ...
    'MaxStepsPerEpisode',5, ...   
    'Verbose',true, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',480);


trainOpts.SaveAgentCriteria = "EpisodeReward";
trainOpts.SaveAgentValue = 500;
trainOpts.SaveAgentDirectory = "savedAgents";


doTraining = true;
if doTraining    
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);
else
    % Load the pretrained agent for the example.
    load('MATLABCartpoleDQNMulti.mat','agent')
end

a = load('D:\MATLAB\bin\IEEM2023\results.mat');
Rewardinfo = sum(a.TempReward,2);
save('D:\MATLAB\bin\IEEM2023\Rewardinfo', 'Rewardinfo')
