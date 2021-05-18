package com.example.piconnect;

import android.content.Context;
import android.view.Gravity;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import java.util.ArrayList;

public class Table {
    private TableLayout tableLayout;
    private Context context;
    private String[]header;
    private ArrayList<String[]> data;
    private TableRow tableRow;
    private TextView txtCell;
    private int indexC;
    private int indexR;
    private boolean multiColor= false;
    int firstColor, secondColor, textColor;

    public Table(TableLayout tableLayout, Context context) {
        this.tableLayout = tableLayout;
        this.tableLayout.removeAllViewsInLayout();
        this.context = context;
    }

    public void addHeader(String[]header){
        this.header = header;
        createHeader();
    }
    public void addData(ArrayList<String[]>data){
        this.data = data;
        createDataTable(data.size());
    }

    private void newRow(){
        tableRow= new TableRow(context);
    }


    private void newCell(){
        txtCell = new TextView(context);
        txtCell.setGravity(Gravity.CENTER);
        txtCell.setTextSize(15);

    }

    private void createHeader(){
        indexC=0;
        newRow();
        while (indexC< header.length){
            newCell();
            txtCell.setText(header[indexC++]);
            tableRow.addView(txtCell,newTableRowParams());
        }
        tableLayout.addView(tableRow);

    }
    private void createDataTable(int lenght){
        String info;
        for(indexR = 1; indexR<=lenght; indexR++){
            newRow();
            for(indexC = 0; indexC<header.length; indexC++){
                newCell();
                //System.out.println(indexC);
                //System.out.println(indexR);
                String[] row = data.get(indexR-1);
                info=(indexC<row.length)?row[indexC]:"";
                txtCell.setText(info);
                tableRow.addView(txtCell,newTableRowParams());

            }
            tableLayout.addView(tableRow);

        }
    }
    /*
    public void addItems(String[]item){
        String info;
        data.add(item);
        indexC=0;
        newRow();
        while (indexC< header.length){
            newCell();
            info=(indexC<item.length)?item[indexC++]:"";
            txtCell.setText(info);
            tableRow.addView(txtCell,newTableRowParams());
        }
        tableLayout.addView(tableRow,data.size()-1);
        reColoring();
    }

     */
    public void backgroundHeader(int color){
        indexC=0;
        newRow();
        while (indexC< header.length){
            txtCell=getCell(0,indexC++);
            txtCell.setBackgroundColor(color);


        }
    }
    public void backgroundData(int firstColor, int secondColor, int size){

        for(indexR = 1; indexR<=size; indexR++){
            multiColor=!multiColor;
            for(indexC = 0; indexC<header.length; indexC++){
                txtCell=getCell(indexR,indexC);
                txtCell.setBackgroundColor((multiColor)?firstColor:secondColor);
            }

        }
        this.firstColor=firstColor;
        this.secondColor=secondColor;
    }
    public void textColorData(int color,int size){
        for(indexR = 1; indexR<=size; indexR++)
            for(indexC = 0; indexC<header.length; indexC++)
                getCell(indexR, indexC).setTextColor(color);
        this.textColor=color;
    }

    public void textColorHeader(int color){
        indexC=0;
        while (indexC< header.length)
            getCell(0,indexC++).setTextColor(color);
    }
    public void lineColor(int color){
       indexR=0;
       while(indexR<data.size()+1){
           getRow(indexR++).setBackgroundColor(color);
       }
    }

    public void reColoring(){
        indexC=0;
        multiColor=!multiColor;
        while (indexC< header.length){
            txtCell=getCell(data.size()-1,indexC++);
            txtCell.setBackgroundColor((multiColor)?firstColor:secondColor);
            txtCell.setTextColor(textColor);
        }
    }
    private TableRow getRow(int index){
        return (TableRow)tableLayout.getChildAt(index);
    }
    private TextView getCell(int rowIndex, int columIndex){
        tableRow=getRow(rowIndex);
        return (TextView) tableRow.getChildAt(columIndex);
    }

    private TableRow.LayoutParams newTableRowParams(){
        TableRow.LayoutParams params = new TableRow.LayoutParams();
        params.setMargins(2 ,2 ,2, 2);
        params.weight=1;
        return params;
    }
}
