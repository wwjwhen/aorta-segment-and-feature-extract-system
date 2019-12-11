import json
import os
import glob
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
import cv2
from scipy.io import loadmat

'''
cur  = 79

root = 'jpgs\\{}'.format(str(cur).zfill(3))

files = os.listdir(root)


for f in files:
	im = Image.open(os.path.join(root, f))
	im = im.resize((256, 256), Image.ANTIALIAS)
	im.save(os.path.join(root, f), format='JPEG')


for ind, f in enumerate(files):
	os.rename(os.path.join(root, f), os.path.join(root, str(ind + 1).zfill(5) + '.jpg'))


files = glob.glob('masks\\{}\\*.jpg'.format(str(cur).zfill(3)))
dst   =           'masks\\{}\\'.format(str(cur).zfill(3))

data = [['X', 'Y', 'Z']]

total = len(files)

num = 0
for index, f in enumerate(files):
	print(f)
	im = Image.open(f)
	im = np.asarray(im)
	im = im[:, :, 0]
	im = im[156:456, 106:406]
	#im = im[128:384, 128:384]
	#im = imresize(im, (100, 100))
	#cv2.imshow('frame', im)
	#cv2.waitKey(1)
	print(im.shape)
	ind = np.where(im == 255)
	for x, y in zip(ind[0], ind[1]):
		data.append([int(x), int(y), total - index])
		num += 1

print(num)

print(type(data))
with open(os.path.join(dst, 'data.json'), 'w') as f:
	json.dump(data, f)



src =     'heatmaps\\{}\\'.format(str(cur).zfill(3))
dst = 'heatmaps_new\\{}\\'.format(str(cur).zfill(3))

if not os.path.exists(dst):
	os.mkdir(dst)

files = os.listdir(src)

for ind, f in enumerate(files):
	R = 3 * np.ones((512, 512), dtype=np.uint8)
	G = 5 * np.ones((512, 512), dtype=np.uint8)
	B = 26 * np.ones((512, 512), dtype=np.uint8)
	tmp = np.array((R, G, B))
	tmp = tmp.transpose(1,2,0)
	print(tmp.shape)
	im = Image.open(os.path.join(src, f))
	im = np.asarray(im)
	im = im[13:-13, 14:-13, :]
	im = Image.fromarray(im)
	im = im.resize((300, 300))
	im = np.asarray(im)
	tmp[156:456, 106:406, :] = im
	im = Image.fromarray(tmp)
	im.save(os.path.join(dst, str(ind).zfill(5) + '.jpg'))
print(len(files))
'''




masks = 'masks'
heatmaps = 'heatmaps'
jpgs  = 'jpgs'
raws  = 'raw'

m_files = os.listdir(masks)
h_files = os.listdir(heatmaps)
j_files = os.listdir(jpgs)
r_files = os.listdir(raws)

assert len(m_files) == len(h_files)
assert len(r_files) == len(j_files)

for ind, (m, h, j, r) in enumerate(zip(m_files, h_files, j_files, r_files)):
	print(ind, ' : ', m, h, j, r)
	os.rename(os.path.join(masks, m), os.path.join(masks, str(ind + 1).zfill(3)))
	os.rename(os.path.join(heatmaps, h), os.path.join(heatmaps, str(ind + 1).zfill(3)))
	os.rename(os.path.join(jpgs, j), os.path.join(jpgs, str(ind + 1).zfill(3)))
	os.rename(os.path.join(raws, r), os.path.join(raws, str(ind + 1).zfill(3)))
