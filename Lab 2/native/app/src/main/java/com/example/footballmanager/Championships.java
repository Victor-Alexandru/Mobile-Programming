package com.example.footballmanager;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

public class Championships extends AppCompatActivity {

    private ArrayList<Championship> championships = new ArrayList<>();

    private Button List;
    private Button Create;
    private Button Delete;
    private ListView championshipsList;
    ChampionshipAdapter myChampionshipAdapter;

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


    private void onInit() {
        Championship ch1 = new Championship(10, "Liga Studentilor UBB");
        Championship ch2 = new Championship(12, "Liga Studentilor UTCN");
        championships.add(ch1);
        championships.add(ch2);
//        for (int i = 12; i <= 18; i += 2) {
//            championships.add(new Championship(i, "Liga " + i));
//        }
//        System.out.println(championships.toString());
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
        myChampionshipAdapter = new ChampionshipAdapter(Championships.this, this.championships, inputMatches, inputTrophy);


        List.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                fillListView();
            }
        });

        Create.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String trophyName = inputTrophy.getText().toString();
                String matchesNr = inputMatches.getText().toString();
                boolean isInteger = isInteger(matchesNr);
                if (!trophyName.equals("") && !matchesNr.equals("") && isInteger) {

                    championships.add(new Championship(Integer.parseInt(matchesNr), trophyName));
                    myChampionshipAdapter.notifyDataSetChanged();
                } else {
                    Toast errorToast = Toast.makeText(Championships.this, "Trophy and Nr of matches must not be blank and nr of matches must be an int", Toast.LENGTH_SHORT);
                    errorToast.show();
                }
            }
        });

    }

    public void fillListView() {
        championshipsList.setAdapter(myChampionshipAdapter);
    }
}
