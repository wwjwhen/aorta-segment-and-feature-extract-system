src = 'static\djoncharts\masks\079';
jpegs = dir([src, '\*.jpg']);
Vtmp = zeros(300, 300, length(jpegs), 'uint8');
V = zeros(512, 512, length(jpegs), 'uint8');

for i=1:1:length(jpegs)
    im = imread([src, '\', jpegs(i).name]);
    windowSize = 8;
    kernel = ones(windowSize) / windowSize ^ 2;
    binaryImage = rgb2gray(im);
    blurryImage = conv2(single(binaryImage), kernel, 'same');
    binaryImage = blurryImage > 100; % Rethreshold
    binaryImage = imfill(binaryImage, 'holes');
    Vtmp(:, :, length(jpegs) - i + 1) = binaryImage;
    %imwrite(repmat(V(:, :, i), [1,1,3]), [src, '\', num2str(i, '%05d'), '.jpg']);
    fprintf('%s\n', jpegs(i).name);
end


[L, n] = bwlabeln(Vtmp, 6);
stats = regionprops3(L);
Ar = cat(1, stats.Volume);
ind = find(Ar ==max(Ar));
Vtmp(find(L~=ind)) = 0; %将其他区域置为0
total = size(Vtmp, 3);

for i=1:total
    tmp = zeros([512, 512]);
    tmp(156:455, 106:405) = Vtmp(:, :, total - i + 1);
    V(:, :, total - i + 1) = tmp;
    im = repmat(tmp, [1, 1, 3]);
    imwrite(im * 255, ['static\djoncharts\masks_new\', num2str(i, '%06d'), '.jpg']);
end

save([src, '\', 'mask.mat'], 'V');
[L_new, n_new] = bwlabeln(Vtmp, 6);
stats_new = regionprops3(L_new);