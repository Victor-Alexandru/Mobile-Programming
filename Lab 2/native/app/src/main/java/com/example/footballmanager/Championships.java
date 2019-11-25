package com.example.footballmanager;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Arrays;

import io.realm.Realm;
import io.realm.RealmResults;

public class Championships extends AppCompatActivity {
    private Realm realm = Realm.getDefaultInstance();
    private ArrayList championships = new ArrayList<>();

    private Button List;
    private Button Create;
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

        RealmResults<Championship> results = realm.where(Championship.class).findAll();
        championships.addAll(results);


    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_championships);
        this.onInit();
        List = (Button) findViewById(R.id.btnList);
        Create = (Button) findViewById(R.id.btnCreate);
        championshipsList = (ListView) findViewById(R.id.listViewTeams);
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
                final String trophyName = inputTrophy.getText().toString();
                final String matchesNr = inputMatches.getText().toString();
                boolean isInteger = isInteger(matchesNr);
                if (!trophyName.equals("") && !matchesNr.equals("") && isInteger) {

//                    championships.add(new Championship(Integer.parseInt(matchesNr), trophyName));
                    realm.executeTransaction(new Realm.Transaction() {
                        @Override
                        public void execute(Realm realm) {
                            Number currentIdNum = realm.where(Championship.class).max("id");
                            int nextId;
                            if (currentIdNum != null) {
                                nextId = currentIdNum.intValue() + 1;
                            } else {
                                nextId = 1;
                            }
                            Championship c1 = realm.createObject(Championship.class, nextId);
                            c1.setTotalMatches(Integer.parseInt(matchesNr));
                            c1.setTrophy(trophyName);
                            championships.add(c1);
                        }
                    });
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
