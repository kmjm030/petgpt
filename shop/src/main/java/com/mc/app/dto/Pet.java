package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Pet {
    private int petKey;
    private String custId;
    private String petName;
    private String petType;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date petBirthdate;
    private String petGender;
    private String petBreed;
    private String petImg;
    private Date petRdate;
}
