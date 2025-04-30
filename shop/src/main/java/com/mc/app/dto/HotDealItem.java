package com.mc.app.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.mc.app.dto.Item;
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
    private int hotDealPrice; // 특가 (50%)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss") // ISO 8601 형식 문자열로 변환
    private LocalDateTime expiryTime;

    /**
     * Item 객체와 만료 시간으로 HotDealItem을 생성하는 정적 팩토리 메서드
     * Item 객체나 만료 시간이 null이면 null을 반환
     *
     * @param item       특가 상품 Item 객체
     * @param expiryTime 특가 만료 시간
     * @return 생성된 HotDealItem 객체 또는 null
     */
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
