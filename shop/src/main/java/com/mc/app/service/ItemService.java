package com.mc.app.service;

import com.mc.app.dto.Item;
import com.mc.app.dto.ItemFilterCriteria;
import com.mc.app.dto.SortType;
import com.mc.app.frame.MCService;
import com.mc.app.repository.ItemRepository;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ItemService implements MCService<Item, Integer> {

    final ItemRepository itemRepository;
    final OptionService optionService;

    @Override
    @Transactional
    public void add(Item item) throws Exception {
        itemRepository.insert(item);
        if (item.getItemDetail() != null && !item.getItemDetail().isEmpty()) {

            if (item.getItemKey() > 0) {
                itemRepository.upsertItemDetail(item);

            } else {
                throw new Exception("Failed to get generated itemKey after insert.");
            }
        }
    }

    @Override
    @Transactional
    public void mod(Item item) throws Exception {
        itemRepository.update(item);
        if (item.getItemDetail() != null) {
            itemRepository.upsertItemDetail(item);
        }
    }

    @Override
    @Transactional
    public void del(Integer itemKey) throws Exception {
        itemRepository.delete(itemKey);
    }

    @Override
    public Item get(Integer itemKey) throws Exception {
        return itemRepository.selectOne(itemKey);
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

        String orderBy = sortType.getSqlOrderBy();
        if (orderBy == null || orderBy.isEmpty()) {
            return get();
        }

        return itemRepository.selectWithOrder(orderBy);
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

        String orderBy = (sortType != null && sortType != SortType.DEFAULT) ? sortType.getSqlOrderBy() : null;

        if (priceFilter.equals("0-10")) {
            return itemRepository.findByPriceRangeWithOrder(0, 10000, orderBy);
        } else if (priceFilter.equals("10-20")) {
            return itemRepository.findByPriceRangeWithOrder(10000, 20000, orderBy);
        } else if (priceFilter.equals("20-30")) {
            return itemRepository.findByPriceRangeWithOrder(20000, 30000, orderBy);
        } else if (priceFilter.equals("30-40")) {
            return itemRepository.findByPriceRangeWithOrder(30000, 40000, orderBy);
        } else if (priceFilter.equals("40-50")) {
            return itemRepository.findByPriceRangeWithOrder(40000, 50000, orderBy);
        } else if (priceFilter.equals("50plus") || priceFilter.contains("50-") ||
                priceFilter.contains("60-") || priceFilter.contains("70-") ||
                priceFilter.contains("80-") || priceFilter.contains("90-") ||
                priceFilter.contains("100plus")) {
            return itemRepository.findByPriceGreaterThanWithOrder(50000, orderBy);
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

            if (sortType != SortType.DEFAULT) {
                categoryItems = findByCategoryWithSort(criteria.getCategoryKey(), sortType);
            } else {
                categoryItems = findByCategory(criteria.getCategoryKey());
            }

            if (optionFilteredItemKeys != null && priceFilteredItems != null) {
                final List<Integer> finalFilteredKeys = optionFilteredItemKeys;
                result = priceFilteredItems.stream()
                        .filter(item -> finalFilteredKeys.contains(item.getItemKey()) &&
                                item.getCategoryKey() == criteria.getCategoryKey())
                        .toList();

            } else if (optionFilteredItemKeys != null) {
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
                result = priceFilteredItems.stream()
                        .filter(item -> item.getCategoryKey() == criteria.getCategoryKey())
                        .toList();
            } else {
                result = categoryItems;
            }
        } else {
            if (optionFilteredItemKeys != null && priceFilteredItems != null) {
                final List<Integer> finalFilteredKeys = optionFilteredItemKeys;
                result = priceFilteredItems.stream()
                        .filter(item -> finalFilteredKeys.contains(item.getItemKey()))
                        .toList();
            } else if (optionFilteredItemKeys != null) {
                result = findByItemKeysWithSort(optionFilteredItemKeys, sortType);
            } else if (priceFilteredItems != null) {
                result = priceFilteredItems;
            } else if (sortType != SortType.DEFAULT) {
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

    public List<Item> findByNameContaining(String keyword) throws Exception {
        if (keyword == null || keyword.trim().isEmpty()) {
            return get();
        }
        return itemRepository.findByNameContaining(keyword);
    }

    public List<Item> findByNameContainingWithSort(String keyword, SortType sortType) throws Exception {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getWithSort(sortType);
        }

        if (sortType == null || sortType == SortType.DEFAULT) {
            return findByNameContaining(keyword);
        }

        return itemRepository.findByNameContainingWithOrder(keyword, sortType.getSqlOrderBy());
    }

    public int getTotalItemsCount(ItemFilterCriteria criteria) throws Exception {
        if (criteria == null || !criteria.hasAnyFilter()) {
            return itemRepository.getTotalCount();
        }

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
            priceFilteredItems = findByPriceFilter(criteria.getPrice(), SortType.DEFAULT);
        }

        List<Integer> optionFilteredItemKeys = combineOptionFilters(sizeFilteredItems, colorFilteredItems);

        if (optionFilteredItemKeys != null && !optionFilteredItemKeys.isEmpty()) {
            if (priceFilteredItems != null && !priceFilteredItems.isEmpty()) {
                return (int) priceFilteredItems.stream()
                        .filter(item -> optionFilteredItemKeys.contains(item.getItemKey()))
                        .count();
            }
            return optionFilteredItemKeys.size();
        }

        if (priceFilteredItems != null && !priceFilteredItems.isEmpty()) {
            return priceFilteredItems.size();
        }

        return itemRepository.getTotalCount();
    }

    public List<Item> findItemsByFilterWithPagination(ItemFilterCriteria criteria, int page, int itemsPerPage)
            throws Exception {
        List<Item> allItems = findItemsByFilter(criteria);
        int startIndex = (page - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, allItems.size());

        if (startIndex >= allItems.size()) {
            return new ArrayList<>();
        }

        return allItems.subList(startIndex, endIndex);
    }

    public List<Item> getBestSellingItems(int limit) throws Exception {
        return itemRepository.selectItemsByReviewCount(limit);
    }

    public List<Item> getNewestItems(int limit) throws Exception {
        SortType sortType = SortType.NEWEST;
        String orderBy = sortType.getSqlOrderBy();
        if (orderBy == null) {
            throw new IllegalArgumentException("NEWEST 정렬 기준(sqlOrderBy)이 SortType에 정의되지 않았습니다.");
        }
        return itemRepository.selectWithOrderAndLimit(orderBy, limit);
    }

    public List<Item> getHighestDiscountItems(int limit) throws Exception {
        SortType sortType = SortType.HIGHEST_DISCOUNT;
        String orderBy = sortType.getSqlOrderBy();

        if (orderBy == null) {
            throw new IllegalArgumentException("HIGHEST_DISCOUNT 정렬 기준(sqlOrderBy)이 SortType에 정의되지 않았습니다.");
        }

        return itemRepository.selectWithOrderAndLimit(orderBy, limit);
    }

    public List<Integer> getRandomItems(List<Integer> items, int count) {
      Collections.shuffle(items);
      return items.stream().limit(count).collect(Collectors.toList());
    }

    public List<Item> findItemsByKeys(List<Integer> keys) {
      return itemRepository.findItemsByKeys(keys);
    }


}
