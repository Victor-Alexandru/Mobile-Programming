package com.example.footballmanager;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;

public class Championships extends AppCompatActivity {
    //    private Realm realm = Realm.getDefaultInstance();
    private ArrayList<ChampionshipObject> championships = new ArrayList<ChampionshipObject>();

    private Button List;
    private Button Create;
    private ListView championshipsList;
    ChampionshipAdapter myChampionshipAdapter;
    private RequestQueue mQueue;

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
        setContentView(R.layout.activity_championships);
        List = (Button) findViewById(R.id.btnList);
        Create = (Button) findViewById(R.id.btnCreate);
        championshipsList = (ListView) findViewById(R.id.listViewTeams);
        final EditText inputMatches = (EditText) findViewById(R.id.matchesInput);
        final EditText inputTrophy = (EditText) findViewById(R.id.trophyInput);
        myChampionshipAdapter = new ChampionshipAdapter(Championships.this, this.championships, inputMatches, inputTrophy);
        mQueue = Volley.newRequestQueue(this);

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
//                    realm.executeTransaction(new Realm.Transaction() {
//                        @Override
//                        public void execute(Realm realm) {
//                            Number currentIdNum = realm.where(Championship.class).max("id");
//                            int nextId;
//                            if (currentIdNum != null) {
//                                nextId = currentIdNum.intValue() + 1;
//                            } else {
//                                nextId = 1;
//                            }
//                            Championship c1 = realm.createObject(Championship.class, nextId);
//                            c1.setTotalMatches(Integer.parseInt(matchesNr));
//                            c1.setTrophy(trophyName);
//                            championships.add(c1);
//                        }
//                    });
                    myChampionshipAdapter.notifyDataSetChanged();
                } else {
                    Toast errorToast = Toast.makeText(Championships.this, "Trophy and Nr of matches must not be blank and nr of matches must be an int", Toast.LENGTH_SHORT);
                    errorToast.show();
                }
            }
        });

    }

    public void fillListView() {
        String url = "http://192.168.1.106:8000/team/championships/";
//        String url = "http://api.myjson.com/bins/kp9wz";

        championships.clear();

        JsonArrayRequest request = new JsonArrayRequest(Request.Method.GET, url, null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {
                try {
                    for (int i = 0; i < response.length(); i++) {
                        ChampionshipObject c1 = new ChampionshipObject(Integer.parseInt(response.getJSONObject(i).getString("total_matches")), response.getJSONObject(i).getString("trophy"));
                        championships.add(c1);

                    }
                    System.out.println("----------------------------");
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }


        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                error.printStackTrace();
            }
        });
        mQueue.add(request);
        System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        System.out.println(championships.toString());
        System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
        myChampionshipAdapter.notifyDataSetChanged();
        championshipsList.setAdapter(myChampionshipAdapter);


    }
}
