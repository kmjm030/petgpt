package com.mc.app.repository;

//import com.github.pagehelper.Page;
import com.mc.app.dto.AdminComments;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface AdminCommentsRepository extends MCRepository<AdminComments, Integer> {
//    Page<Customer> getpage() throws Exception;

//    List<AdminComments> selectAllbyItem(int itemKey) throws Exception;
//    AdminComments selectCommentByBorderKey(int borderKey) throws Exception;
void insert(AdminComments comment);
    void update(AdminComments comment);
    void delete(int adcommentsKey);
    AdminComments selectOne(int boardKey);
    List<AdminComments> select();
    List<AdminComments> selectAllbyItem(int itemKey);
}