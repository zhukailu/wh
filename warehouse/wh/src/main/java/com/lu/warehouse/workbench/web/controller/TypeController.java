package com.lu.warehouse.workbench.web.controller;

import com.lu.warehouse.commons.domain.ReturnObject;
import com.lu.warehouse.workbench.domain.PmsQual;
import com.lu.warehouse.workbench.domain.PmsType;
import com.lu.warehouse.workbench.service.QualService;
import com.lu.warehouse.workbench.service.TypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TypeController {
    @Autowired
    private TypeService typeService;
    @Autowired
    private QualService qualService;
    /**
     * 查询所有的产品类型
     * @return
     */
    @RequestMapping("workbench/getTypeName.do")
    @ResponseBody
    public Object getTypeName(int pageNo,int pageSize){
        int totalRows = typeService.queryCountByTypeId();
        pageNo=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        List<PmsType> list = typeService.queryAll(map);
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("list",list);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("workbench/test/deleteTypeInf.do")
    @ResponseBody
    public Object deleteTypeInf(String typeName){
        int i=0;
        int j;
        String typeId = typeService.queryTypeIdByTypeName(typeName);
        i = typeService.deleteByTypeName(typeName);
        j=qualService.queryCountByTypeId(typeId);
        ReturnObject returnObject=new ReturnObject();
        if (j>0){
            int i1 = qualService.deleteByTypeId(typeId);
            if (i*i1==0){
                returnObject.setCode("0");
                returnObject.setMessage("删除失败");
            }
            else {
                returnObject.setCode("1");
                returnObject.setMessage("删除成功");
            }
            return returnObject;
        }else{
            if (i==0){
                returnObject.setCode("0");
                returnObject.setMessage("删除失败");
            }
            else {
                returnObject.setCode("1");
                returnObject.setMessage("删除成功");
            }
            return returnObject;
        }
    }
    @RequestMapping("workbench/test/insertTypeInf.do")
    @ResponseBody
    public Object insertByTypeInf(String typeName,boolean proColor,boolean proCapacity,
                                  boolean proHeight,boolean proDiameterBody,
                                  boolean proDiameterOutside, boolean proDiameterInside,
                                  boolean proContour,boolean proMaterial,
                                  boolean proStock,boolean proRemarks){
        PmsQual pmsQual=new PmsQual();
        pmsQual.setProColor(proColor==true?"1":"0");
        pmsQual.setProCapacity(proCapacity==true?"1":"0");
        pmsQual.setProHeight(proHeight==true?"1":"0");
        pmsQual.setProDiameterBody(proDiameterBody==true?"1":"0");
        pmsQual.setProDiameterOutside(proDiameterOutside==true?"1":"0");
        pmsQual.setProDiameterInside(proDiameterInside==true?"1":"0");
        pmsQual.setProContour(proContour==true?"1":"0");
        pmsQual.setProMaterial(proMaterial==true?"1":"0");
        pmsQual.setProStock(proStock==true?"1":"0");
        pmsQual.setProRemarks(proRemarks==true?"1":"0");
        int i=0;
        i=typeService.addByName(typeName);
        String typeId = typeService.queryTypeIdByTypeName(typeName);
        pmsQual.setProType(typeId);
        int j = qualService.saveAll(pmsQual);
        ReturnObject returnObject=new ReturnObject();

        if (i*j==0){
            returnObject.setCode("0");
            returnObject.setMessage("添加失败");
        }
        else {
            returnObject.setCode("1");
            returnObject.setMessage("添加成功");
        }
        return returnObject;
    }

    @RequestMapping("workbench/test/selectDataByTypeId.do")
    @ResponseBody
    public Object selectDataByTypeId(String typeName){
        //int i=0;
        //获取typeId
        String typeId = typeService.queryTypeIdByTypeName(typeName);
        PmsQual pmsQual = qualService.queryByTypeId(typeId);
        return pmsQual;
    }

    @RequestMapping("workbench/test/updateByTypeId.do")
    @ResponseBody
    public Object updateByTypeId(String typeName,boolean proColor,boolean proCapacity,
                                 boolean proHeight,boolean proDiameterBody,
                                 boolean proDiameterOutside, boolean proDiameterInside,
                                 boolean proContour,boolean proMaterial,
                                 boolean proStock,boolean proRemarks){
        PmsQual pmsQual=new PmsQual();
        pmsQual.setProColor(proColor==true?"1":"0");
        pmsQual.setProCapacity(proCapacity==true?"1":"0");
        pmsQual.setProHeight(proHeight==true?"1":"0");
        pmsQual.setProDiameterBody(proDiameterBody==true?"1":"0");
        pmsQual.setProDiameterOutside(proDiameterOutside==true?"1":"0");
        pmsQual.setProDiameterInside(proDiameterInside==true?"1":"0");
        pmsQual.setProContour(proContour==true?"1":"0");
        pmsQual.setProMaterial(proMaterial==true?"1":"0");
        pmsQual.setProStock(proStock==true?"1":"0");
        pmsQual.setProRemarks(proRemarks==true?"1":"0");
        int i=0;
        String typeId = typeService.queryTypeIdByTypeName(typeName);
        pmsQual.setProType(typeId);
        i= qualService.updateByTypeId(pmsQual);
        ReturnObject returnObject=new ReturnObject();
        if (i==0){
            returnObject.setCode("0");
            returnObject.setMessage("更新失败");
        }else{
            returnObject.setCode("1");
            returnObject.setMessage("更新成功");
        }
        return returnObject;
    }
}
