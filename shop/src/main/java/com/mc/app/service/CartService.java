package com.mc.app.service;

import com.mc.app.dto.Cart;
import com.mc.app.frame.MCService;
import com.mc.app.repository.CartRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CartService implements MCService<Cart, String> {

    final CartRepository cartRepository;


    @Override
    public void add(Cart cart) throws Exception {
        cartRepository.insert(cart);
    }

    @Override
    public void mod(Cart cart) throws Exception {
        cartRepository.update(cart);
    }

    @Override
    public void del(String custId) throws Exception {
        // 이 메소드는 특정 고객의 모든 장바구니 항목을 삭제해버림
        cartRepository.delete(custId);
    }

    // 특정 옵션의 상품을 삭제하도록 optionKey 파라미터 추가
    public void del(String custId, int itemKey, Integer optionKey) throws Exception {
        Cart cart = new Cart();
        cart.setCustId(custId);
        cart.setItemKey(itemKey);
        cart.setOptionKey(optionKey);
        cartRepository.delete(cart);
    }

    @Override
    // 이 메소드는 custId만으로는 고유한 Cart 항목을 식별하기 어려우므로 사용에 주의가 필요함
    public Cart get(String id) throws Exception {
        return cartRepository.selectOne(id);
    }

    @Override
    public List<Cart> get() throws Exception {
        return cartRepository.select();
    }

    public List<Map<String, Object>> getCartWithItems(String custId) throws Exception {
        return cartRepository.selectCartWithItems(custId);
    }
}
