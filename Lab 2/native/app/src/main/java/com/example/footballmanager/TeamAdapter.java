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

import java.util.ArrayList;

import static com.example.footballmanager.Championships.isInteger;

public class TeamAdapter extends BaseAdapter {

    private Context mContext;
    private ArrayList<Team> teams = new ArrayList<>();
    private EditText teamNameU;
    private EditText teamMatchesPlayed;
    private EditText pointsInput;


    public TeamAdapter(Context context, ArrayList<Team> championships, EditText e1, EditText e2, EditText e3) {
        this.mContext = context;
        this.teams = championships;
        this.teamNameU = e1;
        this.teamMatchesPlayed = e2;
        this.pointsInput = e3;

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

        final Team tempTeam = (Team) getItem(position);

        TextView matchesPlayed = (TextView) convertView.findViewById(R.id.matchesText);
        TextView pointText = (TextView) convertView.findViewById(R.id.pointsText);
        TextView teamName = (TextView) convertView.findViewById(R.id.teamNameText);
        Button btnDelete = (Button) convertView.findViewById(R.id.btnTeamDelete);
        Button btnUpdate = (Button) convertView.findViewById(R.id.btnTeamUpdate);


        matchesPlayed.setText(String.valueOf(tempTeam.getMatchesPlayed()));
        pointText.setText(String.valueOf(tempTeam.getPoints()));
        teamName.setText(tempTeam.getName());

        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                teams.remove(tempTeam);
                notifyDataSetChanged();
            }
        });

        btnUpdate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String inputTeam = teamNameU.getText().toString();
                String teamMatchesPlayedInput = teamMatchesPlayed.getText().toString();
                String pointsInputI = pointsInput.getText().toString();

                boolean isInteger = isInteger(teamMatchesPlayedInput);
                boolean isInteger2 = isInteger(pointsInputI);
                if (!inputTeam.equals("") && !teamMatchesPlayedInput.equals("") && !pointsInputI.equals("") && isInteger && isInteger2) {
                    tempTeam.setName(inputTeam);
                    tempTeam.setMatchesPlayed(Integer.parseInt(teamMatchesPlayedInput));
                    tempTeam.setPoints(Integer.parseInt(pointsInputI));
                    notifyDataSetChanged();
                } else {
                    Toast errorToast = Toast.makeText(mContext, "Inputs not be blank and points and matches integers", Toast.LENGTH_SHORT);
                    errorToast.show();
                }
            }
        });


        return convertView;
    }

}
