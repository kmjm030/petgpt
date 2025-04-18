package com.mc.app.repository;

import com.mc.app.dto.AdminNotice;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface AdminNoticeRepository {

    @Select("""
        SELECT * 
        FROM admin_notice 
        ORDER BY created_at DESC 
        LIMIT 5
    """)
    List<AdminNotice> selectRecent();

    @Select("""
        SELECT * 
        FROM admin_notice 
        WHERE id = #{id}
    """)
    AdminNotice selectOne(@Param("id") int id);

    @Insert("""
        INSERT INTO admin_notice (admin_id, title, content, created_at) 
        VALUES (#{adminId}, #{title}, #{content}, NOW())
    """)
    void insert(AdminNotice notice);

    @Delete("""
        DELETE FROM admin_notice 
        WHERE id = #{id}
    """)
    void delete(@Param("id") int id);

    @Update("""
        UPDATE admin_notice 
        SET title = #{title}, content = #{content} 
        WHERE id = #{id}
    """)
    void update(AdminNotice notice);

    @Select("""
        SELECT 
            n.id, n.title, n.content, n.created_at, 
            n.admin_id, a.admin_name AS adminName 
        FROM admin_notice n 
        JOIN admin a ON n.admin_id = a.admin_id 
        ORDER BY n.created_at DESC
    """)
    List<AdminNotice> selectWithAdminName();
}
