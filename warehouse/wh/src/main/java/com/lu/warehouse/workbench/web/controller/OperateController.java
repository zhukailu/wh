package com.lu.warehouse.workbench.web.controller;

import com.lu.warehouse.commons.domain.ReturnObject;
import com.lu.warehouse.commons.utils.DateUtils;
import com.lu.warehouse.settings.domain.PmsUser;
import com.lu.warehouse.settings.service.UserService;
import com.lu.warehouse.workbench.domain.PmsInf;
import com.lu.warehouse.workbench.domain.PmsOperate;
import com.lu.warehouse.workbench.service.OperateService;
import com.lu.warehouse.workbench.service.ProductInfService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class OperateController {
    @Autowired
    private OperateService operateService;
    @Autowired
    private ProductInfService productInfService;
    @Autowired
    private UserService userService;
    /*
        "operateProductName": "加的你",
            "operateType": "入库",
            "operateNum": "1",
            "operateUserName": "朱开露.",
            "operateRemarks": "1",
            "userId": "18237625123",
            "productId": "1"
    */
    @RequestMapping("workbench/operate/insertOperateInf.do")
    @ResponseBody
    @Transactional
    public Object insertOperateInf(String operateProductName,String operateType,Long operateNum,
                                   Long userId,Long productId,String operateRemarks){
        PmsOperate pmsOperate=new PmsOperate();
        pmsOperate.setOperateUserId(userId);
        pmsOperate.setOperateNum(operateNum);
        pmsOperate.setOperateProductId(productId);
        pmsOperate.setOperateRemarks(operateRemarks);
        pmsOperate.setOperateProductName(operateProductName);
        pmsOperate.setOperateType(operateType);
        pmsOperate.setOperateTime(DateUtils.formateHourTime(new Date()));
        int i = operateService.addAll(pmsOperate);
        ReturnObject returnObject=new ReturnObject();
        if (i!=0){
            //修改inf表中的库存信息
            PmsInf pmsInf=productInfService.queryInfByProId(productId);
            if ("入库".equals(operateType)){
                pmsInf.setProductStock(pmsInf.getProductStock()+operateNum);
            }else {
                pmsInf.setProductStock(pmsInf.getProductStock()-operateNum);
            }
            int j = productInfService.updateStockById(pmsInf);
            if (j!=0) {
                returnObject.setCode("1");
                returnObject.setMessage("产品：" + operateProductName + operateType + "成功," + "当前库存：" + pmsInf.getProductStock().toString());
            }else{
                returnObject.setCode("0");
                returnObject.setMessage("库存修改失败");
            }
        }else {
            returnObject.setCode("0");
            returnObject.setMessage("库存修改信息记录失败");
        }

        return returnObject;
    }
    /*
    * type:type,
                    user:user,
                    date:date,
                    product:product,
                    pageNo:pageNo,
                    pageSize:pageSize
    * */
    @RequestMapping("workbench/operate/queryOperateInf.do")
    @ResponseBody
    public Object queryOperateInf(String type,String user,String date,String product,int pageNo,int pageSize){

        Long userId=userService.queryUserIdByUserName(user);
        pageNo=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        map.put("userId",userId);
        map.put("type",type);
        map.put("date",date);
        map.put("product",product);
        List<PmsOperate> list = operateService.queryAll(map);
        int totalRows=operateService.queryCount(map);
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("list",list);
        retMap.put("totalRows",totalRows);
        return retMap;
    }
    @RequestMapping("workbench/operate/queryOperateInfById.do")
    @ResponseBody
    public Object queryOperateInfById(Long operateId){
        Map<String,Object> map=new HashMap<>();
        PmsOperate pmsOperate = operateService.queryInfById(operateId);
        map.put("operate",pmsOperate);
        PmsUser pmsUser = userService.queryByUserId(pmsOperate.getOperateUserId());
        map.put("user",pmsUser);
        return map;
    }
}
