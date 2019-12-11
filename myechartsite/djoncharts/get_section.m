function get_section(volume_path, center_list_path, bw_volume_path)

volume      = load(volume_path);
center_list = load(center_list_path);
bw_volume   = load(bw_volume_path);

r = 35;
section = zeros(2 * r + 1,2 * r + 1,size(center_list,1));
bw = false(size(section));
mean_sec  = zeros(size(center_list,1),1);
std_sec   = zeros(size(center_list,1),1);
long_sec  = zeros(size(center_list,1),1);
short_sec = zeros(size(center_list,1),1);

volume = single(volume.VV);
center_list = center_list.mypath;
bw_volume = logical(bw_volume.V);

volume = padarray(volume, [50 50 50], 0);
bw_volume = padarray(bw_volume, [50, 50, 50], false);
center_list = center_list + 50;

for i = 2 : size(center_list,1) - 1
    fprintf('now center point %d \n', i);
    cen_point = center_list(i,:);
    x0 = cen_point(1); y0 = cen_point(2); z0 = cen_point(3);
    norm_vec = center_list(i + 1,:) - center_list(i - 1,:);
    %Ax + By + Cz = Ax0 + By0 + Cz0
    A = norm_vec(1); B = norm_vec(2); C = norm_vec(3);
    if C ~= 0
        x_vec = [0 0 (A * x0 + B * y0 + C * z0) / C] - cen_point;
    elseif B ~= 0
        x_vec = [0 (A * x0 + B * y0 + C * z0) / B 0] - cen_point;
    else
        x_vec = [(A * x0 + B * y0 + C * z0) / A 0 0] - cen_point;
    end
    y_vec = cross(norm_vec,x_vec);
    x_vec = x_vec / norm(x_vec);
    y_vec = y_vec / norm(y_vec);
    point_list = [];
    for j = -r : r
        for k = -r : r
            point1 = round(cen_point + j * x_vec + k * y_vec);
            x1 = point1(1); y1 = point1(2); z1 = point1(3);
            section(j + r + 1,k + r + 1,i) = volume(x1,y1,z1);
            bw(j + r + 1,k + r + 1,i) = bw_volume(x1,y1,z1);
            if bw_volume(x1,y1,z1)
                point_list = [point_list; volume(x1,y1,z1)];
            end
        end
    end
	
    mean_sec(i) = mean(point_list);
    std_sec(i) = std(point_list);
    short_sec(i) = r * 2;
    long_sec(i) = 0;
    edge_bw = edge(bw(:,:,i),'Canny');
    for j = -r : r
        for k = -r : r
            if edge_bw(j + r + 1,k + r + 1)
                short_sec(i) = min(short_sec(i),sqrt(j * j + k * k));
                long_sec(i) = max(long_sec(i),sqrt(j * j + k * k));
            end
        end
    end
end

save(['djoncharts\', 'section.mat'], 'section');
save(['djoncharts\', 'mean_sec.mat'], 'mean_sec');
save(['djoncharts\', 'std_sec.mat'], 'std_sec');
save(['djoncharts\', 'long_sec.mat'], 'long_sec');
save(['djoncharts\', 'short_sec.mat'], 'short_sec');


end