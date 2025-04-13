package com.mc.app.service;

import com.mc.app.dto.Item;
import com.mc.app.frame.MCService;
import com.mc.app.repository.ItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ItemService implements MCService<Item, Integer> {

    final ItemRepository itemRepository;

    @Override
    public void add(Item item) throws Exception {
        itemRepository.insert(item);
    }

    @Override
    public void mod(Item item) throws Exception {
        itemRepository.update(item);
    }

    @Override
    public void del(Integer integer) throws Exception {
        itemRepository.delete(integer);
    }

    @Override
    public Item get(Integer integer) throws Exception {
        return itemRepository.selectOne(integer);
    }

    @Override
    public List<Item> get() throws Exception {
        return itemRepository.select();
    }

    public List<Item> findByCategory(int categoryKey) throws Exception {
        return itemRepository.findByCategory(categoryKey);
    }
    
    public List<Item> findByItemKeys(List<Integer> itemKeys) throws Exception {
        if (itemKeys == null || itemKeys.isEmpty()) {
            return List.of();
        }
        return itemRepository.findByItemKeys(itemKeys);
    }
    
    public List<Item> findByPriceRange(int minPrice, int maxPrice) throws Exception {
        return itemRepository.findByPriceRange(minPrice, maxPrice);
    }
    
    public List<Item> findByPriceGreaterThan(int minPrice) throws Exception {
        return itemRepository.findByPriceGreaterThan(minPrice);
    }
    
    public List<Item> findByPriceFilter(String priceFilter) throws Exception {
        if (priceFilter == null || priceFilter.isEmpty()) {
            return get();
        }
        
        if (priceFilter.equals("0-10")) {
            return findByPriceRange(0, 10000);
        } else if (priceFilter.equals("10-20")) {
            return findByPriceRange(10000, 20000);
        } else if (priceFilter.equals("20-30")) {
            return findByPriceRange(20000, 30000);
        } else if (priceFilter.equals("30-40")) {
            return findByPriceRange(30000, 40000);
        } else if (priceFilter.equals("40-50")) {
            return findByPriceRange(40000, 50000);
        } else if (priceFilter.contains("50-") || 
                  priceFilter.contains("60-") || priceFilter.contains("70-") ||
                  priceFilter.contains("80-") || priceFilter.contains("90-") ||
                  priceFilter.contains("100plus")) {
            return findByPriceGreaterThan(50000);
        } else {
            return get();
        }
    }
}
