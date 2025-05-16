 package com.mc.controllerrest;

 import com.mc.util.WeatherUtil;
 import lombok.extern.slf4j.Slf4j;
 import org.json.simple.parser.ParseException;
 import org.springframework.beans.factory.annotation.Value;
 import org.springframework.web.bind.annotation.RequestMapping;
 import org.springframework.web.bind.annotation.RequestParam;
 import org.springframework.web.bind.annotation.RestController;

 import java.io.IOException;

 @RestController
 @Slf4j
 public class AjaxWeatherController {

    @Value("${app.key.wkey}")
    String wkey;
    @Value("${app.key.wkey2}")
    String wkey2;

    @RequestMapping("/getwinfo")
    public Object getwinfo(@RequestParam("loc") String loc) throws IOException, ParseException {
        return WeatherUtil.getWeather2(loc, wkey2);

    }

    @RequestMapping("/getwinfo2")
    public Object getwinfo2(@RequestParam("loc") String loc) throws IOException, ParseException {

        String target = "11B10101";
        return WeatherUtil.getWeatherForecast(target, wkey);

    }
 }
