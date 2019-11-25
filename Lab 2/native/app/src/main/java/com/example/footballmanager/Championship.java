package com.example.footballmanager;

import androidx.annotation.NonNull;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import java.io.Serializable;

import javax.security.auth.callback.CallbackHandler;

import io.realm.RealmObject;
import io.realm.RealmResults;
import io.realm.annotations.LinkingObjects;
import io.realm.annotations.PrimaryKey;
import io.realm.annotations.RealmClass;

@RealmClass
public class Championship extends RealmObject implements Serializable {
    @PrimaryKey
    private int id;


    private int totalMatches;

    private String trophy;


//    private ArrayList<Team> teams = new ArrayList<>();

    @LinkingObjects("championship")
    private final RealmResults<Team> teams = null;

    public Championship() {
    };

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
//
//    public void addTeam(Team t1) {
//        this.teams.add(t1);
//
//    }


    @NonNull
    @Override
    public String toString() {
        return "The " + this.trophy + " it's a championship with " + this.totalMatches;
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public RealmResults<Team> getTeams() {
        return teams;
    }
}
