package com.mc.controller;

import com.mc.app.dto.OrderDetail;
import com.mc.app.service.OrderDetailService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
@Controller
@RequiredArgsConstructor
public class OrderDetailController {
    private final OrderDetailService orderDetailService;

    @GetMapping("/orderdetail")
    public String showOrderDetails(Model model) {
        List<OrderDetail> orderDetails = orderDetailService.getAllOrderDetails();
        model.addAttribute("orderDetails", orderDetails);
        return "orderdetail";
    }

    @GetMapping("/orderdetail/delete/{id}")
    public String deleteOrderDetail(@PathVariable("id") int id) {
        orderDetailService.deleteById(id);
        return "redirect:/orderdetail";
    }
    @GetMapping("/order_detail/{id}")
    public String showOrderDetail(@PathVariable("id") int id, Model model) {
        OrderDetail detail = orderDetailService.getOrderDetailById(id);
        model.addAttribute("orderDetail", detail);
        return "order_detail";
    }
}
