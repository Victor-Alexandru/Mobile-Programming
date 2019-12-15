package com.example.footballmanager;

import java.util.TreeMap;

public class ChampionshipObject {

    private int totalMatches;

    private String trophy;

    public ChampionshipObject(int tM, String trophy) {
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

    public boolean isValid() {
        return true;
    }
}
