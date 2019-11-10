package com.example.footballmanager;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {
    private EditText Name;
    private EditText Password;
    private TextView Info;
    private Button Login;
    private int counter = 5;


    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Name = (EditText) findViewById(R.id.etName);
        Password = (EditText) findViewById(R.id.etPassword);
        Login = (Button) findViewById(R.id.btnLogin);
        Info = (TextView) findViewById(R.id.tvInfo);
        Info.setText("You have " + counter + " attempts left");

        Login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                validate(Name.getText().toString(), Password.getText().toString());
            }
        });

    }

    @SuppressLint("SetTextI18n")
    private void validate(String userName, String userPassword) {
        if (userName.equals("victor") && userPassword.equals("victor")) {
            Intent intent = new Intent(MainActivity.this, Championships.class);
            startActivity(intent);
        } else {
            counter--;
            Info.setText("You have " + counter + " attempts left");
            if (counter == 0) {
                Login.setEnabled(false);
            }
        }
    }
}
