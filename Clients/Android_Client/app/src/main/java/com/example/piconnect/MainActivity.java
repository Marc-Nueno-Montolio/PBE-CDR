package com.example.piconnect;

import android.content.Intent;
import android.nfc.NfcAdapter;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

//import org.jetbrains.annotations.NotNull;

//import java.io.IOException;

//import okhttp3.Call;
//import okhttp3.Callback;
//import okhttp3.OkHttpClient;
//import okhttp3.Request;
//import okhttp3.Response;


public class MainActivity extends AppCompatActivity {

    //private Object View;
    //protected final Button logBtn = (Button) findViewById(R.id.login_b);
    //protected final EditText usrTxt = (EditText) findViewById(R.id.password);
    //protected final EditText passwordTxt = (EditText) findViewById(R.id.username);

    Button logBtn;
    EditText usrTxt;
    EditText passwordTxt;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        TextView tv_usr_txt = (TextView) findViewById(R.id.log_fail);
        tv_usr_txt.setVisibility(View.INVISIBLE);
        NfcAdapter nfc_lector;
        /*final Button*/ logBtn = (Button) findViewById(R.id.login_b);               //Botó log-in
        /*final EditText*/ usrTxt = (EditText) findViewById(R.id.password);          //User text field
        /*final EditText*/ passwordTxt = (EditText) findViewById(R.id.username);     //Password text field

        //DEBUG ATTRIBUTES:
        final Button ghostBtn = (Button) findViewById(R.id.button_aux);               //Botó log-in
        //View vw_button = new View.OnClickListener();
        //TextView tv_usr_txt = new TextView();
        //TextView tv_psw_txt = new TextView();


        //logBtn.setOnClickListener(new View.OnClickListener());

        /*ghostBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this,DashboardActivity.class));
            }
        });*/

    }

    public void comprovar_login(View view){           //Métode invocat per botó login o enter desde text field usr o pswd
        String usuari = usrTxt.getText().toString();
        String password = passwordTxt.getText().toString();
        if(1==1  /*No implementat encara, aqui aniria condició de que el login es invàlid*/){
            TextView tv_usr_txt = (TextView) findViewById(R.id.log_fail);
            tv_usr_txt.setVisibility(View.VISIBLE);
        }else{
            startActivity(new Intent(MainActivity.this,DashboardActivity.class)); //A dashboard activity!
        }
    }

    public void ghost_login(View view){               //Mètode invocat per botó Dashboard Activity
        startActivity(new Intent(MainActivity.this,DashboardActivity.class));
    }
}