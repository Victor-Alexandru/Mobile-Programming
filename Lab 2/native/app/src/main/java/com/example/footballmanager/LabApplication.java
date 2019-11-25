package com.example.footballmanager;

import android.app.Application;

import io.realm.Realm;

public class LabApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        Realm.init(this);
    }
}
