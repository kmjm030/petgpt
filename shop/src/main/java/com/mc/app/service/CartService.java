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

    @Override
    @Transactional
    public void add(Cart cart) throws Exception {
        Integer currentHotDealKey = hotDealService.getCurrentHotDealItemKey();
        LocalDateTime expiryTime = hotDealService.getHotDealExpiryTime();

        boolean isCurrentHotDeal = false;
        if (currentHotDealKey != null && currentHotDealKey > 0 &&
                currentHotDealKey.equals(cart.getItemKey()) &&
                expiryTime != null && expiryTime.isAfter(LocalDateTime.now())) {

            isCurrentHotDeal = true;
        }

        cart.setHotDeal(isCurrentHotDeal);
        cartRepository.insert(cart);
    }

    @Override
    @Transactional
    public void mod(Cart cart) throws Exception {
        cartRepository.update(cart);
    }

    @Override
    @Transactional
    public void del(String custId) throws Exception {
        cartRepository.delete(custId);
    }

    @Transactional
    public void del(String custId, int itemKey, Integer optionKey) throws Exception {
        Cart cart = Cart.builder()
                .custId(custId)
                .itemKey(itemKey)
                .optionKey(optionKey)
                .build();
        cartRepository.delete(cart);
    }

    @Override
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

    public void deleteByCust(String custId) throws Exception {
      cartRepository.deleteByCust(custId);
    }
}
