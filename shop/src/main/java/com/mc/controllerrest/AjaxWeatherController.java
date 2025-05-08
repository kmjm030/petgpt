// package com.mc.controllerrest;

// import com.mc.util.WeatherUtil;
// import lombok.extern.slf4j.Slf4j;
// import org.json.simple.parser.ParseException;
// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RequestParam;
// import org.springframework.web.bind.annotation.RestController;

// import java.io.IOException;

// @RestController
// @Slf4j
// public class AjaxWeatherController {
// @Value("${app.key.wkey}")
// String wkey;
// @Value("${app.key.wkey2}")
// String wkey2;

// @RequestMapping("/getwinfo")
// public Object getwinfo(@RequestParam("loc") String loc) throws IOException,
// ParseException {
// String target = "1835847";
// switch (loc) {
// case "a":
// target = "1835847";
// break;
// case "s":
// target = "1835848";
// break;
// case "b":
// target = "1838524";
// break;
// case "j":
// target = "1846266";
// break;
// default:
// target = "1835847";
// }
// return WeatherUtil.getWeather2(target, wkey2);
// }

// @RequestMapping("/getwinfo2")
// public Object getwinfo2(@RequestParam("loc") String loc) throws IOException,
// ParseException {
// String target = "11B10101";
// switch (loc) {
// case "a":
// target = "11B10101";
// break;
// case "s":
// target = "11B10101";
// break;
// case "b":
// target = "11H20201";
// break;
// case "j":
// target = "11G00201";
// break;
// default:
// target = "11B10101";
// }
// return WeatherUtil.getWeatherForecast(target, wkey);
// }
// }
