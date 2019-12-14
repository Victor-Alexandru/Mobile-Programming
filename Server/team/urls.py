from django.urls import path
from team import views

urlpatterns = [
    path('championships/', views.ChampionshipList.as_view()),
    path('championships/<int:pk>/', views.ChampionshipDetail.as_view()),
    path('teams/', views.TeamList.as_view()),
    path('teams/<int:pk>/', views.TeamDetail.as_view()),
]
