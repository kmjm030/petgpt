package com.mc.app.service;

import com.mc.app.dto.Item;
import com.mc.app.dto.ItemFilterCriteria;
import com.mc.app.dto.SortType;
import com.mc.app.frame.MCService;
import com.mc.app.repository.ItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ItemService implements MCService<Item, Integer> {

    final ItemRepository itemRepository;
    final OptionService optionService;

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
    
    public List<Item> getWithSort(SortType sortType) throws Exception {
        if (sortType == null || sortType == SortType.DEFAULT) {
            return get();
        }
        return itemRepository.selectWithOrder(sortType.getSqlOrderBy());
    }
    
    public List<Item> findByCategoryWithSort(int categoryKey, SortType sortType) throws Exception {
        if (sortType == null || sortType == SortType.DEFAULT) {
            return findByCategory(categoryKey);
        }
        return itemRepository.findByCategoryWithOrder(categoryKey, sortType.getSqlOrderBy());
    }
    
    public List<Item> findByItemKeysWithSort(List<Integer> itemKeys, SortType sortType) throws Exception {
        if (itemKeys == null || itemKeys.isEmpty()) {
            return List.of();
        }
        if (sortType == null || sortType == SortType.DEFAULT) {
            return findByItemKeys(itemKeys);
        }
        return itemRepository.findByItemKeysWithOrder(itemKeys, sortType.getSqlOrderBy());
    }
    
    public List<Item> findByPriceRangeWithSort(int minPrice, int maxPrice, SortType sortType) throws Exception {
        if (sortType == null || sortType == SortType.DEFAULT) {
            return findByPriceRange(minPrice, maxPrice);
        }
        return itemRepository.findByPriceRangeWithOrder(minPrice, maxPrice, sortType.getSqlOrderBy());
    }
    
    public List<Item> findByPriceGreaterThanWithSort(int minPrice, SortType sortType) throws Exception {
        if (sortType == null || sortType == SortType.DEFAULT) {
            return findByPriceGreaterThan(minPrice);
        }
        return itemRepository.findByPriceGreaterThanWithOrder(minPrice, sortType.getSqlOrderBy());
    }
    
    public List<Item> findByPriceFilter(String priceFilter) throws Exception {
        return findByPriceFilter(priceFilter, SortType.DEFAULT);
    }
    
    public List<Item> findByPriceFilter(String priceFilter, SortType sortType) throws Exception {
        if (priceFilter == null || priceFilter.isEmpty()) {
            return getWithSort(sortType); 
        }
        
        if (priceFilter.equals("0-10")) {
            return findByPriceRangeWithSort(0, 10000, sortType);
        } else if (priceFilter.equals("10-20")) {
            return findByPriceRangeWithSort(10000, 20000, sortType);
        } else if (priceFilter.equals("20-30")) {
            return findByPriceRangeWithSort(20000, 30000, sortType);
        } else if (priceFilter.equals("30-40")) {
            return findByPriceRangeWithSort(30000, 40000, sortType);
        } else if (priceFilter.equals("40-50")) {
            return findByPriceRangeWithSort(40000, 50000, sortType);
        } else if (priceFilter.equals("50plus") || priceFilter.contains("50-") || 
                  priceFilter.contains("60-") || priceFilter.contains("70-") ||
                  priceFilter.contains("80-") || priceFilter.contains("90-") ||
                  priceFilter.contains("100plus")) {
            return findByPriceGreaterThanWithSort(50000, sortType);
        } else {
            return getWithSort(sortType); 
        }
    }
    
    public List<Item> findItemsByFilter(ItemFilterCriteria criteria) throws Exception {
        if (criteria == null || !criteria.hasAnyFilter()) {
            return get(); 
        }
        
        SortType sortType = criteria.getSortType();
        
        List<Integer> sizeFilteredItems = null;
        List<Integer> colorFilteredItems = null;
        List<Item> priceFilteredItems = null;
        
        if (criteria.hasSizeFilter()) {
            sizeFilteredItems = optionService.getItemKeysBySize(criteria.getSize());
        }
        
        if (criteria.hasColorFilter()) {
            colorFilteredItems = optionService.getItemKeysByColor(criteria.getColor());
        }
        
        if (criteria.hasPriceFilter()) {
            priceFilteredItems = findByPriceFilter(criteria.getPrice(), sortType);
        }
        
        List<Integer> optionFilteredItemKeys = combineOptionFilters(sizeFilteredItems, colorFilteredItems);
        
        List<Item> result = new ArrayList<>();
        
        if (criteria.hasCategoryFilter()) {
            List<Item> categoryItems;
            
            // 카테고리 + 정렬 조건
            if (sortType != SortType.DEFAULT) {
                categoryItems = findByCategoryWithSort(criteria.getCategoryKey(), sortType);
            } else {
                categoryItems = findByCategory(criteria.getCategoryKey());
            }
            
            if (optionFilteredItemKeys != null && priceFilteredItems != null) {
                // 카테고리 + 옵션 + 가격 필터
                final List<Integer> finalFilteredKeys = optionFilteredItemKeys;
                result = priceFilteredItems.stream()
                        .filter(item -> finalFilteredKeys.contains(item.getItemKey()) && 
                                       item.getCategoryKey() == criteria.getCategoryKey())
                        .toList();
                        
            } else if (optionFilteredItemKeys != null) {
                // 카테고리 + 옵션 필터
                final List<Integer> finalFilteredKeys = optionFilteredItemKeys;
                
                if (sortType != SortType.DEFAULT) {
                    List<Item> filteredItems = categoryItems.stream()
                            .filter(item -> finalFilteredKeys.contains(item.getItemKey()))
                            .toList();
                    
                    List<Integer> filteredItemKeys = filteredItems.stream()
                            .map(Item::getItemKey)
                            .toList();
                    
                    result = findByItemKeysWithSort(filteredItemKeys, sortType);
                } else {
                    result = categoryItems.stream()
                            .filter(item -> finalFilteredKeys.contains(item.getItemKey()))
                            .toList();
                }
            } else if (priceFilteredItems != null) {
                // 카테고리 + 가격 필터
                result = priceFilteredItems.stream()
                        .filter(item -> item.getCategoryKey() == criteria.getCategoryKey())
                        .toList();
            } else {
                // 카테고리만 적용
                result = categoryItems;
            }
        } else {
            // 카테고리 없이 필터만 적용
            if (optionFilteredItemKeys != null && priceFilteredItems != null) {
                // 옵션 + 가격 필터
                final List<Integer> finalFilteredKeys = optionFilteredItemKeys;
                result = priceFilteredItems.stream()
                        .filter(item -> finalFilteredKeys.contains(item.getItemKey()))
                        .toList();
            } else if (optionFilteredItemKeys != null) {
                // 옵션 필터만 적용
                result = findByItemKeysWithSort(optionFilteredItemKeys, sortType);
            } else if (priceFilteredItems != null) {
                // 가격 필터만 적용
                result = priceFilteredItems;
            } else if (sortType != SortType.DEFAULT) {
                // 정렬만 적용
                result = getWithSort(sortType);
            } else {
                result = get();
            }
        }
        
        return result;
    }
    
    private List<Integer> combineOptionFilters(List<Integer> sizeFilteredItems, List<Integer> colorFilteredItems) {
        if (sizeFilteredItems != null && colorFilteredItems != null) {
            return sizeFilteredItems.stream()
                    .filter(colorFilteredItems::contains)
                    .toList();

        } else if (sizeFilteredItems != null) {
            return sizeFilteredItems;

        } else if (colorFilteredItems != null) {
            return colorFilteredItems;
        }

        return null;
    }
}
