package com.mc.board;

import com.mc.app.service.BoardService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class Delete {


	@Autowired
	BoardService boardService;

	@Test
	void contextLoads() {
		try {
			boardService.del(2);
			log.info("OK====================:");

		} catch (Exception e) {
			log.info("시스템 문제 발생==========="+e);
		}
	}

}