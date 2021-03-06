from django.db import models


# Create your models here.
class Championship(models.Model):
    total_matches = models.IntegerField(null=True, blank=True)
    trophy = models.TextField(null=True, blank=True)


class Team(models.Model):
    name = models.TextField(null=True, blank=True)
    matches_played = models.IntegerField()
    championship = models.ForeignKey(Championship, on_delete=models.CASCADE, related_name="teams")
