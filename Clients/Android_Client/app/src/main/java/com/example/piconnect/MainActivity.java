package com.example.piconnect;

import android.content.Intent;
import android.nfc.NfcAdapter;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import org.jetbrains.annotations.NotNull;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;


public class MainActivity extends AppCompatActivity {
    OkHttpClient client;
    Button logBtn;
    EditText usrTxt;
    EditText passwordTxt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        TextView tv_usr_txt = (TextView) findViewById(R.id.log_fail);
        tv_usr_txt.setVisibility(View.INVISIBLE);
        client = new OkHttpClient();
        NfcAdapter nfc_lector;
        /*final Button*/
        logBtn = (Button) findViewById(R.id.login_b);               //Botó log-in
        /*final EditText*/
        usrTxt = (EditText) findViewById(R.id.username);          //User text field
        /*final EditText*/
        passwordTxt = (EditText) findViewById(R.id.password);     //Password text field

        //DEBUG ATTRIBUTES:
        final Button ghostBtn = (Button) findViewById(R.id.button_aux);               //Botó log-in


        ghostBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                login(v, "Marc Nueno", "A677A214", "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/1024px-User_icon_2.svg.png");
            }
        });

        logBtn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                String usuari = usrTxt.getText().toString();
                String uid = passwordTxt.getText().toString();

                String url = "http://138.68.152.226:3000/students?uid=" + uid;

                // Construim un nou request
                Request request = new Request.Builder().url(url).build();
                System.out.println("Sending query: " + url);
                // Fem el request
                client.newCall(request).enqueue(new Callback() {
                    @Override
                    public void onResponse(@NotNull Call call, @NotNull Response response) throws IOException {

                        try {
                            JSONObject res = new JSONObject(response.body().string());
                            System.out.println(res.get("uid").toString() + uid + " " + res.get("name").toString() + usuari);
                            if (res.get("uid").toString().equals(uid) && res.get("name").toString().equals(usuari)) {

                                String photo_url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/1024px-User_icon_2.svg.png";
                                if (res.has("photo_url")) {
                                    photo_url = res.get("photo_url").toString();
                                }


                                System.out.println("Logging in...");
                                login(v, usuari, uid, photo_url);

                            } else {
                                fail_login(v, usuari, uid);
                            }

                        } catch (JSONException e) {
                            fail_login(v, usuari, uid);
                        }
                    }

                    @Override
                    public void onFailure(@NotNull Call call, @NotNull IOException e) {
                        fail_login(v, usuari, uid);
                    }
                });
            }
        });
    }

    public void fail_login(View view, String usuari, String uid) {

        MainActivity.this.runOnUiThread(new Runnable() {
            public void run() {
                TextView tv_usr_txt = (TextView) findViewById(R.id.log_fail);
                tv_usr_txt.setVisibility(View.VISIBLE);
            }
        });
    }

    public void login(View view, String usuari, String uid, String photo_url) {
        Intent intent = new Intent(MainActivity.this, DashboardActivity.class);
        intent.putExtra("usuari", usuari);
        intent.putExtra("uid", uid);
        intent.putExtra("photo_url", photo_url);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK); // Evitar que es pugui tornar enrere
        startActivity(intent);
    }


}