function[polygon] = get_obstacles(scenario)

polygon ={};
for i = 1:length(scenario.Actors)-1
    xp = scenario.Actors(i+1).Position(1);
    yp = scenario.Actors(i+1).Position(2);

    tmp = xp;
    xp = -yp;
    yp = tmp;
    
    l = scenario.Actors(i+1).dimensions.Length;
    w = scenario.Actors(i+1).dimensions.Width;
    % x1 = xp;
    % x2 = xp;
    % x3 = xp-l;
    % x4 = xp-l;
    % 
    % y1 = yp-(w/2);
    % y2 = yp+(w/2);
    % y3 = yp+(w/2);
    % y4 = yp-(w/2);
    if scenario.Actors(i+1).Yaw == 90
        x1 = xp;
        x2 = xp;
        x3 = xp-l;
        x4 = xp-l;

        y1 = yp-(w/2);
        y2 = yp+(w/2);
        y3 = yp+(w/2);
        y4 = yp-(w/2);

    else
        x1 = xp-(w/2);
        x2 = xp+(w/2);
        x3 = xp+(w/2);
        x4 = xp-(w/2);

        y1 = yp;
        y2 = yp;
        y3 = yp-l;
        y4 = yp-l;
    end

    % x1 = xp-(w/2);
    % x2 = xp+(w/2);
    % x3 = xp+(w/2);
    % x4 = xp-(w/2);
    % 
    % y1 = yp;
    % y2 = yp;
    % y3 = yp-l;
    % y4 = yp-l;
    x = [x1,x2,x3,x4,x1];
    y = [y1,y2,y3,y4,y1];

    polygon{i} = polyshape(x,y);
end







