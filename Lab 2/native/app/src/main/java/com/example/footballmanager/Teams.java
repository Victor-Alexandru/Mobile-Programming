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

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.realm.Realm;


public class Teams extends AppCompatActivity {
    private ListView teamView;
    TeamAdapter teamAdapter;
    private Button List;
    private Button Create;
    private int champId;
    ArrayList<TeamObject> teamsT1 = new ArrayList<>();
    private RequestQueue mQueue;
    String url = "http://192.168.1.106:8000/team/teams/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_teams);
        Intent i = getIntent();
        champId = (Integer) i.getSerializableExtra("id");
        teamView = (ListView) findViewById(R.id.listViewTeams);
        List = (Button) findViewById(R.id.btnList);
        Create = (Button) findViewById(R.id.btnCreate);
        teamView = (ListView) findViewById(R.id.listViewTeams);
        final EditText teamName = (EditText) findViewById(R.id.teamName);
        final EditText teamMatchesPlayed = (EditText) findViewById(R.id.teamMatchesPlayed);
        mQueue = Volley.newRequestQueue(this);

        teamAdapter = new TeamAdapter(Teams.this, teamsT1, teamName, teamMatchesPlayed, mQueue, url,champId);
        teamView.setAdapter(teamAdapter);
        teamAdapter.notifyDataSetChanged();


        Create.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String inputTeam = teamName.getText().toString();
                final String teamMatchesPlayedInput = teamMatchesPlayed.getText().toString();

                boolean isInteger = isInteger(teamMatchesPlayedInput);
                if (!inputTeam.equals("") && !teamMatchesPlayedInput.equals("") && isInteger) {

                    StringRequest postRequest = new StringRequest(Request.Method.POST, url,
                            new Response.Listener<String>() {
                                @Override
                                public void onResponse(String response) {
                                    // response
                                    String id = "";
                                    JSONObject champObjJson = null;
                                    try {
                                        champObjJson = new JSONObject(response);
                                        id = champObjJson.getString("id");
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }

                                    TeamObject c1 = new TeamObject(Integer.parseInt(teamMatchesPlayedInput), inputTeam);
                                    c1.setId(Integer.parseInt(id));
                                    teamsT1.add(c1);
                                    teamAdapter.notifyDataSetChanged();

                                }
                            },
                            new Response.ErrorListener() {
                                @Override
                                public void onErrorResponse(VolleyError error) {
                                    // error
                                    System.out.println("Refused");
                                }
                            }
                    ) {
                        @Override
                        protected Map<String, String> getParams() {
                            Map<String, String> params = new HashMap<String, String>();
                            params.put("name", inputTeam);
                            params.put("matches_played", teamMatchesPlayedInput);
                            params.put("championship_id", String.valueOf(champId));

                            return params;
                        }
                    };
                    mQueue.add(postRequest);


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

        teamsT1.clear();
        String urlGet = url + "?championship_id=" + champId;

        JsonArrayRequest request = new JsonArrayRequest(Request.Method.GET, urlGet, null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {
                try {
                    teamsT1.clear();
                    for (int i = 0; i < response.length(); i++) {
                        TeamObject c1 = new TeamObject(Integer.parseInt(response.getJSONObject(i).getString("matches_played")), response.getJSONObject(i).getString("name"));
                        c1.setId(Integer.parseInt(response.getJSONObject(i).getString("id")));
                        teamsT1.add(c1);

                    }


                    teamAdapter.notifyDataSetChanged();

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

    }


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
}
