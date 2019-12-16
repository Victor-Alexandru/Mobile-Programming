package com.example.footballmanager;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.realm.Realm;

import static com.example.footballmanager.Championships.isInteger;

public class TeamAdapter extends BaseAdapter {

    private Context mContext;
    private ArrayList<TeamObject> teams = new ArrayList<>();
    private EditText teamNameU;
    private EditText teamMatchesPlayed;
    String url;
    private RequestQueue mQueue;
    private int champId;

    public TeamAdapter(Context context, ArrayList<TeamObject> championships, EditText e1, EditText e2, RequestQueue q1, String ur, Integer id) {
        this.mContext = context;
        this.teams = championships;
        this.teamNameU = e1;
        this.teamMatchesPlayed = e2;
        this.mQueue = q1;
        this.url = ur;
        this.champId = id;

    }

    @Override
    public int getCount() {
        return teams.size();
    }

    @Override
    public Object getItem(int position) {
        return teams.get(position);
    }


    @Override
    public long getItemId(int position) {
        return position;
    }

    @SuppressLint("DefaultLocale")
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.listview_team_item, parent, false);
        }

        final TeamObject tempTeam = (TeamObject) getItem(position);

        TextView matchesPlayed = (TextView) convertView.findViewById(R.id.matchesText);
        TextView teamName = (TextView) convertView.findViewById(R.id.teamNameText);
        Button btnDelete = (Button) convertView.findViewById(R.id.btnTeamDelete);
        Button btnUpdate = (Button) convertView.findViewById(R.id.btnTeamUpdate);


        matchesPlayed.setText(String.valueOf(tempTeam.getMatchesPlayed()));
        teamName.setText(tempTeam.getName());

        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String urlDelete = url + tempTeam.getId() + "/";

                StringRequest dr = new StringRequest(Request.Method.DELETE, urlDelete,
                        new Response.Listener<String>() {
                            @Override
                            public void onResponse(String response) {
                                // response
                                teams.remove(tempTeam);
                                notifyDataSetChanged();
                            }
                        },
                        new Response.ErrorListener() {
                            @Override
                            public void onErrorResponse(VolleyError error) {
                                // error.

                            }
                        }
                );
                mQueue.add(dr);
            }
        });

        btnUpdate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String inputTeam = teamNameU.getText().toString();
                final String teamMatchesPlayedInput = teamMatchesPlayed.getText().toString();

                boolean isInteger = isInteger(teamMatchesPlayedInput);
                if (!inputTeam.equals("") && !teamMatchesPlayedInput.equals("") && isInteger) {
                    String urlPut = url + tempTeam.getId() + "/?championship_id=" + champId;
                    StringRequest postRequest = new StringRequest(Request.Method.PUT, urlPut,
                            new Response.Listener<String>() {
                                @Override
                                public void onResponse(String response) {
                                    // response
                                    System.out.println("Accepted");
                                    for (TeamObject c : teams) {
                                        if (c.getId() == tempTeam.getId()) {
                                            tempTeam.setMatchesPlayed(Integer.parseInt(teamMatchesPlayedInput));
                                            tempTeam.setName(inputTeam);
                                        }
                                    }
                                    notifyDataSetChanged();

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
                    Toast errorToast = Toast.makeText(mContext, "Inputs not be blank and points and matches integers", Toast.LENGTH_SHORT);
                    errorToast.show();
                }
            }
        });


        return convertView;
    }

}
