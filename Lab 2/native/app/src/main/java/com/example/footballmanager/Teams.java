package com.example.footballmanager;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

public class Teams extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_teams);
        Intent i = getIntent();
        Championship currentChampionship = (Championship) i.getSerializableExtra("teamObject");
        assert currentChampionship != null;

    }
}
