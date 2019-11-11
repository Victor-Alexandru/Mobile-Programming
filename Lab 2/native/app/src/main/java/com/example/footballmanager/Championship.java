package com.example.footballmanager;

import androidx.annotation.NonNull;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;

public class Championship {
    private int totalMatches;
    private String trophy;
    private List<Team> teams = new ArrayList<>();

    public Championship(int tM, String trophy) {
        this.totalMatches = tM;
        this.trophy = trophy;

    }

    public String getTrophy() {
        return trophy;
    }

    public void setTrophy(String trophy) {
        this.trophy = trophy;
    }

    public int getTotalMatches() {
        return totalMatches;
    }

    public void setTotalMatches(int totalMatches) {
        this.totalMatches = totalMatches;
    }

    public void addTeam(Team t1) {
        this.teams.add(t1);

    }

    @NonNull
    @Override
    public String toString() {
        return "The " + this.trophy + " it's a championship with " + this.totalMatches;
    }
}
