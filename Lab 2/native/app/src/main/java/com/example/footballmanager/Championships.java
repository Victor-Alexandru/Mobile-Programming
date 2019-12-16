package com.example.footballmanager;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
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
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Championships extends AppCompatActivity {
    //    private Realm realm = Realm.getDefaultInstance();
    private ArrayList<ChampionshipObject> championships = new ArrayList<ChampionshipObject>();
    String url = "http://192.168.1.106:8000/team/championships/";

    private boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    }

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
        mQueue = Volley.newRequestQueue(this);
        myChampionshipAdapter = new ChampionshipAdapter(Championships.this, this.championships, inputMatches, inputTrophy, mQueue, url);
        championshipsList.setAdapter(myChampionshipAdapter);

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
                if (isNetworkAvailable()) {
                    if (!trophyName.equals("") && !matchesNr.equals("") && isInteger) {


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

                                        System.out.println("Accepted");
                                        System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                        System.out.println(response);
                                        System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                        ChampionshipObject c1 = new ChampionshipObject(Integer.parseInt(matchesNr), trophyName);
                                        c1.setId(Integer.parseInt(id));
                                        championships.add(c1);
                                        myChampionshipAdapter.notifyDataSetChanged();

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
                                params.put("trophy", trophyName);
                                params.put("total_matches", matchesNr);

                                return params;
                            }
                        };
                        mQueue.add(postRequest);

                    } else {
                        Toast errorToast = Toast.makeText(Championships.this, "Trophy and Nr of matches must not be blank and nr of matches must be an int", Toast.LENGTH_SHORT);
                        errorToast.show();
                    }
                } else {
                    ChampionshipObject c1 = new ChampionshipObject(Integer.parseInt(matchesNr), trophyName);
                    c1.setId(-250);
                    championships.add(c1);
                    myChampionshipAdapter.notifyDataSetChanged();
                    Toast errorToast = Toast.makeText(Championships.this, "Added in local db for the moment", Toast.LENGTH_SHORT);
                    errorToast.show();
                }
            }
        });

    }

    public void fillListView() {

        if (this.isNetworkAvailable()) {
            if (championships.size() != 0) {
                for (final ChampionshipObject c1 : championships) {
                    if (c1.getId() == -250) {

                        StringRequest postRequest = new StringRequest(Request.Method.POST, url,
                                new Response.Listener<String>() {
                                    @Override
                                    public void onResponse(String response) {
                                        // response

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
                                params.put("trophy", c1.getTrophy());
                                params.put("total_matches", String.valueOf(c1.getTotalMatches()));

                                return params;
                            }
                        };
                        mQueue.add(postRequest);
                    }
                }
            }

            championships.clear();

            JsonArrayRequest request = new JsonArrayRequest(Request.Method.GET, url, null, new Response.Listener<JSONArray>() {
                @Override
                public void onResponse(JSONArray response) {
                    try {
                        championships.clear();
                        System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&");
                        for (int i = 0; i < response.length(); i++) {
                            ChampionshipObject c1 = new ChampionshipObject(Integer.parseInt(response.getJSONObject(i).getString("total_matches")), response.getJSONObject(i).getString("trophy"));
                            c1.setId(Integer.parseInt(response.getJSONObject(i).getString("id")));
                            championships.add(c1);

                        }
                        System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&");

                        myChampionshipAdapter.notifyDataSetChanged();

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
        } else {
            myChampionshipAdapter.notifyDataSetChanged();
            Toast errorToast = Toast.makeText(Championships.this, "Network is not availabele", Toast.LENGTH_SHORT);
            errorToast.show();
        }
    }
}
