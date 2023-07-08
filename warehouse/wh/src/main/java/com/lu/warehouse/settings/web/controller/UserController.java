package com.lu.warehouse.settings.web.controller;

import com.lu.warehouse.commons.domain.ReturnObject;
import com.lu.warehouse.commons.utils.DateUtils;
import com.lu.warehouse.settings.domain.PmsUser;
import com.lu.warehouse.settings.service.UserService;
import com.lu.warehouse.settings.service.impl.UserServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import com.lu.warehouse.commons.io.createTxt;
@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }



//http://localhost:8080/wh/settings/qx/user/login.do
    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(Long userId, String userPwd, String isRemPwd, HttpSession session, HttpServletResponse response)throws IOException {
        Map<String,Object> map=new HashMap<>();
        map.put("userId",userId);
        map.put("userPwd",userPwd);
        ReturnObject returnObject=new ReturnObject();
        PmsUser pmsUser = userService.queryUserByUserIdAndPwd(map);
        if (pmsUser==null){
            returnObject.setCode("0");
            returnObject.setMessage("账号或密码错误");
        }else {
            returnObject.setCode("1");
            returnObject.setMessage("登录成功");
            session.setAttribute("sessionUser",pmsUser);
            createTxt.write("id:"+userId.toString()+" :"+DateUtils.formateDateTime(new Date())+"登录");
            if ("true".equals(isRemPwd)){
                Cookie c1 = new Cookie("loginAct", userId.toString());
                c1.setMaxAge(60*60*24*10);
                response.addCookie(c1);
                Cookie c2 = new Cookie("loginPwd", userPwd);
                c2.setMaxAge(60*60*24*10);
                response.addCookie(c2);
                Cookie c3 = new Cookie("Perm",pmsUser.getUserPerm().toString());
                c3.setMaxAge(60*60*24*10);
                response.addCookie(c3);
            }else {
                Cookie c1 = new Cookie("loginAct", "1");
                c1.setMaxAge(0);
                response.addCookie(c1);
                Cookie c2 = new Cookie("loginPwd", "1");
                c2.setMaxAge(0);
                Cookie c3 = new Cookie("Perm", "1");
                c3.setMaxAge(0);

            }
        }

        return returnObject;
    }
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpSession session,HttpServletResponse response) throws IOException{
        PmsUser pmsUser =(PmsUser)session.getAttribute("sessionUser");
        createTxt.write("id:"+pmsUser.getUserId()+" :"+DateUtils.formateDateTime(new Date())+"退出登录");
        Cookie c1 = new Cookie("loginAct", "1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "1");
        c2.setMaxAge(0);
        response.addCookie(c2);
        session.invalidate();//销毁session
        return "redirect:/";
    }
}
