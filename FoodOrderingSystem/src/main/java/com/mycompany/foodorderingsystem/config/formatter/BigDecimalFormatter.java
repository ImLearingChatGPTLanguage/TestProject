package com.mycompany.foodorderingsystem.config.formatter;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.Locale;
import org.springframework.format.Formatter;

public class BigDecimalFormatter implements Formatter<BigDecimal> {

    // Chuyển đổi một chuỗi String (từ form) thành BigDecimal
    @Override
    public BigDecimal parse(String text, Locale locale) throws ParseException {
        if (text == null || text.trim().isEmpty()) {
            return null;
        }
        // Cho phép người dùng nhập số có dấu phẩy hoặc không
        return new BigDecimal(text.replace(",", ""));
    }

    // Định dạng số BigDecimal thành chuỗi String để hiển thị trên view
    @Override
    public String print(BigDecimal object, Locale locale) {
        if (object == null) {
            return "";
        }
        // Định dạng số nguyên, không có phần thập phân
        DecimalFormat df = new DecimalFormat("#");
        df.setMaximumFractionDigits(0);
        return df.format(object);
    }
}
