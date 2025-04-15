package com.mc.board;

import com.mc.app.dto.Customer;
import com.mc.app.service.CustomerService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Slf4j
class Update {

	@Autowired
	CustomerService custService;

	@Test
	void contextLoads() {
		// cust_pwd = #{custPwd},
		//                            cust_email = #{custEmail},
		//                            cust_phone = #{custPhone},
		//                            cust_point = #{custPoint},
		//                            cust_nick = #{custNick},
		//                            point_charge = #{pointCharge},
		//                            point_reason = #{pointReason}
		Customer cust = Customer.builder().custId("id01").custPwd("1234").custName("홍말숙")
				.custEmail("petgpt@naver.com").custPhone("010-1234-5678").custNick("닉네임1")
				.build();
		log.info(cust.toString());
		try {
			custService.mod(cust);
			log.info("OK");
		} catch (Exception e) {
			e.printStackTrace();
			log.info("시스템오류");
		}
	}

}