function[polygon,] = get_obstacles(scenario)

for i = 1:length(scenario.Actors)
    xp = scenario.Actors(i+1).Position(1);
    yp = scenario.Actors(i+1).Position(2);
    l = scenario.Actors(i+1).dimensions.Length;
    w = scenario.Actors(i+1).dimensions.Width;
    x1 = xp;
    x2 = xp;


