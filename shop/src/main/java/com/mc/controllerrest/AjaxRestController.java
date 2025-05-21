package com.mc.controllerrest;

import com.mc.app.dto.Coupon;
import com.mc.app.dto.Customer;
import com.mc.app.dto.Item;
import com.mc.app.dto.Pet;
import com.mc.app.service.CouponService;
import com.mc.app.service.CustomerService;
import com.mc.app.service.ItemService;
import com.mc.app.service.PetService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.*;

@RestController
@Slf4j
@RequiredArgsConstructor
public class AjaxRestController {

    private final CustomerService customerService;
    private final CouponService couponService;
    private final PetService petService;
    private final ItemService itemService;

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

    @RequestMapping("/recommenditem")
    @ResponseBody
    public Object recommenditem(@RequestParam("id") String custId, Model model) throws Exception{
      List<Integer> youngCatItemKeys = List.of(151, 131, 154, 133);
      List<Integer> adultCatItemKeys = List.of(150, 152, 130, 154);
      List<Integer> seniorCatItemKeys = List.of(154, 132, 133, 134);

      List<Integer> youngDogItemKeys = List.of(100, 101, 140, 143, 160, 163);
      List<Integer> adultDogItemKeys = List.of(101, 104, 143, 161, 162, 164);
      List<Integer> seniorDogItemKeys = List.of(101, 103, 141, 142, 144, 160);

      List<Pet> pets = petService.findByCust(custId);
      Map<String, List<Item>> recommendedItemsMap = new HashMap<>();

      for (Pet pet : pets) {
        Date date = pet.getPetBirthdate();
        LocalDate birthDate = date.toInstant()
          .atZone(ZoneId.systemDefault())
          .toLocalDate();

        int age = Period.between(birthDate, LocalDate.now()).getYears();

        List<Integer> itemKeys = new ArrayList<>();
        if(pet.getPetType().equals("dog")){
          if (age <= 1) {
            itemKeys = itemService.getRandomItems(new ArrayList<>(youngDogItemKeys), 3);
          } else if (age < 10) {
            itemKeys = itemService.getRandomItems(new ArrayList<>(adultDogItemKeys), 3);
          } else {
            itemKeys = itemService.getRandomItems(new ArrayList<>(seniorDogItemKeys), 3);
          }
        }else if(pet.getPetType().equals("cat")){
          if (age <= 1) {
            itemKeys = itemService.getRandomItems(new ArrayList<>(youngCatItemKeys), 3);
          } else if (age < 10) {
            itemKeys = itemService.getRandomItems(new ArrayList<>(adultCatItemKeys), 3);
          } else {
            itemKeys = itemService.getRandomItems(new ArrayList<>(seniorCatItemKeys), 3);
          }
        }
        // itemKey들로 실제 아이템 객체들 불러오기
        List<Item> reItems = itemService.findItemsByKeys(itemKeys);
        recommendedItemsMap.put(pet.getPetName(), reItems);
      }

      return recommendedItemsMap;
    }
}

