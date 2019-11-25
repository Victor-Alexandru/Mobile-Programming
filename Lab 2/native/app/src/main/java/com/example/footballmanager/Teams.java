package com.example.footballmanager;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;

import io.realm.Realm;


public class Teams extends AppCompatActivity {
    private ListView teamView;
    TeamAdapter teamAdapter;
    private Button List;
    private Button Create;
    private int champId;
    private Realm realm = Realm.getDefaultInstance();
    ArrayList<Team> teamsT1 = new ArrayList<>();

    public static boolean isInteger(String str) {
        if (str == null) {
            return false;
        }
        int length = str.length();
        if (length == 0) {
            return false;
        }
        int i = 0;
        if (str.charAt(0) == '-') {
            if (length == 1) {
                return false;
            }
            i = 1;
        }
        for (; i < length; i++) {
            char c = str.charAt(i);
            if (c < '0' || c > '9') {
                return false;
            }
        }
        return true;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_teams);
        Intent i = getIntent();
        champId = (Integer) i.getSerializableExtra("id");
        teamView = (ListView) findViewById(R.id.listViewTeams);
        List = (Button) findViewById(R.id.btnList);
        Create = (Button) findViewById(R.id.btnCreate);
        final EditText teamName = (EditText) findViewById(R.id.teamName);
        final EditText teamMatchesPlayed = (EditText) findViewById(R.id.teamMatchesPlayed);
        final EditText pointsInput = (EditText) findViewById(R.id.pointsInput);

        Championship ch1 = realm.where(Championship.class).equalTo("id", champId).findFirst();

        teamsT1.addAll(ch1.getTeams());

        teamAdapter = new TeamAdapter(Teams.this, teamsT1, teamName, teamMatchesPlayed, pointsInput);
        teamAdapter.notifyDataSetChanged();

        Create.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String inputTeam = teamName.getText().toString();
                final String teamMatchesPlayedInput = teamMatchesPlayed.getText().toString();
                final String pointsInputI = pointsInput.getText().toString();

                boolean isInteger = isInteger(teamMatchesPlayedInput);
                boolean isInteger2 = isInteger(pointsInputI);
                if (!inputTeam.equals("") && !teamMatchesPlayedInput.equals("") && !pointsInputI.equals("") && isInteger && isInteger2) {

//                    currentChampionship.getTeams().add(new Team(inputTeam,Integer.parseInt(teamMatchesPlayedInput),Integer.parseInt(pointsInputI)));
                    realm.executeTransaction(new Realm.Transaction() {
                        @Override
                        public void execute(Realm realm) {
                            Number currentIdNum = realm.where(Team.class).max("id");
                            int nextId;
                            if (currentIdNum != null) {
                                nextId = currentIdNum.intValue() + 1;
                            } else {
                                nextId = 1;
                            }
                            Championship ch1 = realm.where(Championship.class).equalTo("id", champId).findFirst();
                            Team c1 = realm.createObject(Team.class, nextId);
                            c1.setPoints(Integer.parseInt(pointsInputI));
                            c1.setName(inputTeam);
                            c1.setMatchesPlayed(Integer.parseInt(teamMatchesPlayedInput));
                            c1.setChampionship(ch1);
                            teamsT1.add(c1);
                            teamAdapter.notifyDataSetChanged();
                        }
                    });
                } else {
                    Toast errorToast = Toast.makeText(Teams.this, "Inputs not be blank and points and matches integers", Toast.LENGTH_SHORT);
                    errorToast.show();
                }
            }
        });

        List.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fillListView();
            }
        });


    }

    public void fillListView() {
        teamView.setAdapter(teamAdapter);
    }

}
