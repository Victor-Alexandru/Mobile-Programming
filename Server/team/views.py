from django.shortcuts import render, get_object_or_404
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
    serializer_class = TeamSerializer

    def get_queryset(self):
        # import  ipdb;
        # ipdb.set_trace()
        id = self.request.query_params.get("championship_id")
        if id:
            championship = get_object_or_404(Championship, pk=int(id))
            return Team.objects.all().filter(championship=championship)
        else:
            return Team.objects.all()

    def perform_create(self, serializer):
        id = serializer.validated_data.get('championship_id')
        if id:
            championship = get_object_or_404(Championship, pk=id)
            serializer.save(championship=championship)
        else:
            raise PermissionError("Not all data on the request")


class TeamDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Team.objects.all()
    serializer_class = TeamSerializer

    def perform_update(self, serializer):
        id = serializer.validated_data.get('championship_id')
        if id:
            championship = get_object_or_404(Championship, pk=id)
            serializer.save(championship=championship)
        else:
            raise PermissionError("Not all data on the request")
