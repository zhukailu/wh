package com.lu.warehouse.workbench.web.controller;

import com.lu.warehouse.commons.domain.ReturnObject;
import com.lu.warehouse.commons.io.createTxt;
import com.lu.warehouse.commons.utils.DateUtils;
import com.lu.warehouse.settings.domain.PmsUser;
import com.lu.warehouse.workbench.domain.PmsImage;
import com.lu.warehouse.workbench.domain.PmsInf;
import com.lu.warehouse.workbench.domain.PmsQual;
import com.lu.warehouse.workbench.mapper.PmsInfMapper;
import com.lu.warehouse.workbench.service.ImageService;
import com.lu.warehouse.workbench.service.ProductInfService;
import com.lu.warehouse.workbench.service.QualService;
import com.lu.warehouse.workbench.service.TypeService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.util.*;

@Controller
public class InfController {
    @Autowired
    private ProductInfService productInfService;
    @Autowired
    private QualService qualService;
    @Autowired
    private TypeService typeService;
    @Autowired
    private ImageService imageService;

    public static String product_name;
    @RequestMapping("workbench/Inf/getProductInf.do")
    @ResponseBody
    public Object getProductInf(String name,String type,String color,String material,int pageNo,int pageSize){
        //修改为判断是否为被删除
        pageNo=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<>();
        map.put("pageNo",pageNo);
        map.put("pageSize",pageSize);
        map.put("name",name);
        map.put("type",type);
        map.put("color",color);
        map.put("material",material);
        map.put("del","0");
        List<PmsInf> list = productInfService.queryProductInf(map);
        int totalRows = productInfService.queryCount(map);
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("list",list);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    /**
     *                         proWeight:proWeight,
     *                         proPackage:proPackage,
     *                         proNorms:proNorms,
     *                         proBoxNum:proBoxNum,
     *                         proCargoNum:proCargoNum
     *
     */
    @RequestMapping("workbench/Inf/insertProductInf.do")
    @ResponseBody
    public Object insertProductInf(Long typeId, String productName,
                                   String proColor, double proCapacity,
                                   double proHeight, double proDiameterBody,
                                   double proDiameterOutside, double proDiameterInside,
                                    String proMaterial,
                                   Long proStock, String proRemarks,
                                   double proWeight,String proPackage,
                                   String proNorms,String proBoxNum,String proCargoNum,HttpSession session
                                   ) throws IOException{
        PmsInf pmsInf=new PmsInf();
        ReturnObject returnObject=new ReturnObject();
//        PmsQual pmsQual = qualService.queryByTypeId(typeId.toString());
        List<PmsInf> list=productInfService.queryAllByNull();
        for (PmsInf pmsinf: list
             ) {
            if (pmsinf.getProductName()!=null) {
                if (pmsinf.getProductName().equals(productName)) {
                    if ("2".equals(returnObject.getCode())){
                        returnObject.setMessage("产品名、货物编号均已存在，请修改后输入");
                    }else {
                        returnObject.setCode("2");
                        returnObject.setMessage("产品名已存在，请重新命名");
                    }
                }
            }
            if(pmsinf.getProductCargoNum()!=null) {
                if (pmsinf.getProductCargoNum().equals(proCargoNum)) {
                    if ("2".equals(returnObject.getCode())){
                        returnObject.setMessage("产品名、货物编号均已存在，请修改后输入");
                    }else {
                        returnObject.setCode("2");
                        returnObject.setMessage("货物编号已存在，请输入新的编号");
                    }
                }
            }

        }
        if (returnObject.getCode()!=null){
            return returnObject;
        }
        pmsInf.setProductTypeId(typeId);
        pmsInf.setProductName(productName);
        pmsInf.setProductColor(proColor);
        pmsInf.setProductCapacity(proCapacity);
        pmsInf.setProductHeight(proHeight);
        pmsInf.setProductDiameterBody(proDiameterBody);
        pmsInf.setProductDiameterOutside(proDiameterOutside);
        pmsInf.setProductDiameterInside(proDiameterInside);
        //pmsInf.setProductContour(proContour);
        pmsInf.setProductMaterial(proMaterial);
        pmsInf.setProductStock(proStock);
        pmsInf.setProductRemarks(proRemarks);
        pmsInf.setProductWeight(proWeight);
        pmsInf.setProductPackage(proPackage);
        pmsInf.setProductNorms(proNorms);
        pmsInf.setProductBoxNum(proBoxNum);
        pmsInf.setProductCargoNum(proCargoNum);
        int i = productInfService.addProductInf(pmsInf);


        if (i==0){
            returnObject.setCode("0");
            returnObject.setMessage("添加失败");
        }
        else {
            returnObject.setCode("1");
            returnObject.setMessage("添加成功");
            product_name=productName;
            //获取新增产品的产品名和ID
            String s=productInfService.queryIdByProductName(productName).toString();
            PmsUser pmsUser=(PmsUser) session.getAttribute("sessionUser");
            createTxt.write("id:"+pmsUser.getUserId().toString()+" :"+ DateUtils.formateDateTime(new Date())+"新增产品：产品名:"+productName+",产品ID："+s);

        }
        return returnObject;
    }
//获取商品信息，不需要修改
    @RequestMapping("workbench/Inf/getDataByProductId.do")
    @ResponseBody
    public Object getDataByProductId(Long productId){
        PmsInf pmsInf = productInfService.queryInfByProId(productId);
        return pmsInf;
    }
//更新信息，不需要改
    @RequestMapping("workbench/Inf/updateByproductId.do")
    @ResponseBody
    public Object updateByproductId(Long typeId,String productName,
                                    String proColor,double proCapacity,
                                    double proHeight,double proDiameterBody,
                                    double proDiameterOutside,double proDiameterInside,
                                    String proMaterial,
                                    Long proStock,String proRemarks,Long productId,
                                    double proWeight,String proPackage,
                                    String proNorms,String proBoxNum,String proCargoNum,HttpSession session
                                    ) throws IOException{
        PmsInf pmsInf=new PmsInf();
        List<PmsInf> list=productInfService.queryAllById(productId);
        PmsInf oldInf=productInfService.queryInfByProId(productId);
        PmsUser pmsUser=(PmsUser) session.getAttribute("sessionUser");
        ReturnObject returnObject=new ReturnObject();
        for (PmsInf pmsinf: list
        ) {
            if (pmsinf.getProductName()!=null) {
                if (pmsinf.getProductName().equals(productName)) {
                    if ("2".equals(returnObject.getCode())){
                        returnObject.setMessage("产品名、货物编号均已存在，请修改后输入");
                    }else {
                        returnObject.setCode("2");
                        returnObject.setMessage("产品名已存在，请重新命名");
                    }
                }
            }
            if(pmsinf.getProductCargoNum()!=null) {
                if (pmsinf.getProductCargoNum().equals(proCargoNum)) {
                    if ("2".equals(returnObject.getCode())){
                        returnObject.setMessage("产品名、货物编号均已存在，请修改后输入");
                    }else {
                        returnObject.setCode("2");
                        returnObject.setMessage("货物编号已存在，请输入新的编号");
                    }
                }
            }

        }
        if (returnObject.getCode()!=null){
            return returnObject;
        }
        pmsInf.setProductTypeId(typeId);
        pmsInf.setProductName(productName);
        pmsInf.setProductColor(proColor);
        pmsInf.setProductCapacity(proCapacity);
        pmsInf.setProductHeight(proHeight);
        pmsInf.setProductDiameterBody(proDiameterBody);
        pmsInf.setProductDiameterOutside(proDiameterOutside);
        pmsInf.setProductDiameterInside(proDiameterInside);
        pmsInf.setProductMaterial(proMaterial);
        pmsInf.setProductStock(proStock);
        pmsInf.setProductRemarks(proRemarks);
        pmsInf.setProductId(productId);
        pmsInf.setProductWeight(proWeight);
        pmsInf.setProductPackage(proPackage);
        pmsInf.setProductNorms(proNorms);
        pmsInf.setProductBoxNum(proBoxNum);
        pmsInf.setProductCargoNum(proCargoNum);
        int i = productInfService.updateInfByProId(pmsInf);


        if (i==0){
            returnObject.setCode("0");
            returnObject.setMessage("修改失败");
        }
        else {
            returnObject.setCode("1");
            returnObject.setMessage("修改成功");
            product_name=productName;
            createTxt.write("id:"+pmsUser.getUserId().toString()+" :"+ DateUtils.formateDateTime(new Date())+" 更新产品：id："+oldInf.getProductId()+",产品名：："+productName+",更新成功，原信息为："+oldInf.toString());
        }
        return returnObject;
    }

    @RequestMapping("workbench/Inf/getImage.do")
    @ResponseBody
    public Object getImage(@RequestParam(value = "file") MultipartFile file,HttpSession session) throws IOException{
        //获取未更新图片的数据
        Long productId = productInfService.queryIdByProductName(product_name);
        PmsInf oldInfs=productInfService.queryInfByProId(productId);

        ReturnObject returnObject=new ReturnObject();
        String path = "";
        path = this.getClass().getResource("/").getPath();
        path=path.replaceFirst("/","");
        path=path.replaceFirst("/WEB-INF/classes/","/image/");
        //path="/usr/local/tomcat9/webapps/wh/image/";
        //  F:/product/warehouse/wh/target/wh/image

        if (file.isEmpty()) {
            returnObject.setCode("0");
            returnObject.setMessage("未上传图片，请使用修改功能重新添加图片");
            return returnObject;
        }
        String fileName = file.getOriginalFilename();  // 文件名
        //System.out.println(file.getOriginalFilename());
        String suffixName = fileName.substring(fileName.lastIndexOf("."));  // 后缀名
        //String filePath = "D:\\load_load\\"; // 上传后的路径
        String filePath =path;
        fileName = UUID.randomUUID() + suffixName; // 新文件名
        //src="image/IMG_7114.JPG"
        File dest = new File(filePath + fileName);
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            file.transferTo(dest);
        } catch (IOException e) {
            returnObject.setCode("0");
            returnObject.setMessage("图片添加失败，请使用修改功能重新添加图片");
            e.printStackTrace();
            return returnObject;
        }

        PmsInf pmsInf=new PmsInf();
        pmsInf.setProductId(productId);
        pmsInf.setProductContour("image/"+fileName);
        int i=productInfService.updateImageById(pmsInf);
        if (i!=0){
            returnObject.setCode("1");
            returnObject.setMessage("产品添加成功");

            PmsUser pmsUser=(PmsUser)session.getAttribute("sessionUser");
            if(oldInfs.getProductContour()==null){
                createTxt.write("id:"+pmsUser.getUserId()+" :"+DateUtils.formateDateTime(new Date())+" 为产品：id："+productId+", 产品名:"+product_name+" 添加了图片");
            }else{
                createTxt.write("id:"+pmsUser.getUserId()+" :"+DateUtils.formateDateTime(new Date())+" 为产品：id："+productId+", 产品名:"+product_name+" 更新了图片，原图片为："+fileName);
            }
            product_name=null;
        }else {
            returnObject.setCode("0");
            returnObject.setMessage("图片添加失败");
        }
        return returnObject;
    }
//删除，需要修改为逻辑删除
    @RequestMapping("workbench/Inf/deleteProductInf.do")
    @ResponseBody
    public Object deleteProductInf(Long productId,HttpSession session) throws IOException {
        String name=productInfService.queryProNameById(productId);
        int i = productInfService.updateDelById(productId);
        PmsUser pmsUser=(PmsUser)session.getAttribute("sessionUser");

        ReturnObject returnObject=new ReturnObject();
        if (i==0){
            returnObject.setCode("0");
            returnObject.setMessage("产品："+name+"删除失败");
            createTxt.write("id:"+pmsUser.getUserId()+" :"+DateUtils.formateDateTime(new Date())+" 删除产品：id："+productId+", 产品名:"+name+",删除失败");
        }else {
            returnObject.setCode("1");
            returnObject.setMessage("产品删除成功");
            createTxt.write("id:"+pmsUser.getUserId()+" :"+DateUtils.formateDateTime(new Date())+" 删除产品：id："+productId+", 产品名:"+name);
        }
        return returnObject;
    }

    @RequestMapping("workbench/Inf/getProductImage.do")
    @ResponseBody
    public Object getProductImage(Long productId){
        String addr=null;
        addr=productInfService.queryProductContourById(productId);
        if (addr==null){
            addr="image/false.jpg";
        }
        PmsImage pmsImage=new PmsImage();
        pmsImage.setImageProductId(productId);
        pmsImage.setImageAddr(addr);
        return pmsImage;
    }
}