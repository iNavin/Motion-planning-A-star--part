clear
clc
clf

[scenario, egoVehicle] = navin();
poly_obs = get_obstacles(scenario);

egox = egoVehicle.Position(1);
egoy = egoVehicle.Position(2);

axis equal
hold on
% for i=1:length(poly_obs)
% plot(poly_obs{i});
% hold on
% end
%% 
[out_pointsx,out_pointsy] = get_map_polygon(scenario);
plot(out_pointsx,out_pointsy,'rx') 
%% 
figure;
map = binaryOccupancyMap(200,450,1);
% tmp = out_pointsx;
% out_pointsx = -out_pointsy;
% out_pointsy = tmp;

setOccupancy(map, [100-out_pointsy 20+out_pointsx], ones(length(out_pointsx),1));
show(map)

%% 

inflate(map, 0.1)
figure
show(map)
%% 

%map.GridOriginInLocal = [-map.XLocalLimits(2)/2,-map.YLocalLimits(2)/2];
%show(map)

mapData = occupancyMatrix(map);

startPose = [42 32 pi/2];
%startPose = [15 42  0];
goalPose = [ 150 100  -pi/2];


refPath = hastarpathplanner(mapData,startPose,goalPose);

show(binaryOccupancyMap(mapData))
hold on
% Start state
scatter(startPose(1,1),startPose(1,2),"g","filled")
% Goal state
scatter(goalPose(1,1),goalPose(1,2),"r","filled")
% Path
plot(path(:,1),path(:,2),"r-",LineWidth=2)
legend("Start Pose","Goal Pose","MATLAB Generated Path")
legend(Location="northwest")

%% 
options = optimizePathOptions;
options.MinTurningRadius = 3; % meters
options.MaxVelocity = 5; % m/s
options.MaxAcceleration = 1; % m/s/s
options.ReferenceDeltaTime = 0.1; % second

separationBetweenStates = 0.2; % meters
numStates = refPath.pathLength/separationBetweenStates;
options.MaxPathStates = round(numStates);

options.ObstacleSafetyMargin = 2; % meters
options.ObstacleInclusionDistance = 0.75; % meters
options.ObstacleCutOffDistance = 2.5; %i meters

options.NumIteration = 4; 
options.MaxSolverIteration = 15;

options.WeightTime = 10;
options.WeightSmoothness = 1000;
options.WeightMinTurningRadius = 10;
options.WeightVelocity = 10;
options.WeightObstacles = 50;

[optimizedPath,kineticInfo] = optimizePath(path,map,options);

