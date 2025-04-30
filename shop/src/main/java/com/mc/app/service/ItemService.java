package com.mc.app.service;

import com.mc.app.dto.Item;
import com.mc.app.dto.ItemFilterCriteria;
import com.mc.app.dto.SortType;
import com.mc.app.frame.MCService;
import com.mc.app.repository.ItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ItemService implements MCService<Item, Integer> {

    final ItemRepository itemRepository;
    final OptionService optionService;

    /**
     * 새로운 상품 정보와 상세 설명을 등록
     * item 테이블과 item_details 테이블에 데이터를 추가
     *
     * @param item 등록할 상품 정보 (itemDetail 포함 가능)
     */
    @Override
    @Transactional
    public void add(Item item) throws Exception {
        // 1. item 테이블에 기본 정보 저장
        itemRepository.insert(item);

        // 2. item_details 테이블에 상세 정보 저장
        if (item.getItemDetail() != null && !item.getItemDetail().isEmpty()) {

            if (item.getItemKey() > 0) {
                itemRepository.upsertItemDetail(item);

            } else {
                throw new Exception("Failed to get generated itemKey after insert.");
            }
        }
    }

    /**
     * 기존 상품 정보와 상세 설명을 수정
     * item 테이블과 item_details 테이블의 데이터를 수정
     * itemDetail이 null이면 기존 상세 설명은 유지
     *
     * @param item 수정할 상품 정보 (itemKey 및 itemDetail 포함 가능)
     */
    @Override
    @Transactional
    public void mod(Item item) throws Exception {
        // 1. item 테이블 기본 정보 수정
        itemRepository.update(item);

        // 2. item_details 테이블 상세 정보 수정/추가 (UPSERT)
        if (item.getItemDetail() != null) {
            itemRepository.upsertItemDetail(item);
        }
    }

    /**
     * 지정된 키의 상품 정보와 상세 설명을 삭제
     *
     * @param itemKey 삭제할 상품의 키
     */
    @Override
    @Transactional
    public void del(Integer itemKey) throws Exception {
        // item_details 테이블은 ON DELETE CASCADE 설정으로 자동 삭제됨
        // 1. item 테이블 기본 정보 삭제
        itemRepository.delete(itemKey);
    }

    /**
     * 지정된 키의 상품 정보(상세 설명 포함)를 조회
     *
     * @param itemKey 조회할 상품의 키
     * @return 조회된 상품 정보 (상세 설명 포함), 없으면 null
     */
    @Override
    public Item get(Integer itemKey) throws Exception {
        return itemRepository.selectOne(itemKey);
    }

    /**
     * 모든 상품의 기본 정보 목록을 조회 (상세 설명 제외)
     *
     * @return 모든 상품의 기본 정보 목록
     */
    @Override
    public List<Item> get() throws Exception {
        return itemRepository.select();
    }

    /**
     * 지정된 카테고리에 속하는 상품 목록을 조회 (상세 설명 제외)
     *
     * @param categoryKey 조회할 카테고리 키
     * @return 해당 카테고리의 상품 목록
     */
    public List<Item> findByCategory(int categoryKey) throws Exception {
        return itemRepository.findByCategory(categoryKey);
    }

    /**
     * 주어진 상품 키 목록에 해당하는 상품 목록을 조회 (상세 설명 제외)
     *
     * @param itemKeys 조회할 상품 키 목록
     * @return 해당 상품 키 목록의 상품 목록, 없으면 빈 리스트
     */
    public List<Item> findByItemKeys(List<Integer> itemKeys) throws Exception {
        if (itemKeys == null || itemKeys.isEmpty()) {
            return List.of();
        }
        return itemRepository.findByItemKeys(itemKeys);
    }

    /**
     * 지정된 가격 범위 내의 상품 목록을 조회 (상세 설명 제외)
     *
     * @return 해당 가격 범위의 상품 목록
     */
    public List<Item> findByPriceRange(int minPrice, int maxPrice) throws Exception {
        return itemRepository.findByPriceRange(minPrice, maxPrice);
    }

    /**
     * 지정된 최소 가격 이상의 상품 목록을 조회 (상세 설명 제외)
     *
     * @return 해당 최소 가격 이상의 상품 목록
     */
    public List<Item> findByPriceGreaterThan(int minPrice) throws Exception {
        return itemRepository.findByPriceGreaterThan(minPrice);
    }

    /**
     * 지정된 정렬 기준으로 모든 상품 목록을 조회 (상세 설명 제외)
     *
     * @param sortType 정렬 기준
     * @return 정렬된 상품 목록
     */
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

    /**
     * 가격 필터로 상품 목록을 조회 (상세 설명 제외)
     *
     * @param priceFilter 가격 필터 문자열 (예: "10-20")
     * @return 필터링된 상품 목록
     */
    public List<Item> findByPriceFilter(String priceFilter) throws Exception {
        return findByPriceFilter(priceFilter, SortType.DEFAULT);
    }

    /**
     * 가격 필터와와 정렬 기준을 기반으로 상품 목록을 조회 (상세 설명 제외)
     *
     * @param priceFilter 가격 필터 문자열 (예: "10-20")
     * @param sortType    정렬 기준
     * @return 필터링 및 정렬된 상품 목록
     */
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

    /**
     * 다양한 필터 조건(카테고리, 가격, 사이즈, 색상)과 정렬 기준을 적용하여 상품 목록을 조회 (상세 설명 제외)
     *
     * @param criteria 필터 조건 객체
     * @return 필터링 및 정렬된 상품 목록
     */
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

    /**
     * 사이즈 필터 결과와 색상 필터 결과를 조합하여 교집합에 해당하는 상품 키 목록을 반환
     *
     * @param sizeFilteredItems  사이즈로 필터링된 상품 키 목록
     * @param colorFilteredItems 색상으로 필터링된 상품 키 목록
     * @return 조합된 상품 키 목록, 또는 한쪽 필터만 있으면 해당 목록, 둘 다 없으면 null
     */
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

    /**
     * 상품명에 특정 키워드가 포함된 상품 목록을 조회 (상세 설명 제외)
     *
     * @param keyword 검색할 키워드
     * @return 키워드가 포함된 상품 목록
     */
    public List<Item> findByNameContaining(String keyword) throws Exception {
        if (keyword == null || keyword.trim().isEmpty()) {
            return get();
        }
        return itemRepository.findByNameContaining(keyword);
    }

    /**
     * 상품명에 특정 키워드가 포함된 상품 목록을 지정된 순서로 정렬하여 조회 (상세 설명 제외)
     *
     * @param keyword  검색할 키워드
     * @param sortType 정렬 기준
     * @return 키워드가 포함되고 정렬된 상품 목록
     */
    public List<Item> findByNameContainingWithSort(String keyword, SortType sortType) throws Exception {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getWithSort(sortType);
        }

        if (sortType == null || sortType == SortType.DEFAULT) {
            return findByNameContaining(keyword);
        }

        return itemRepository.findByNameContainingWithOrder(keyword, sortType.getSqlOrderBy());
    }

    /**
     * 주어진 필터 조건에 맞는 전체 상품 개수를 조회
     *
     * @param criteria 필터 조건 객체
     * @return 필터링된 상품의 총 개수
     */
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

    /**
     * 주어진 필터 조건에 맞는 상품 목록을 페이지네이션하여 조회 (상세 설명 제외)
     *
     * @param criteria     필터 조건 객체
     * @param page         요청 페이지 번호 (1부터 시작)
     * @param itemsPerPage 페이지 당 아이템 수
     * @return 해당 페이지의 상품 목록
     */
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

    /**
     * 판매량 기준 상위 상품 목록 조회 (total_order 테이블 집계) (상세 설명 제외)
     * 
     * @param limit 조회할 상품 개수
     * @return 판매량 순 상품 목록
     */
    public List<Item> getBestSellingItems(int limit) throws Exception {
        String completedOrderStatus = "배송완료";
        return itemRepository.selectBestSellingItemsFromOrders(completedOrderStatus, limit);
    }

    /**
     * 최신 등록일 기준 상위 상품 목록 조회 (상세 설명 제외)
     * 
     * @param limit 조회할 상품 개수
     * @return 최신 상품 목록
     */
    public List<Item> getNewestItems(int limit) throws Exception {
        SortType sortType = SortType.NEWEST;
        String orderBy = sortType.getSqlOrderBy();
        if (orderBy == null) {
            throw new IllegalArgumentException("NEWEST 정렬 기준(sqlOrderBy)이 SortType에 정의되지 않았습니다.");
        }
        return itemRepository.selectWithOrderAndLimit(orderBy, limit);
    }

    /**
     * 할인율 기준 상위 상품 목록 조회 (상세 설명 제외)
     * 
     * @param limit 조회할 상품 개수
     * @return 할인율 높은 순 상품 목록
     */
    public List<Item> getHighestDiscountItems(int limit) throws Exception {
        SortType sortType = SortType.HIGHEST_DISCOUNT;
        String orderBy = sortType.getSqlOrderBy();

        if (orderBy == null) {
            throw new IllegalArgumentException("HIGHEST_DISCOUNT 정렬 기준(sqlOrderBy)이 SortType에 정의되지 않았습니다.");
        }

        return itemRepository.selectWithOrderAndLimit(orderBy, limit);
    }
}
