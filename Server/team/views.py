from django.shortcuts import render
from team.models import Team, Championship
from team.serializers import TeamSerializer, ChampionshipSerializer
from rest_framework import generics


# Create your views here.
class ChampionshipList(generics.ListCreateAPIView):
    queryset = Championship.objects.all()
    serializer_class = ChampionshipSerializer


class ChampionshipDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Championship.objects.all()
    serializer_class = ChampionshipSerializer


class TeamList(generics.ListCreateAPIView):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer


class TeamDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer
