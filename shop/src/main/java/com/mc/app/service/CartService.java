package com.mc.app.service;

import com.mc.app.dto.Cart;
import com.mc.app.frame.MCService;
import com.mc.app.repository.CartRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CartService implements MCService<Cart, String> {

    final CartRepository cartRepository;
    final HotDealService hotDealService;

    /**
     * 장바구니에 상품을 추가하거나 수량을 업데이트
     * 추가되는 상품이 현재 유효한 핫딜 상품이면 isHotDeal 플래그를 true로 설정
     */
    @Override
    @Transactional
    public void add(Cart cart) throws Exception {
        // 1. 핫딜 여부 확인
        Integer currentHotDealKey = hotDealService.getCurrentHotDealItemKey();
        LocalDateTime expiryTime = hotDealService.getHotDealExpiryTime();

        boolean isCurrentHotDeal = false;
        if (currentHotDealKey != null && currentHotDealKey.equals(cart.getItemKey()) &&
                expiryTime != null && expiryTime.isAfter(LocalDateTime.now())) {

            isCurrentHotDeal = true;
        }

        // 2. Cart 객체에 핫딜 여부 설정
        cart.setHotDeal(isCurrentHotDeal);

        // 3. DB에 저장 (insert 쿼리가 ON DUPLICATE KEY UPDATE 처리)
        cartRepository.insert(cart);
    }

    /**
     * 장바구니 상품의 수량을 변경
     * 핫딜 상태는 변경하지 않음음
     */
    @Override
    @Transactional
    public void mod(Cart cart) throws Exception {
        cartRepository.update(cart);
    }

    /**
     * 특정 고객의 장바구니 전체를 삭제(사용 안함)
     */
    @Override
    @Transactional
    public void del(String custId) throws Exception {
        cartRepository.delete(custId);
    }

    /**
     * 특정 고객의 장바구니에서 특정 상품(옵션 포함)을 삭제
     */
    @Transactional
    public void del(String custId, int itemKey, Integer optionKey) throws Exception {
        Cart cart = Cart.builder()
                .custId(custId)
                .itemKey(itemKey)
                .optionKey(optionKey)
                .build();
        cartRepository.delete(cart);
    }

    /**
     * 특정 고객의 장바구니 정보를 조회(사용 안함)
     */
    @Override
    public Cart get(String id) throws Exception {
        return cartRepository.selectOne(id);
    }

    /**
     * 모든 장바구니 정보를 조회(관리자용)
     */
    @Override
    public List<Cart> get() throws Exception {
        return cartRepository.select();
    }

    /**
     * 특정 고객의 장바구니 목록과 관련 상품/옵션 정보를 함께 조회
     * isHotDeal 플래그가 포함됨됨
     *
     * @param custId 조회할 고객 ID
     * @return 장바구니 항목 정보 목록 (Map 형태)
     */
    public List<Map<String, Object>> getCartWithItems(String custId) throws Exception {
        return cartRepository.selectCartWithItems(custId);
    }
}
