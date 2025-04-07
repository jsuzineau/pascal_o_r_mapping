from django.urls import path
from django.contrib.auth.decorators import login_required
from .views import *

urlpatterns = \
  [  
  path("", login_required(IndexView.as_view())),   
  url.py_patterns_ListView,
  url.py_patterns_DetailView 
  ]
