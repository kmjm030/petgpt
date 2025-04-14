package com.mc.cust;

import com.mc.app.dto.Customer;
import com.mc.app.service.CustomerService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Slf4j
class Insert {

	@Autowired
    CustomerService custService;

	@Transactional
	@Test
	void contextLoads() {
		Customer cust = Customer.builder().custId("id05").custPwd("pwd01")
                .custName("김말숙").custEmail("ms@abc.com").custNick("닉네임1").custPhone("010-1234-5678").build();

		log.info(cust.toString());
		try {
			custService.add(cust);
			log.info("OK=============================:");
		} catch (Exception e) {
			log.info("ERROR==========================:{}",e.getMessage());
		}
	}

}