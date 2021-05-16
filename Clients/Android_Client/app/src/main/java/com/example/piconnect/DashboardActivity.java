package com.example.piconnect;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class DashboardActivity extends AppCompatActivity {
    Button logout;
    Button snd_query;
    EditText query;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dashboard);
        TextView user_logged = (TextView) findViewById(R.id.textView_user);
        Button logout = (Button) findViewById(R.id.logout_button);

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
    }


}