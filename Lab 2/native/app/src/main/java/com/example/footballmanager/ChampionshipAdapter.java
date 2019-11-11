package com.example.footballmanager;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class ChampionshipAdapter extends BaseAdapter {
    private Context mContext;
    private ArrayList<Championship> championships = new ArrayList<>();

    public ChampionshipAdapter(Context context, ArrayList<Championship> championships) {
        this.mContext = context;
        this.championships = championships;

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

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.listview_item, parent, false);
        }
        final Championship tempChampionship = (Championship) getItem(position);

        TextView tvTrophy = (TextView) convertView.findViewById(R.id.tvTrophy);
        TextView tvMatches = (TextView) convertView.findViewById(R.id.tvMatches);
        Button btnDelete = (Button) convertView.findViewById(R.id.deleteIItemButton);


        tvTrophy.setText(tempChampionship.getTrophy());
        tvMatches.setText(tempChampionship.getTotalMatches() + " matches");

        btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                championships.remove(tempChampionship);
                notifyDataSetChanged();
            }
        });

        return convertView;
    }
}
