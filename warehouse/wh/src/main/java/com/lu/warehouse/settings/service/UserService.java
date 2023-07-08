package com.lu.warehouse.settings.service;

import com.lu.warehouse.settings.domain.PmsUser;
import org.springframework.stereotype.Service;

import java.util.Map;

//@Service
public interface UserService {
    PmsUser queryUserByUserIdAndPwd(Map<String,Object> map);

    Long queryUserIdByUserName(String userName);

//    PmsUser queryUserByPrimaryKey(Long userId);

    PmsUser queryByUserId(Long userId);
}
