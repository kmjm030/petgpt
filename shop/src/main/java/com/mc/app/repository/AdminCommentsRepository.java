package com.mc.app.repository;

import com.mc.app.dto.AdminComments;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface AdminCommentsRepository extends MCRepository<AdminComments, Integer> {
    void insert(AdminComments comment);
    void update(AdminComments comment);
    void delete(int adcommentsKey);
    AdminComments selectOne(int boardKey);
    List<AdminComments> selectCommentsByBorderKey(int borderKey) throws Exception;;
    List<AdminComments> select();
    List<AdminComments> selectAllbyItem(int itemKey);
    void updateBoardReStatus(@Param("boardKey") int boardKey, @Param("status") String status);
}