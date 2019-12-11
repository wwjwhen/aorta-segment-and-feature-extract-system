function get_centerline(path2mask)
	load(path2mask);
	V = logical(V);
	skel = bwskel(V, 'MinBranchLength',50);
	w=size(skel,1);
	l=size(skel,2);
	h=size(skel,3);
	[xx,yy,zz]=ind2sub([w,l,h],find(skel(:)));
	x = [];
	y = [];
	z = [];
	ind = [];
	
	for i = 1:length(xx)
		x = [x, xx(i, 1)];
		y = [y, yy(i, 1)];
		z = [z, zz(i, 1)];
		ind = [ind, i];
	end
	
	x = x';
	y = y';
	z = z';
	ind = ind';
	
	save(['djoncharts\', 'section_x'], 'x');
	save(['djoncharts\', 'section_y'], 'y');
	save(['djoncharts\', 'section_z'], 'z');
	save(['djoncharts\', 'section_ind'], 'ind');
	
end