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

          List<Item> allItems = itemService.get();
          List<Integer> keysToRemove = Arrays.asList(100, 101, 102, 103, 104, 130, 131, 132, 133, 134, 140, 141, 142, 143, 144, 150, 151, 152, 153, 154, 160, 161, 162, 163, 164);
          allItems.removeIf(item -> keysToRemove.contains(item.getItemKey()));

        List<Integer> itemKeys = new ArrayList<>();
        if(pet.getPetType().equals("dog")){
          if (age <= 1) {
            itemKeys = itemService.getRandomItems(new ArrayList<>(youngDogItemKeys), 3);
          } else if (age < 10) {
            itemKeys = itemService.getRandomItems(new ArrayList<>(adultDogItemKeys), 3);
          } else {
            itemKeys = itemService.getRandomItems(new ArrayList<>(seniorDogItemKeys), 3);
          }
          allItems.removeIf(item -> item.getCategoryKey() >= 1 && item.getCategoryKey() <= 9);
        }else if(pet.getPetType().equals("cat")){
          if (age <= 1) {
            itemKeys = itemService.getRandomItems(new ArrayList<>(youngCatItemKeys), 3);
          } else if (age < 10) {
            itemKeys = itemService.getRandomItems(new ArrayList<>(adultCatItemKeys), 3);
          } else {
            itemKeys = itemService.getRandomItems(new ArrayList<>(seniorCatItemKeys), 3);
          }
          allItems.removeIf(item -> item.getCategoryKey() > 9);
        }

        List<Item> reItems = itemService.findItemsByKeys(itemKeys);

        Random rand = new Random();
        int total = allItems.size();
        if (total >= 2) {
          int first = rand.nextInt(total);
          int second;
          do {
            second = rand.nextInt(total);
          } while (second == first);

          Item randomItem1 = allItems.get(first);
          Item randomItem2 = allItems.get(second);

          // reItems 중간에 랜덤하게 끼워 넣기
          int insertPos1 = rand.nextInt(reItems.size() + 1); // 0 ~ size
          reItems.add(insertPos1, randomItem1);

          int insertPos2 = rand.nextInt(reItems.size() + 1); // 다시 랜덤한 위치 (방금 넣은 거 포함)
          reItems.add(insertPos2, randomItem2);
        } else {
          // 2개 미만이면 그냥 랜덤한 위치에 추가
          for (Item item : allItems) {
            int insertPos = rand.nextInt(reItems.size() + 1);
            reItems.add(insertPos, item);
          }
        }

        recommendedItemsMap.put(pet.getPetName(), reItems);
//
//        Collections.shuffle(allItems);
//        int randomCount = Math.min(2, allItems.size());
//        reItems.addAll(allItems.subList(0, randomCount));
//
//        recommendedItemsMap.put(pet.getPetName(), reItems);


      }

      return recommendedItemsMap;
    }
}

