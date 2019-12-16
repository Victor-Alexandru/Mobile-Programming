package com.example.footballmanager;

public class TeamObject {

    private  int id ;
    private String name;
    private Integer matchesPlayed;

    public TeamObject (int matchesPlayed, String name) {
        this.matchesPlayed = matchesPlayed;
        this.name = name;

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getMatchesPlayed() {
        return matchesPlayed;
    }

    public void setMatchesPlayed(Integer matchesPlayed) {
        this.matchesPlayed = matchesPlayed;
    }
}
