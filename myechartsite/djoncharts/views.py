# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render
from django.http import HttpResponseRedirect, JsonResponse
from django.shortcuts import redirect
from django.urls import path
from django.views.generic import RedirectView
import os
import matlab
import matlab.engine
from scipy.io import loadmat
import json
from PIL import Image
import numpy as np

'''
# Create your views here.
def main(request):
	print('here')
	return render(request, 'djoncharts/main.html')
'''


engine = matlab.engine.start_matlab()


def main(request):
    name_num = []
    base_folder = os.path.dirname(os.path.realpath(__file__))   # get base dir
    engine.addpath(base_folder)
    folder_path = os.path.join(base_folder, "static\\djoncharts\\jpgs")      # insert the path to your directory   
    file_list =os.listdir(folder_path)
    for f in file_list:
    	num = len(os.listdir(os.path.join(folder_path, f)))
    	name_num.append((f, num))
    if request.method == 'POST':
    	typ = int(request.POST.get('type'))
    	# this part is for 
    	if typ == 0:
    		page_id = int(request.POST.get('page_id'))
    		res = {}
    		res['result'] = name_num[15*(page_id - 1) : 15 * page_id]
    		return JsonResponse(res)

    	# this part is for simplify the centerline   		
    	if typ == 1:
    		x1 = int(request.POST.get('x1'))
    		x2 = int(request.POST.get('x2'))
    		res = {}
    		engine.selected(x1, x2)
    		simple = loadmat(os.path.join(base_folder, 'simple'))['mypath']
    		print(simple.shape)
    		json_data = [['X', 'Y', 'Z', 'ind']]
    		total = simple.shape[0]
    		for index in range(total):
    			json_data.append([int(simple[index][0]), int(simple[index][1]), int(simple[index][2]), index])
    		with open(os.path.join(base_folder, 'static\\djoncharts', 'data_centerline_ind_simple.json'), 'w') as f:
    			json.dump(json_data, f)
    		res['result'] = 'success'
    		return JsonResponse(res)

    	# this part is for get centerline from the mask
    	if typ == 2:
    		path2mask = os.path.join(base_folder, "static\\djoncharts\\masks", request.POST.get('id'), 'mask.mat')
    		print(path2mask)
    		res = {}
    		engine.get_centerline(path2mask, nargout=0)
    		x = loadmat(os.path.join(base_folder, 'section_x'))['x']
    		y = loadmat(os.path.join(base_folder, 'section_y'))['y']
    		z = loadmat(os.path.join(base_folder, 'section_z'))['z']
    		ind = loadmat(os.path.join(base_folder, 'section_ind'))['ind']
    		print(x.shape)
    		json_data = [['X', 'Y', 'Z', 'ind']]
    		total = x.shape[0]
    		for index in range(total):
    			json_data.append([int(x[index][0]), int(y[index][0]), int(z[index][0]), int(ind[index][0])])
    		with open(os.path.join(base_folder, 'static\\djoncharts', 'data_centerline_ind.json'), 'w') as f:
    			json.dump(json_data, f)
    		res['result'] = 'success'
    		return JsonResponse(res)

    	if typ == 3:
    		path2mask = os.path.join(base_folder, "static\\djoncharts\\masks", request.POST.get('id'), 'mask.mat')
    		path2centerline = os.path.join(base_folder, 'simple.mat')
    		path2dicom = os.path.join(base_folder, "static\\djoncharts\\raw", request.POST.get('id'), 'raw_volume.mat')
    		print(path2dicom)
    		engine.get_section(path2dicom, path2centerline, path2mask, nargout=0)
    		data_mean = loadmat(os.path.join(base_folder, 'mean_sec'))['mean_sec']
    		data_std  = loadmat(os.path.join(base_folder, 'std_sec'))['std_sec']
    		data_long = loadmat(os.path.join(base_folder, 'long_sec'))['long_sec']
    		data_short = loadmat(os.path.join(base_folder, 'short_sec'))['short_sec']
    		data_section = loadmat(os.path.join(base_folder, 'section'))['section']

    		print(data_mean.shape)
    		total = data_mean.shape[1]
    		assert data_mean.shape == data_std.shape

    		axis_data = []
    		value_data = []
    		for index in range(total):
    			axis_data.append([data_short[0][index], data_long[0][index]])
    			value_data.append([data_mean[0][index], data_std[0][index]])
    			img_data = data_section[:, :, index]
    			max_data = np.max(img_data)
    			min_data = np.min(img_data)
    			img_data = 1.0 * (img_data - min_data)/(max_data - min_data + 1) * 256
    			img = Image.fromarray(img_data.astype(np.uint8))
    			img.convert('RGB').save(os.path.join(base_folder, 'static\\djoncharts\\sections', str(index).zfill(5) + '.jpg'))

    		with open(os.path.join(base_folder, 'static\\djoncharts', 'section_value.json'), 'w') as f:
    			json.dump(value_data, f)
    		with open(os.path.join(base_folder, 'static\\djoncharts', 'section_axis.json'), 'w') as f:
    			json.dump(axis_data, f)
    		res = {}
    		res['result'] = 'success'
    		return JsonResponse(res)

    return render(request, 'djoncharts/main.html', {'dicom_folders': name_num})


def add(request):
	print('get add request')
	#return render(request, 'djoncharts/add.html')
	#return HttpResponseRedirect('djoncharts/add.html') 
	#return redirect('https://www.baidu.com/')
	return render(request, 'djoncharts/sub.html')

	