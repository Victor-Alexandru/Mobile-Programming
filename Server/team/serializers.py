from rest_framework import serializers
from team.models import Team, Championship


class ChampionshipSerializer(serializers.ModelSerializer):
    teams = serializers.PrimaryKeyRelatedField(many=True, read_only=True)

    class Meta:
        model = Championship
        fields = ['id', 'total_matches', 'trophy', 'teams']


class TeamSerializer(serializers.ModelSerializer):
    championship = serializers.PrimaryKeyRelatedField(many=True, read_only=True)

    class Meta:
        model = Team
        fields = ['id', 'name', 'matches_played', 'championship']
