package com.mc.app.repository;

import com.mc.app.dto.CommunityBoard;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommunityBoardRepository {
    int insertBoard(CommunityBoard board);
    int updateBoard(CommunityBoard board);
    int deleteBoard(int boardKey);
    CommunityBoard selectBoardByKey(int boardKey);
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
    int countBoardsByCategory(@Param("category") String category);
    int countBoardsByKeyword(@Param("keyword") String keyword);
    int increaseViewCount(int boardKey);
    int increaseLikeCount(int boardKey);
    int decreaseLikeCount(int boardKey);
    int increaseCommentCount(int boardKey);
    int decreaseCommentCount(int boardKey);
    int updateCommentCount(int boardKey);
    int updateAllCommentCounts();
} 