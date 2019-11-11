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


public class Teams extends AppCompatActivity {
    private ListView teamView;
    TeamAdapter teamAdapter;
    private Button List;
    private Button Create;


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
        final Championship currentChampionship = (Championship) i.getSerializableExtra("teamObject");
        teamView = (ListView) findViewById(R.id.listViewTeams);
        assert currentChampionship != null;
        List = (Button) findViewById(R.id.btnList);
        Create = (Button) findViewById(R.id.btnCreate);
        final EditText teamName = (EditText) findViewById(R.id.teamName);
        final EditText teamMatchesPlayed = (EditText) findViewById(R.id.teamMatchesPlayed);
        final EditText pointsInput = (EditText) findViewById(R.id.pointsInput);
        teamAdapter = new TeamAdapter(Teams.this, currentChampionship.getTeams(), teamName ,teamMatchesPlayed,pointsInput);


        Create.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String inputTeam = teamName.getText().toString();
                String teamMatchesPlayedInput = teamMatchesPlayed.getText().toString();
                String pointsInputI = pointsInput.getText().toString();

                boolean isInteger = isInteger(teamMatchesPlayedInput);
                boolean isInteger2 = isInteger(pointsInputI);
                if (!inputTeam.equals("") && !teamMatchesPlayedInput.equals("") && !pointsInputI.equals("") && isInteger && isInteger2) {

                    currentChampionship.getTeams().add(new Team(inputTeam,Integer.parseInt(teamMatchesPlayedInput),Integer.parseInt(pointsInputI)));
                    teamAdapter.notifyDataSetChanged();
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
