package com.mc.util;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class PapagoUtil {

    public static String getMsg(String clientId, String clientSecret, String msg, String target) {
        String result = "";
        try {
            String text = URLEncoder.encode(msg, "UTF-8");
            String apiURL = "https://papago.apigw.ntruss.com/nmt/v1/translation";
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();

            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
            con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
            String postParams = "source=auto&target=" + target + "&text=" + text;
            con.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(postParams);
            wr.flush();
            wr.close();

            int responseCode = con.getResponseCode();
            BufferedReader br;
            if (responseCode == 200) { 
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8));
            } else { 
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), StandardCharsets.UTF_8));
            }
            String inputLine;
            StringBuffer response = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();
            
            JSONParser jsonparser = new JSONParser();
            try {
                JSONObject json = (JSONObject) jsonparser.parse(response.toString());
                JSONObject message = (JSONObject) json.get("message");
                JSONObject jresult = (JSONObject) message.get("result");
                result = (String) jresult.get("translatedText");
            } catch (Exception e) {
                System.out.println("파파고 응답 파싱 오류: " + response.toString());
                e.printStackTrace();
            }

        } catch (Exception e) {
            System.out.println("파파고 API 호출 오류: ");
            e.printStackTrace();
        }
        return result;
    }
} 