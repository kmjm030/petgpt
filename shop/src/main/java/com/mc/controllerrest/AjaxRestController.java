package com.mc.controllerrest;

import com.mc.app.dto.Customer;
import com.mc.app.service.CouponService;
import com.mc.app.service.CustomerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@Slf4j
@RequiredArgsConstructor
public class AjaxRestController {

    private final CustomerService customerService;
    private final CouponService couponService;

    @RequestMapping("/checkid")
    public Object checkid(@RequestParam("cid") String id) throws Exception {
        Customer cust = customerService.get(id);
        int result = 1;
        if(cust != null && id.equals(cust.getCustId())){
            result = 0;
        }
        return result;
    }

    @RequestMapping("/checknick")
    public Object checknick(@RequestParam("nick") String nick) throws Exception {
        int result = 1;
        List<Customer> custs = customerService.get();

        for(Customer cust : custs){
            if(nick != null && nick.equals(cust.getCustNick())){
                result = 0;
            }
        }
        return result;

    }

//    @RequestMapping("/checkcoupon")
//    public Object checkcoupon(@RequestParam("couponId") int couponId) throws Exception {
//
//    }
}
