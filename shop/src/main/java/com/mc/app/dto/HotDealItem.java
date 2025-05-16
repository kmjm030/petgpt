package com.mc.app.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HotDealItem {

    private int itemKey;
    private String itemName;
    private String itemImg1;
    private int itemPrice;
    private int hotDealPrice; 

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss") 
    private LocalDateTime expiryTime;
    
    public static HotDealItem from(Item item, LocalDateTime expiryTime) {
        if (item == null || expiryTime == null) {
            return null;
        }

        int itemPrice = item.getItemPrice();
        int hotDealPrice = (int) (itemPrice * 0.5);

        return new HotDealItem(
                item.getItemKey(),
                item.getItemName(),
                item.getItemImg1(),
                itemPrice,
                hotDealPrice,
                expiryTime);
    }
}
