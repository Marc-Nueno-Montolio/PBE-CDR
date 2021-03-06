package com.example.piconnect;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TableLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class DashboardActivity extends AppCompatActivity {
    Button logout;
    Button snd_query;
    EditText query;
    String uid;
    View v;
    TextView qry_fail;
    ImageView image, image2, image3;

    TableLayout tableLayout;
    Table table;



    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        OkHttpClient client = new OkHttpClient();
        setContentView(R.layout.activity_dashboard);
        Button logout = (Button) findViewById(R.id.logout_button);
        Button snd_query = (Button) findViewById(R.id.send_button);
        TextView user_logged = (TextView) findViewById(R.id.textView_user);

        tableLayout = (TableLayout) findViewById(R.id.table);
        table = new Table(tableLayout, getApplicationContext());

        query = (EditText) findViewById(R.id.enter_query);
        //Fem invisible el missatge de wrong query
        qry_fail = (TextView) findViewById(R.id.query_fail);
        qry_fail.setVisibility(View.INVISIBLE);

        uid = getIntent().getStringExtra("uid");
        String photo_url = getIntent().getStringExtra("photo_url");


        new DownloadImageTask((ImageView) findViewById(R.id.logos)).execute(photo_url);


        //Mostrem string usuari per pantalla amb el missatge de benvinguda
        String usuaris = getIntent().getStringExtra("usuari");
        user_logged.setText(usuaris);


        //Funci?? que permet al bot?? de Logout, tornar a la Main Activity (primer escenari)
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
                String url = QueryUrl(v, query_s, uid);
                sendQuery(client, url);


            }
        });
    }

    //versi?? cutre send_query
    public String QueryUrl(View view, String query, String uid) {
        String querySplit[] = query.split("\\?");
        String qry = querySplit[0];
        String str = "";

        if (qry.equals("timetables") || qry.equals("marks") || qry.equals("tasks")) {
            if (query.contains("?")) {
                str = "http://138.68.152.226:3000/" + query + "&uid=" + uid;
            } else {
                str = "http://138.68.152.226:3000/" + query + "?uid=" + uid;
            }
        } else {
            str = "http://138.68.152.226:3000/";
        }
        return str;
    }

    public void sendQuery(OkHttpClient client, String url) {

        Request request = new Request.Builder().url(url).build();
        System.out.println("Sending query: " + url);

        // Fem el request
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onResponse(@NotNull Call call, @NotNull Response response) throws IOException {
                String res = response.body().string();

                if (!res.equals("{}")) {
                    correct_query(v, query.getText().toString().trim(), uid); //fem invisible el missatge de fail query
                    try {
                        JSONArray jsonRes = new JSONArray(res);
                        System.out.println("RESPONSE: " + jsonRes.toString());
                        runOnUiThread(new Runnable() {

                            @Override
                            public void run() {
                                tableLayout.removeAllViews();
                            }
                        });
                        if(!jsonRes.toString().equals("[]")){
                            createtable(jsonRes);
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    fail_query(v, query.getText().toString().trim(), uid);
                }

            }

            @Override
            public void onFailure(@NotNull Call call, @NotNull IOException e) {
                System.out.println(e.toString());
                fail_query(v, query.getText().toString().trim(), uid);
            }
        });

    }

    public void createtable(JSONArray query) throws JSONException {
        ArrayList<String[]> row = new ArrayList<>();
        // Crear la llista de headers

        Iterator<String> iter = null;
        try {
            iter = query.getJSONObject(0).keys();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        List<String> headers = new ArrayList<String>();
        while (iter.hasNext()) {
            headers.add(iter.next());
        }
        runOnUiThread(new Runnable() {

            @Override
            public void run() {
                table.addHeader(headers.toArray(new String[0]));
            }
        });

        System.out.println("HEADERS:");
        // Headers
        for (int i = 0; i < headers.toArray().length; i++) {
            String columna = headers.toArray()[i].toString();
            System.out.print(columna + "  ");
        }
        String columna = "";
        String[] str = new String[headers.toArray().length];
        // Per cada objecte accedir mitjan??ant el header corresponent
        //Files
        for (int i = 0; i < query.length(); i++) {
            System.out.println("");
            //Columnes
            for (int j = 0; j < headers.toArray().length; j++) {

                columna = query.getJSONObject(i).get(String.valueOf(headers.toArray()[j])).toString();
                str[j] = columna;
                System.out.print(str[j] + "  ");
            }
            row.add(str);
            str = new String[headers.toArray().length];

        }
        //System.out.println( Arrays.toString(row.toArray()) );

        System.out.println();
        runOnUiThread(new Runnable() {

            @Override
            public void run() {
                table.addData(row);
                table.backgroundHeader(Color.rgb(33,193,237));
                table.textColorHeader(Color.rgb(3,7,89));
                table.backgroundData(Color.rgb(237,105,52),Color.rgb(237,207,33), row.size());
                table.textColorData(Color.BLACK,row.size());
                table.lineColor(Color.GRAY);

            }
        });


    }

    //Funcions per mostrar el missatge i amagar el missatge de query not found
    public void fail_query(View view, String query, String uid) {

        DashboardActivity.this.runOnUiThread(new Runnable() {
            public void run() {
                qry_fail.setVisibility(View.VISIBLE);
            }
        });
    }

    public void correct_query(View view, String query, String uid) {

        DashboardActivity.this.runOnUiThread(new Runnable() {
            public void run() {
                qry_fail.setVisibility(View.INVISIBLE);
            }
        });
    }


    private class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
        ImageView bmImage;

        public DownloadImageTask(ImageView bmImage) {
            this.bmImage = bmImage;
        }

        protected Bitmap doInBackground(String... urls) {
            String urldisplay = urls[0];
            Bitmap mIcon11 = null;
            try {
                InputStream in = new java.net.URL(urldisplay).openStream();
                mIcon11 = BitmapFactory.decodeStream(in);
            } catch (Exception e) {
                Log.e("Error", e.getMessage());
                e.printStackTrace();
            }
            return mIcon11;
        }

        protected void onPostExecute(Bitmap result) {
            bmImage.setImageBitmap(result);
        }
    }

}





