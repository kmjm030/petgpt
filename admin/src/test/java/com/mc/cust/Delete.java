package com.mc.cust;

import com.mc.app.service.CustomerService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class Delete {


	@Autowired
	CustomerService custService;

	@Test
	void contextLoads() {
		try {
			custService.del("id05");
			log.info("OK=============================:");

		} catch (Exception e) {
			log.info("ERROR==========================:{}",e.getMessage());
		}
	}

}