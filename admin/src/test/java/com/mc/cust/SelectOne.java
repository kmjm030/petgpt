package com.mc.cust;

import com.mc.app.dto.Customer;
import com.mc.app.service.CustomerService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class SelectOne {

	@Autowired
	CustomerService custService;

	@Test
	void contextLoads() {
		Customer cust = null;
		try {
			cust = custService.get("id01");
			log.info("OK=============================:{}",cust.toString());
		} catch (Exception e) {
			log.info("ERROR==========================:{}",e.getMessage());
		}
	}

}
