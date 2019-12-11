src = 'static\djoncharts\dicoms\079';
dcms = dir([src, '\*.dcm']);
VV = zeros(512, 512, length(dcms), 'uint16');

for i=1:1:length(dcms)
    fprintf('%s\n', dcms(i).name);
    im = dicomread([src, '\', dcms(i).name]);
    VV(:, :, length(dcms) - i + 1) =  im;
end

save('raw_volume.mat', 'VV');