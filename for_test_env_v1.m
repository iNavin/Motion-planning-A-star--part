clear
clc
clf

%scenario ego vehicle information, obstcale dimensions
[scenario, egoVehicle] = test_env_v1();
poly_obs = get_obstacles(scenario);

egox = egoVehicle.Position(1);
egoy = egoVehicle.Position(2);

axis equal
hold on
for i=1:length(poly_obs)
plot(poly_obs{i});
hold on
end
%% 
[out_pointsx,out_pointsy] = get_map_polygon(scenario);
plot(out_pointsx,out_pointsy,'rx') 
%% 
figure;
%map = binaryOccupancyMap(300,300,1);
%plot((out_pointsx + abs(min(out_pointsx))),(out_pointsy - abs(min(out_pointsy))) ,'rx')

%map = binaryOccupancyMap(min(out_pointsx)+300,min(out_pointsy)+300,1);

map = binaryOccupancyMap(max(out_pointsx + abs(min(out_pointsx))),max(out_pointsy - abs(min(out_pointsy))),1);


% tmp = out_pointsx;
% out_pointsx = -out_pointsy;
% out_pointsy = tmp;

%setOccupancy(map, [-out_pointsy +out_pointsx], ones(length(out_pointsx),1));
setOccupancy(map, [(out_pointsx + abs(min(out_pointsx))) (out_pointsy - abs(min(out_pointsy)))], ones(length(out_pointsx),1));

%setOccupancy(map, [-out_pointsy 100+out_pointsx], ones(length(out_pointsx),1));
show(map)
%%

%% 
%map.GridOriginInLocal = [-map.XLocalLimits(2)/2,-map.YLocalLimits(2)/2];
%show(map)

% mapData = occupancyMatrix(map);
% 
% startPose = [22 22 pi/2];
% %startPose = [15 42  0];
% goalPose = [ 50 63  0];
% 
% 
% %refPath = hastarpathplanner(mapData,startPose,goalPose);
% 
% planner = plannerHybridAStar(stateValidator,MinTurningRadius=2);
% refPath = planner(mapData,startPose,goalPose);
% 
% show(binaryOccupancyMap(mapData))
% hold on
% % Start state
% scatter(startPose(1,1),startPose(1,2),"g","filled")
% % Goal state
% scatter(goalPose(1,1),goalPose(1,2),"r","filled")
% % Path
% plot(refPath(:,1),refPath(:,2),"r-",LineWidth=2)
% legend("Start Pose","Goal Pose","MATLAB Generated Path")
% legend(Location="northwest")
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stateValidator = validatorOccupancyMap;
stateValidator.Map = map;
stateValidator.StateSpace.StateBounds  = [-100,500;-100,500;-3.141592653589793,3.141592653589793];
show(stateValidator.Map)
stateValidator.ValidationDistance = 0.01;
planner = plannerHybridAStar(stateValidator,MinTurningRadius=2);

start = [32.5 15.5 pi/2];
%start = 
%startPose = [15 42  0];
goal = [185 20 -pi/2];


% start = [40 50 0];
% %start = [350 50 0];
% %startPose = [15 42  0];
% goal = [ 102 30 -pi/2];

path = plan(planner,start,goal);
inpath = path.States;

options = optimizePathOptions;
options.MaxPathStates = 500;
options.ObstacleSafetyMargin = 2;
optpath = optimizePath(inpath,map,options);


show(binaryOccupancyMap(map))
hold on
% Start state
scatter(start(1,1),start(1,2),"g","filled")
% Goal state
scatter(goal(1,1),goal(1,2),"r","filled")
% Path
plot(inpath(:,1),inpath(:,2),"r-",LineWidth=2)
plot(optpath(:,1),optpath(:,2),"b-",LineWidth=2)
legend("Start Pose","Goal Pose","MATLAB Generated Path")
legend(Location="northwest")






