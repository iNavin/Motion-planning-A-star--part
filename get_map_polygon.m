function[x_out,y_out] = get_map_polygon(scenario)

x = scenario.roadBoundaries{1}(:,1);
y = scenario.roadBoundaries{1}(:,2);

tmp = x;
x = -y;
y = tmp;

obs_poly = get_obstacles(scenario);
%if need be, can take minkowski sum of this obstacles


just_road_poly = polyshape(x,y);

for i = 1:length(obs_poly)
    just_road_poly = subtract(just_road_poly, obs_poly{i});
end

map_holes =  just_road_poly;

xv = map_holes.Vertices(:,1);
yv = map_holes.Vertices(:,2);

xq = unifrnd(min(xv)-5,max(xv)+5,1000000,1);
yq = unifrnd(min(yv)-5,max(yv)+5,1000000,1);
[in,on] = inpolygon(xq,yq,xv,yv);

x_out = xq(~in);
y_out = yq(~in);


% plot(xv,yv) % polygon
% axis equal
% hold on
% plot(xq(in),yq(in),'r+') % points inside
% plot(xq(~in),yq(~in),'bo') % points outside
% hold off





