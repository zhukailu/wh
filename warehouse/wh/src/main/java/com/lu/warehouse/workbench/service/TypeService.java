package com.lu.warehouse.workbench.service;

import com.lu.warehouse.workbench.domain.PmsType;

import java.util.List;
import java.util.Map;

public interface TypeService {
    List<PmsType> queryAll(Map map);

    int deleteByTypeName(String typeName);

    int addByName(String typeName);

    int updateDateByTypeId(PmsType pmsType);

    int queryCountByTypeId();

    String queryTypeIdByTypeName(String typeName);
}
