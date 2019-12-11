% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% load mask and get the centerline %%%%%%%%%%%%%%%%%%
% load 'mask.mat';
% load 'raw_volume.mat'
% V = logical(V);
% 
% skel = bwskel(V, 'MinBranchLength',50);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show centerline and the mask %%%%%%%%%%%%%%%%%%%%%%
% figure();
% col=[.7 .7 .8];
% hiso = patch(isosurface(V,0),'FaceColor',col,'EdgeColor','none');
% hiso2 = patch(isocaps(V,0),'FaceColor',col,'EdgeColor','none');
% axis equal;axis off;
% lighting phong;
% isonormals(V,hiso);
% alpha(0.5);
% set(gca,'DataAspectRatio',[1 1 1])
% camlight;
% hold on;
% w=size(skel,1);
% l=size(skel,2);
% h=size(skel,3);
% [x,y,z]=ind2sub([w,l,h],find(skel(:)));
% plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','r','Color','r');            
% set(gcf,'Color','white');
% view(140,80)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show centerline pointwise and get the
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% begin and end points of main aorta
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% manually

% w=size(skel,1);
% l=size(skel,2);
% h=size(skel,3);
% [x,y,z]=ind2sub([w,l,h],find(skel(:)));
% 
% for i = 1:1:length(x)
%     a = x(i);
%     b = y(i);
%     c = z(i);
%     scatter3(b, a, c, 4, [0, 1, 0], 'filled');
%     hold on;
%     pause(0.01);
%     fprintf('%d, x : %d, y : %d, z : %d\n', i, a, b, c);
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get the shortest path from begin to end

% % 109: begin: 1135, x : 240, y : 273, z : 496, end :804, x : 261, y : 275, z : 234
centerList = [x, y, z];

%%%%% constructing adjacent matrix %%%%%%
distance_matrix = 1.0 ./ zeros(length(x));

for i = 1:1:length(x)
    for j = 1:1:length(x)
        p1 = centerList(i, :);
        p2 = centerList(j, :);
        distance = sqrt((p1(1) - p2(1)) ^ 2 + (p1(2) - p2(2)) ^ 2 + (p1(3) - p2(3)) ^ 2);
        if distance < 2
            distance_matrix(i, j) = distance;
        end
    end
end

[res_distance, res_path] = mydijkstra(distance_matrix, 804, 1135);

res_path = res_path';
for i = 1:1:size(res_path)
    point = centerList(res_path(i), :);
    fprintf('x: %d, y: %d, z: %d \n', point(1), point(2), point(3));
    scatter3(point(2), point(1), point(3), 4, [0, 1, 0], 'filled');
    hold on;
    pause(0.01);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%get final sections and you can visualize them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%by volume viewer
[section,bw,mean_sec,std_sec,long_sec,short_sec] = get_section(single(VV),centerList(res_path, :), V);