package com.lu.warehouse.workbench.service;

import com.lu.warehouse.workbench.domain.PmsOperate;

import java.util.List;
import java.util.Map;

public interface OperateService {
    int addAll(PmsOperate pmsOperate);

    List<PmsOperate> queryAll(Map map);

    int queryCount(Map map);

    PmsOperate queryInfById(Long operateId);
}
