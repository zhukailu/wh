package com.lu.warehouse.workbench.service.impl;

import com.lu.warehouse.workbench.domain.PmsInf;
import com.lu.warehouse.workbench.mapper.PmsInfMapper;
import com.lu.warehouse.workbench.service.ProductInfService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("productInfService")
public class ProductInfServiceImpl implements ProductInfService {
    @Autowired
    private PmsInfMapper pmsInfMapper;
    @Override
    public List<PmsInf> queryProductInf(Map map) {
        return pmsInfMapper.selectAll(map);
    }

    @Override
    public int queryCount(Map map) {
        return pmsInfMapper.selectCount(map);
    }

    @Override
    public int addProductInf(PmsInf pmsInf) {
        return pmsInfMapper.insertSelective(pmsInf);
    }

    @Override
    public PmsInf queryInfByProId(Long productId) {
        return pmsInfMapper.selectByPrimaryKey(productId);
    }

    @Override
    public int updateInfByProId(PmsInf pmsInf) {
        return pmsInfMapper.updateByPrimaryKeySelective(pmsInf);
    }

    @Override
    public int deleteByProId(Long productId) {
        return pmsInfMapper.deleteByPrimaryKey(productId);
    }

    @Override
    public String queryProNameById(Long productId) {
        return pmsInfMapper.selectProductNameById(productId);
    }

    @Override
    public Long queryIdByProductName(String productName) {
        return pmsInfMapper.selectIdByProductName(productName);
    }

    @Override
    public int updateImageById(PmsInf pmsInf) {
        return pmsInfMapper.insertProductContourById(pmsInf);
    }

    @Override
    public String queryProductContourById(Long productId) {
        return pmsInfMapper.selectProductContourByProductId(productId);
    }

    @Override
    public int updateStockById(PmsInf pmsInf) {
        return pmsInfMapper.updateProductStockByProductId(pmsInf);
    }

    @Override
    public List<PmsInf> queryAllByNull() {
        return pmsInfMapper.selectAllByNull();
    }

    @Override
    public List<PmsInf> queryAllById(Long productId) {
        return pmsInfMapper.selectAllById(productId);
    }

    @Override
    public int updateDelById(Long productId) {
        return pmsInfMapper.updateProductDelById(productId);
    }
}
