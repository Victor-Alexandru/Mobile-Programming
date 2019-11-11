package com.example.footballmanager;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.List;

public class Championships extends AppCompatActivity {

    private ArrayList<Championship> championships = new ArrayList<>();

    private Button List;
    private Button Create;
    private Button Delete;
    private ListView championshipsList;


    private void onInit() {
        Championship ch1 = new Championship(10, "Liga Studentilor UBB");
        Championship ch2 = new Championship(12, "Liga Studentilor UTCN");
        championships.add(ch1);
        championships.add(ch2);
        for (int i = 12; i <= 18; i += 2) {
            championships.add(new Championship(i, "Liga " + i));
        }
        System.out.println(championships.toString());
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_championships);
        this.onInit();
        List = (Button) findViewById(R.id.btnList);
        Create = (Button) findViewById(R.id.btnCreate);
        championshipsList = (ListView) findViewById(R.id.listViewChampionships);
        final EditText inputMatches = (EditText) findViewById(R.id.matchesInput);
        final EditText inputTrophy = (EditText) findViewById(R.id.trophyInput);

        List.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fillListView();
            }
        });

        Create.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.v("tropyName" ,inputTrophy.getText().toString());
                Log.v("matches" ,inputMatches.getText().toString());
            }
        });

    }

    public void fillListView() {
        ChampionshipAdapter myChampionshipAdapter = new ChampionshipAdapter(Championships.this, this.championships);
        championshipsList.setAdapter(myChampionshipAdapter);
    }
}
