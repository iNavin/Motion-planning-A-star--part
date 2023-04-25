function path = hastarpathplanner(mapData,startPose,goalPose)
    %#codegen
       
    map = binaryOccupancyMap(mapData);
    %map = mapData

    % Create a state space object
    stateSpace = stateSpaceSE2;

    % Update state space bounds to be the same as map limits.
    stateSpace.StateBounds = [map.XWorldLimits;map.YWorldLimits;[-pi pi]];

    % Construct a state validator object using the statespace and map object
    validator = validatorOccupancyMap(stateSpace,Map=map);
    
    % Set the validation distance for the validator
    validator.ValidationDistance = 0.01;
    
    % Assign the state validator object to the plannerHybridAStar object
    planner = plannerHybridAStar(validator,MinTurningRadius=3,MotionPrimitiveLength=4);
    
    % Compute a path for the given start and goal poses
    pathObj = plan(planner,startPose,goalPose);
    
    % Extract the path poses from the path object
    path = pathObj.States;

end