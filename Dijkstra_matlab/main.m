%% Define a small map
clc
clear
close all;

map = false(20);    % 0值矩阵

% Add an obstacle
map(11:20, 5) = true;
map(11,5:14) = true;
map( 1:7,10) = true;

start_coords = [16,2];
dest_coords  = [16,10];

%%
[route, numExpanded] = dijkstragrid(map, start_coords, dest_coords);
disp(['路径长度：', num2str(length(route))]);
disp(['已探索节点：', num2str(numExpanded)]);