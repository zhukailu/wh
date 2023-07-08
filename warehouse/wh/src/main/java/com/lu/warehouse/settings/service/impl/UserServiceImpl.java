package com.lu.warehouse.settings.service.impl;

import com.lu.warehouse.settings.domain.PmsUser;
import com.lu.warehouse.settings.mapper.PmsUserMapper;
import com.lu.warehouse.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;
@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    private PmsUserMapper pmsUserMapper;
    @Override
    public PmsUser queryUserByUserIdAndPwd(Map<String, Object> map) {


        PmsUser pmsUser=pmsUserMapper.selectUserByUserIdAndPwd(map);


        return pmsUser;
    }

    @Override
    public Long queryUserIdByUserName(String userName) {
        return pmsUserMapper.selectUserIdByName(userName);
    }

    @Override
    public PmsUser queryByUserId(Long userId) {
        return pmsUserMapper.selectByPrimaryKey(userId);
    }

//    @Override
//    public PmsUser queryUserByPrimaryKey(Long userId) {
//        return pmsUserMapper.selectByPrimaryKey(userId);
//    }
}
