function res = selected(sb,db)
	load 'section_x';
	load 'section_y';
	load 'section_z';
	centerList = [x, y, z];
	%%%%% constructing adjacent matrix %%%%%%
	distance_matrix = 1.0 ./ zeros(length(x));
	for i = 1:1:length(x)
		for j = 1:1:length(x)
			p1 = centerList(i, :);
			p2 = centerList(j, :);
			distance = sqrt((p1(1) - p2(1)) ^ 2 + (p1(2) - p2(2)) ^ 2 + (p1(3) - p2(3)) ^ 2);
			if distance < 3
				distance_matrix(i, j) = distance;
			end
		end
	end
	%[~, res_path] = mydijkstra(distance_matrix, src, dst);
	a = distance_matrix;
	
	n=size(a,1); visited(1:n) = 0;
	distance(1:n) = inf; % 保存起点到各顶点的最短距离
	distance(sb) = 0; parent(1:n) = 0;
	for i = 1: n-1
		temp=distance;
		id1=find(visited==1); %查找已经标号的点
		temp(id1)=inf; %已标号点的距离换成无穷
		[t, u] = min(temp); %找标号值最小的顶点
		visited(u) = 1; %标记已经标号的顶点
		id2=find(visited==0); %查找未标号的顶点
		for v = id2
			if a(u, v) + distance(u) < distance(v)
				distance(v) = distance(u) + a(u, v); %修改标号值
				parent(v) = u;
			end
		end
	end

mypath = [];
if parent(db) ~= 0
	t = db; mypath = [db];
	while t ~= sb
		p = parent(t);
		mypath = [p mypath];
		t = p;
	end
end


mypath = centerList(mypath', :);


save(['djoncharts\', 'simple.mat'], 'mypath');
res = 'simple.mat';

end