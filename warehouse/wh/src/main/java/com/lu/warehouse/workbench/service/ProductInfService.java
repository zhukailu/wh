package com.lu.warehouse.workbench.service;

import com.lu.warehouse.workbench.domain.PmsInf;

import java.util.List;
import java.util.Map;

public interface ProductInfService {
    List<PmsInf> queryProductInf(Map map);

    int queryCount(Map map);

    int addProductInf(PmsInf pmsInf);

    PmsInf queryInfByProId(Long productId);

    int updateInfByProId(PmsInf pmsInf);

    int deleteByProId(Long productId);

    String queryProNameById(Long productId);

    Long queryIdByProductName(String productName);

    int updateImageById(PmsInf pmsInf);

    String queryProductContourById(Long productId);

    int updateStockById(PmsInf pmsInf);

    List<PmsInf> queryAllByNull();

    List<PmsInf> queryAllById(Long productId);

    int updateDelById(Long productId);
}
