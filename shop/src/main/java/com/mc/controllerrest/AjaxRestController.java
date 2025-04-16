package com.mc.controllerrest;

import com.mc.app.dto.Coupon;
import com.mc.app.dto.Customer;
import com.mc.app.service.CouponService;
import com.mc.app.service.CustomerService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
        if (cust != null && id.equals(cust.getCustId())) {
            result = 0;
        }
        return result;
    }

    @RequestMapping("/checknick")
    public Object checknick(@RequestParam("nick") String nick) throws Exception {
        int result = 1;
        List<Customer> custs = customerService.get();

        for (Customer cust : custs) {
            if (nick != null && nick.equals(cust.getCustNick())) {
                result = 0;
            }
        }
        return result;

    }

    @RequestMapping("/checkcoupon")
    public @ResponseBody Object checkcoupon(@RequestParam("couponId") int couponId,
                                            @RequestParam("price") int price, HttpSession session) throws Exception {
        int amount = 0;
        Coupon coupon = couponService.get(couponId);
        Integer couponPrice = coupon.getCouponPrice();
        Integer couponRate = coupon.getCouponRate();

        if (couponPrice != null && couponPrice != 0) {
            amount = price - couponPrice;
        } else if (couponRate != null && couponRate != 0) {
            amount = (int) (price * ((100 - couponRate) * 0.01));
        }

        int discountedPrice = price - amount;
        Integer maxPrice = coupon.getCouponMaxPrice();
        if(maxPrice != null && maxPrice < amount){
            discountedPrice = maxPrice;
            amount = price - discountedPrice;
        }

        return amount;
    }
}

