package com.mc.board;

import com.mc.app.dto.Board;
import com.mc.app.dto.Customer;
import com.mc.app.service.BoardService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
@Slf4j
class Select {


	@Autowired
//	CustomerService customerService;
	BoardService boardService;

	@Test
	void contextLoads() {
		List<Board> boards = null;
		List<Customer> customers = null;
		try {
			boards = boardService.get();
			log.info("OK==========================:{}",boards);
//			customers = customerService.get();
//			log.info("OK==========================:{}",customers);

		} catch (Exception e) {
			log.info("시스템 문제 발생==========="+e);
		}
	}

}