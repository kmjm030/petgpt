package com.mc.cust;

import com.mc.app.dto.Customer;
import com.mc.app.service.CustomerService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
@Slf4j
class Select {

	@Autowired
	CustomerService custService;

	@Test
	void contextLoads() {
		List<Customer> custs = null;
		try {
			custs = custService.get();
			log.info("OK=============================:{}",custs);

		} catch (Exception e) {
			log.info("ERROR==========================:{}",e.getMessage());
		}
	}

}