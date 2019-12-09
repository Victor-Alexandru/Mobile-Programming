from django.db import models


# Create your models here.

class Team(models.Model):


class Championship(models.Model):
    total_matches = models.IntegerField(null=True, blank=True)
    trophy = models.TextField(null=True, blank=True)


