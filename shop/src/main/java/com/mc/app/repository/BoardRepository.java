package com.mc.app.repository;

import com.mc.app.dto.Board;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface BoardRepository extends MCRepository<Board, Integer> {
}
