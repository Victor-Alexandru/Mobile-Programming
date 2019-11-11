package com.example.footballmanager;

import java.io.Serializable;

public class Team  implements Serializable {
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    private String name;

    public Integer getMatchesPlayed() {
        return matchesPlayed;
    }

    public void setMatchesPlayed(Integer matchesPlayed) {
        this.matchesPlayed = matchesPlayed;
    }

    private Integer matchesPlayed;

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }

    private Integer points;

    public Team(String name, Integer matchesPlayed,Integer points){
        this.name = name;
        this.matchesPlayed = matchesPlayed;
        this.points = points;
    }

}
