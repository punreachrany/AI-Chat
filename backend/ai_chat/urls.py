# ai_chat/urls.py

from django.urls import path
from .views import ChatView

urlpatterns = [
    path('chat/', ChatView.as_view(), name='chat'),
]
