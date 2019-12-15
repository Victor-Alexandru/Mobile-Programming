package com.example.footballmanager;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.lang.reflect.Array;
import java.util.ArrayList;

import io.realm.Realm;

import static com.example.footballmanager.Championships.isInteger;

public class ChampionshipAdapter extends BaseAdapter {
    private Context mContext;
    private ArrayList<ChampionshipObject> championships;
    private EditText inputMatches;
    private EditText inputTrophy;
    private Realm realm = Realm.getDefaultInstance();

    public ChampionshipAdapter(Context context, ArrayList<ChampionshipObject> championships, EditText e1, EditText e2) {
        this.mContext = context;
        this.championships = championships;
        this.inputMatches = e1;
        this.inputTrophy = e2;

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
//        btnDelete.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                realm.executeTransaction(new Realm.Transaction() {
//                    @Override
//                    public void execute(Realm realm) {
//                        championships.remove(tempChampionship);
//                        tempChampionship.deleteFromRealm();
//                        notifyDataSetChanged();
//                    }
//                });
//            }
//        });

        btnUpdate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String trophyName = inputTrophy.getText().toString();
                final String matchesNr = inputMatches.getText().toString();
                boolean isInteger = isInteger(matchesNr);
                if (!trophyName.equals("") && !matchesNr.equals("") && isInteger) {
//                    realm.executeTransaction(new Realm.Transaction() {
//                        @Override
//                        public void execute(Realm realm) {
//                            tempChampionship.setTotalMatches(Integer.parseInt(matchesNr));
//                            tempChampionship.setTrophy(trophyName);
//                            realm.insertOrUpdate(tempChampionship);
//                        }
//                    });
                    notifyDataSetChanged();
                } else {
                    Toast errorToast = Toast.makeText(mContext, "Trophy and Nr of matches must not be blank and nr of matches must be an int", Toast.LENGTH_SHORT);
                    errorToast.show();
                }

            }
        });

//        btnPreview.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent intent = new Intent(mContext, Teams.class);
//                intent.putExtra("id",tempChampionship.getId());
//                mContext.startActivity(intent);
//            }
//        });

        return convertView;
    }
}
