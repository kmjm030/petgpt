package com.mc.board;

import com.mc.app.dto.Customer;
import com.mc.app.service.CustomerService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class Insert {

	@Autowired
    CustomerService custService;

	@Test
	void contextLoads() {
		Customer cust = Customer.builder().custId("id01").custPwd("pwd01")
                .custName("김말숙").custEmail("ms@abc.com").custNick("닉네임1").custPhone("010-1234-5678").build();

		log.info(cust.toString());
		try {
			custService.add(cust);
			log.info("OK");
		} catch (Exception e) {
			log.info("Id 중복");
		}
	}

}