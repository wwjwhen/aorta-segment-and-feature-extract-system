from django.conf.urls import url
from . import views
from django.views.generic import RedirectView
from django.urls import path

app_name = 'djoncharts'

urlpatterns = [
   url(r'^main/$', views.main, name='zhexian'),
   #url(r'^get_section/$', views.get_section_bk, name='add'),
]

