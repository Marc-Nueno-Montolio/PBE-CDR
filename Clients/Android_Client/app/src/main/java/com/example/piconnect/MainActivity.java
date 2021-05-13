package com.example.piconnect;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class MainActivity extends AppCompatActivity {

    //private Object View;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final Button logBtn = (Button) findViewById(R.id.login_b);
        final EditText usrTxt = (EditText) findViewById(R.id.password);
        final EditText passwordTxt = (EditText) findViewById(R.id.username);
    }

    public void comprovar_login(View view){

    }
}