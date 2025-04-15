package com.mc.app.repository;

import com.mc.app.dto.CommunityBoard;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommunityBoardRepository {
    // CRUD
    int insertBoard(CommunityBoard board);
    int updateBoard(CommunityBoard board);
    int deleteBoard(int boardKey);
    CommunityBoard selectBoardByKey(int boardKey);
    
    // 목록/검색
    List<CommunityBoard> selectBoardList(
            @Param("category") String category,
            @Param("offset") int offset,
            @Param("limit") int limit,
            @Param("sort") String sort
    );
    
    List<CommunityBoard> searchBoards(
            @Param("keyword") String keyword,
            @Param("offset") int offset,
            @Param("limit") int limit,
            @Param("sort") String sort
    );
    
    // 개수 조회 
    int countBoardsByCategory(@Param("category") String category);
    int countBoardsByKeyword(@Param("keyword") String keyword);
    
    // 카운트 
    int increaseViewCount(int boardKey);
    int increaseLikeCount(int boardKey);
    int decreaseLikeCount(int boardKey);
    int increaseCommentCount(int boardKey);
    int decreaseCommentCount(int boardKey);
} 