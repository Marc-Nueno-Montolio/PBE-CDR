package com.example.piconnect;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import okhttp3.Request;



import androidx.appcompat.app.AppCompatActivity;

public class DashboardActivity extends AppCompatActivity {
    Button logout;
    Button snd_query;
    EditText query;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dashboard);
        Button logout = (Button) findViewById(R.id.logout_button);
        Button snd_query = (Button) findViewById(R.id.send_button);
        TextView user_logged = (TextView) findViewById(R.id.textView_user);
        query = (EditText) findViewById(R.id.enter_query);
        //Fem invisible el missatge de wrong query
        TextView qry_fail = (TextView) findViewById(R.id.query_fail);
        qry_fail.setVisibility(View.INVISIBLE);
        String uid = getIntent().getStringExtra("uid");



        //Mostrem string usuari per pantalla amb el missatge de benvinguda
        String usuaris = getIntent().getStringExtra("usuari");
        user_logged.setText(usuaris);

        //Funció que permet al botó de Logout, tornar a la Main Activity (primer escenari)
        logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DashboardActivity.this, MainActivity.class);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
                finish(); // Evitar que es pugui tornar enrere
            }
        });

        snd_query.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String query_s = query.getText().toString().trim();
                System.out.println(query_s); //testeig per veure si agafa el text que li passem pel plainText
                Request request = new Request.Builder().url(send_Query(v,query_s,uid)).build();
                System.out.println("Sending query: " + send_Query(v,query_s,uid));



            }
        });
    }
    //versió cutre send_query
    public String send_Query(View view, String query, String uid) {
        String querySplit[] = query.split("\\?");
        String qry = querySplit[0];
        String str = "";
        if (qry.equals("timetables") || qry.equals("marks") || qry.equals("tasks")) {
            if (query.contains("?")) {
                str = "http://138.68.152.226:3000/" + query + "&uid=" + uid;
            } else {
                str = "http://138.68.152.226:3000/" + query + "?uid=" + uid;
            }
        }
        return str;

    }

}