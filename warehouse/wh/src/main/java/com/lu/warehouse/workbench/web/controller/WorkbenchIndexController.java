package com.lu.warehouse.workbench.web.controller;

import com.lu.warehouse.workbench.service.TypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class WorkbenchIndexController {
    @Autowired
    private TypeService typeService;

    @RequestMapping("workbench/index.do")
    public String index(){
        return "workbench/index";
    }

    @RequestMapping("workbench/activity/indexActivity.do")
    public String indexActivity(){
        return "workbench/activity/index";
    }

    @RequestMapping("workbench/test/testIndex.do")
    public String testIndex(){
        return "workbench/test/testIndex";
    }

    @RequestMapping("workbench/Inf/InfIndex.do")
    public String InfIndex(HttpServletRequest request){
        int count = typeService.queryCountByTypeId();
        Map<String,Integer> map=new HashMap<>();
        map.put("pageNo",0);
        map.put("pageSize",count);
        List list=typeService.queryAll(map);
        request.setAttribute("typeList",list);
        return "workbench/Inf/InfIndex";
    }

    @RequestMapping("workbench/operate/OperateIndex.do")
    public String OperateIndex(HttpServletRequest request){
        int count = typeService.queryCountByTypeId();
        Map<String,Integer> map=new HashMap<>();
        map.put("pageNo",0);
        map.put("pageSize",count);
        List list=typeService.queryAll(map);
        request.setAttribute("typeList",list);
        return "workbench/operate/OperateIndex";
    }

    @RequestMapping("workbench/operate/OperateInfList.do")
    public String OperateInfList(){
        return "workbench/operate/OperateInfList";
    }
}
