function [route,numExpanded] = dijkstragrid (input_map, start_coords, dest_coords)
    
    % 色彩映射
    cmap = [1 1 1; ...% 1 - white - clear cell
            0 0 0; ...% 2 - black - obstacle
            0 0 1; ...% 3 - blue = visited
            1 1 0; ...% 4 - yellow  - on list
            0 1 0; ...% 5 - green - start
            1 0 0; ...% 6 - red - destination
	        1 0 1];   % 7 - 粉红色，用于显示路径
    colormap(cmap)
    
    % variable to control if the map is being visualized on every iteration
    drawMapEveryTime = true;
    
    [nrows, ncols] = size(input_map);
    
    % map - a table that keeps track of the state of each grid cell（一个表,跟踪每个网格单元的状态）
    map = zeros(nrows,ncols);
    map(~input_map) = 1;    % Mark free cells
    map(input_map)  = 2;    % Mark obstacle cells
    start_node = sub2ind(size(map), start_coords(1), start_coords(2));  % 起点在map中的线性索引值
    dest_node  = sub2ind(size(map), dest_coords(1),  dest_coords(2));   % 终点在map中的线性索引值
    map(start_node) = 5;    % 5-green
    map(dest_node)  = 6;    % 6-red
    
    % Initialize distance array
    distanceFromStart = Inf(nrows,ncols);   % 定义一个变量来保存蓝色邻居以及它们到起始格的路程.定义了 distanceFromStart  来保存这些信息，初始化为 Inf，表示从没有访问过。
                                            % 一旦有值，就说明是蓝色邻居，赋值的大小就表示该点跟起始点的路程。一旦变成蓝色，就把它的值再改回 Inf。
    
    % For each grid cell this array holds the index of its parent
    parent = zeros(nrows,ncols);            %定义一个变量来保存前驱
    
    distanceFromStart(start_node) = 0;      %起始点到起始点的距离为0
    
    % keep track of number of nodes expanded 
    numExpanded = 0;
    
    % Main Loop
    while true
        % Draw current map
        map(start_node) = 5;
        map(dest_node) = 6;
        
        % make drawMapEveryTime = true if you want to see how the nodes are expanded on the grid. 
        if (drawMapEveryTime)
            image(1.5, 1.5, map);   % image命令画图时，对于超出上下限的值，依旧按照上下限对应的颜色来画
            grid on;    % 打开网格
            axis image; % 图像坐标轴
            drawnow;    
        end
        
        % Find the node with the minimum distance
        [min_dist, current] = min(distanceFromStart(:));    % 搜索中心的索引坐标:current,搜索中心与起始点的路程:min_dist
        numExpanded = numExpanded + 1;  % 起点也算作一次
        
        if ((current == dest_node) || isinf(min_dist))      % 这里做一些简单判断，如果已经扩张到终点了，或者没有路径，则退出循环。
            break;
        end
        
        % Update map
        map(current) = 3;         % mark current node as visited 把 map 的前点坐标赋值为 3(蓝色) ，表示本次循环已经以此为中心搜索一次了。
        distanceFromStart(current) = Inf; % remove this node from further consideration
        
        % Compute row, column coordinates of current node
        [i, j] = ind2sub(size(distanceFromStart), current);% 把索引坐标变成行列坐标，方便计算邻居的坐标。
       
        % YOUR CODE BETWEEN THESE LINES OF STARS
        % neighbor = [i-1, j ;... 
        %             i+1, j ;... 
        %             i, j-1 ;... 
        %             i, j+1 ];

        neighbor = [i-1, j ;... 
                    i+1, j ;... 
                    i, j-1 ;... 
                    i, j+1 ;...
                    i-1, j-1;...
                    i+1, j-1;...
                    i-1, j+1;...
                    i+1, j+1];
                     
        outRangetest = (neighbor(:,1)<1) + (neighbor(:,1)>nrows) + (neighbor(:,2)<1) + (neighbor(:,2)>ncols);   % 一个列向量
        locate = find(outRangetest>0);  % 搜索越界邻居 
        neighbor(locate,:)=[];          % 删除neighbor中越界的邻居 =[]就是删除的意思。
        
        neighborIndex = sub2ind(size(map),neighbor(:,1),neighbor(:,2)); % 为了方便，现在把这种行列形式变为索引形式
        for a=1:length(neighborIndex)
            if ((map(neighborIndex(a))~=2) && (map(neighborIndex(a))~=3 && map(neighborIndex(a))~= 5))
                map(neighborIndex(a)) = 4;  % 在地图上把邻居变成黄色。这里纯为了显示用。
                
                % Visit each neighbor of the current node and update the map, distances and parent tables appropriately.
                beighbor_current = neighbor(a,:);
                if (beighbor_current(1)==i || beighbor_current(2)==j)   % 邻居位于当前点的同行或同列
                    if (distanceFromStart(neighborIndex(a))> min_dist + 1)
                        distanceFromStart(neighborIndex(a)) = min_dist+1;  %更新邻居的路程信息
                        parent(neighborIndex(a)) = current; % 更新邻居的路径信息
                    end
                else    % 邻居位于当前点的写对角线
                    if (distanceFromStart(neighborIndex(a))> min_dist + sqrt(2))
                        distanceFromStart(neighborIndex(a)) = min_dist+sqrt(2);  %更新邻居的路程信息
                        parent(neighborIndex(a)) = current; % 更新邻居的路径信息
                    end
                end
            end
        end

    end
    
    %% Construct route from start to dest by following the parent links
    if (isinf(distanceFromStart(dest_node)))
        route = [];%提取路线坐标
    else
        route = [dest_node];
        
        while (parent(route(1)) ~= 0)
            route = [parent(route(1)), route];% 动态显示出路线
        end
        
        % Snippet of code used to visualize the map and the path（代码片段用于可视化地图和路径）
        for k = 2:length(route) - 1        
            map(route(k)) = 7;%粉红色
            pause(0.1);
            image(1.5, 1.5, map);
            grid on;
            axis image;
        end
    end

end
