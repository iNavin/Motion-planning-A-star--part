clear
clc
clf

%scenario ego vehicle information, obstcale dimensions
[scenario, egoVehicle] = test_scene();
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
map = binaryOccupancyMap(90,90,1);
%map = binaryOccupancyMap(180,450,1);
tmp = out_pointsx;
out_pointsx = -out_pointsy;
out_pointsy = tmp;

setOccupancy(map, [50-out_pointsy 50+out_pointsx], ones(length(out_pointsx),1));
%setOccupancy(map, [-out_pointsy 100+out_pointsx], ones(length(out_pointsx),1));
show(map)
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
stateValidator.ValidationDistance = 0.01;
planner = plannerHybridAStar(stateValidator,MinTurningRadius=4);

start = [35 55 -pi/2];
%startPose = [15 42  0];
goal = [ 75 22  0];

% start = [40 50 0];
% %start = [350 50 0];
% %startPose = [15 42  0];
% goal = [ 102 30 -pi/2];

path = plan(planner,start,goal);
inpath = path.States;

show(binaryOccupancyMap(map))
hold on
% Start state
scatter(start(1,1),start(1,2),"g","filled")
% Goal state
scatter(goal(1,1),goal(1,2),"r","filled")
% Path
plot(inpath(:,1),inpath(:,2),"r-",LineWidth=2)
legend("Start Pose","Goal Pose","MATLAB Generated Path")
legend(Location="northwest")
%% 
%optimize path
options = optimizePathOptions;
options.ObstacleSafetyMargin = 1;
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

