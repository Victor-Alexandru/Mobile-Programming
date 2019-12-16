package com.example.footballmanager;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;
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

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.realm.Realm;

import static com.example.footballmanager.Championships.isInteger;

public class ChampionshipAdapter extends BaseAdapter {
    private Context mContext;
    private ArrayList<ChampionshipObject> championships;
    private EditText inputMatches;
    private EditText inputTrophy;
    private Realm realm = Realm.getDefaultInstance();
    String url;
    private RequestQueue mQueue;

    private boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    }


    public ChampionshipAdapter(Context context, ArrayList<ChampionshipObject> championships, EditText e1, EditText e2, RequestQueue q1, String ur) {
        this.mContext = context;
        this.championships = championships;
        this.inputMatches = e1;
        this.inputTrophy = e2;
        this.mQueue = q1;
        this.url = ur;

    }

    @Override
    public int getCount() {
        return championships.size();
    }

    @Override
    public Object getItem(int position) {
        return championships.get(position);
    }


    @Override
    public long getItemId(int position) {
        return position;
    }

    @SuppressLint("DefaultLocale")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.listview_item, parent, false);
        }
        final ChampionshipObject tempChampionship = (ChampionshipObject) getItem(position);

        TextView tvTrophy = (TextView) convertView.findViewById(R.id.tvTrophy);
        TextView tvMatches = (TextView) convertView.findViewById(R.id.tvMatches);
        Button btnDelete = (Button) convertView.findViewById(R.id.deleteIItemButton);
        Button btnUpdate = (Button) convertView.findViewById(R.id.btnUpdate);
        Button btnPreview = (Button) convertView.findViewById(R.id.btnPreview);


        if (championships.get(position).isValid()) {
            tvTrophy.setText(tempChampionship.getTrophy());
            tvMatches.setText(String.format("%d matches", tempChampionship.getTotalMatches()));
        }
        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isNetworkAvailable()) {
                    String urlDelete = url + tempChampionship.getId() + "/";

                    StringRequest dr = new StringRequest(Request.Method.DELETE, urlDelete,
                            new Response.Listener<String>() {
                                @Override
                                public void onResponse(String response) {
                                    // response
                                    championships.remove(tempChampionship);
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
                } else {
                    Toast errorToast = Toast.makeText(mContext, "Delete is off when no network", Toast.LENGTH_SHORT);
                    errorToast.show();
                }
            }
        });

        btnUpdate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isNetworkAvailable()) {
                    final String trophyName = inputTrophy.getText().toString();
                    final String matchesNr = inputMatches.getText().toString();
                    boolean isInteger = isInteger(matchesNr);
                    if (!trophyName.equals("") && !matchesNr.equals("") && isInteger) {
                        String urlPut = url + tempChampionship.getId() + "/";
                        StringRequest postRequest = new StringRequest(Request.Method.PUT, urlPut,
                                new Response.Listener<String>() {
                                    @Override
                                    public void onResponse(String response) {
                                        // response
                                        System.out.println("Accepted");
                                        for (ChampionshipObject c : championships) {
                                            if (c.getId() == tempChampionship.getId()) {
                                                tempChampionship.setTotalMatches(Integer.parseInt(matchesNr));
                                                tempChampionship.setTrophy(trophyName);
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
                                params.put("trophy", trophyName);
                                params.put("total_matches", matchesNr);

                                return params;
                            }
                        };
                        mQueue.add(postRequest);
                    } else {
                        Toast errorToast = Toast.makeText(mContext, "Trophy and Nr of matches must not be blank and nr of matches must be an int", Toast.LENGTH_SHORT);
                        errorToast.show();
                    }
                } else {
                    Toast errorToast = Toast.makeText(mContext, "Update is off when no network", Toast.LENGTH_SHORT);
                    errorToast.show();
                }


            }
        });

        btnPreview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isNetworkAvailable()) {
                    Intent intent = new Intent(mContext, Teams.class);
                    intent.putExtra("id", tempChampionship.getId());
                    mContext.startActivity(intent);
                }else{
                    Toast errorToast = Toast.makeText(mContext, "Preview disabled ", Toast.LENGTH_SHORT);
                    errorToast.show();
                }
            }
        });

        return convertView;
    }
}
