package com.lu.warehouse.commons.io;

import java.io.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class createTxt {
    /*
    public static void main(String[] args) throws IOException {

        Map<Integer, String> rowDataMap = readTxtFile("E:\\createTable\\mcc_sub_extend_001.txt");
        Map<Integer, String> provinceMap = readTxtFile("E:\\createTable\\province.txt");

        List<String> textList = new ArrayList<String>(10000);

        Iterator<Integer> iterator = rowDataMap.keySet().iterator();
        while (iterator.hasNext()) {
            Integer key = iterator.next();
            String rowdata = rowDataMap.get(key);
            String province = provinceMap.get(key);
            // 对文件进行行合并
            textList.add(province + "," + rowdata);
        }

        // 将内容写入文件
        writeTxtFile("E:\\createTable\\merge.txt", textList);

    }

*/
//    public static void main(String[] args) throws IOException {
//
//        write("E:\\createTable\\mcc_sub_extend_001.txt");
//    }
    /**
     * 根据文件路径读取文件
     *
     * @param filePath
     *            文件路径
     * @return Map<Integer, String>
     */
    public static Map<Integer, String> readTxtFile(String filePath) {

        Map<Integer, String> textMap = new HashMap<Integer, String>(10000);

        try (FileInputStream fileInputStream = new FileInputStream(filePath);
             InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, "UTF-8");
             BufferedReader bufferedReader = new BufferedReader(inputStreamReader);) {

            String line = null;
            Integer i = 0;
            while ((line = bufferedReader.readLine()) != null) {
                i = i + 1;
                textMap.put(i, line);
            }

        } catch (Exception e) {
            e.printStackTrace();

        }

        return textMap;
    }

    /**
     * 写入文件
     *
     * @param file
     *            文件路径
     * @param text
     *            文件行内容
     * @throws IOException
     *             异常信息
     */
    public static void writeTxtFile(String file, String text){
        BufferedWriter out = null;
        try {
             //FileOutputStream构造函数中的第二个参数true表示以追加形式写文件
             out = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream(file, true)));

                out.newLine();
                out.write(text);


         } catch (Exception e) {
             e.printStackTrace();
         } finally {
            try {
                 out.close();
             } catch (IOException e) {
                 e.printStackTrace();
             }
         }
    }

    public static void write(String s) throws IOException {
        File file=new File("E:\\createTable\\mcc_sub_extend_001.txt");
        OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream(file, true), "UTF-8");

        String string =s;
        osw.write("\n");
        osw.write(string);
        osw.close();
    }


}
