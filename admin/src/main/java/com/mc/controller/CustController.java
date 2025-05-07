package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.service.CustomerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/cust")
public class CustController {

    final CustomerService custService;
    final BCryptPasswordEncoder bCryptPasswordEncoder;
    final StandardPBEStringEncryptor standardPBEStringEncryptor;

    String dir = "cust/";

    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        List<Customer> list = null;
        try {
            list = custService.get();
            model.addAttribute("custs", list);
            model.addAttribute("center", dir + "get");
        } catch (Exception e) {
            throw new Exception("ER0001");
        }
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("center", dir + "add");
        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("id") String id) {
        Customer cust = null;
        try {
            cust = custService.get(id);
            model.addAttribute("cust", cust);
            model.addAttribute("center", dir + "detail");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return "index";
    }

    @RequestMapping("/update")
    public String update(Model model, Customer cust) {
        try {
            custService.mod(cust);
            model.addAttribute("cust", cust);
            return "redirect:/cust/detail?id=" + cust.getCustId();
        } catch (Exception e) {
            log.info("ERROR=============================={}", e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @RequestMapping("/addimpl")
    public String addimpl(Model model, Customer cust) throws Exception {
        custService.add(cust);
        return "redirect:/cust/detail?id=" + cust.getCustId();
    }

    @RequestMapping("/delete")
    public String delete(Model model, @RequestParam("id") String id) {
        try {
            custService.del(id);
            return "redirect:/cust/get";
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @RequestMapping("/")
    public String main(Model model) {
        try {
            int custCount = custService.getCount();
            model.addAttribute("custCount", custCount);
        } catch (Exception e) {
            model.addAttribute("custCount", 0);
        }
        model.addAttribute("center", "center");
        return "index";
    }
    @RequestMapping("/today")
    public String todayJoinList(Model model) {
        try {
            List<Customer> list = custService.getTodayJoinedCustomers();
            model.addAttribute("todayJoinedList", list);
            model.addAttribute("center", "cust/todayList");
        } catch (Exception e) {
            model.addAttribute("todayJoinedList", null);
            model.addAttribute("center", "cust/todayList");
        }
        return "index";
    }

}