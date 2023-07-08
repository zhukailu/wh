package com.lu.warehouse.workbench.service.impl;

import com.lu.warehouse.workbench.domain.PmsType;
import com.lu.warehouse.workbench.mapper.PmsTypeMapper;
import com.lu.warehouse.workbench.service.TypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("typeService")
public class TypeServiceImpl implements TypeService {
    @Autowired
    PmsTypeMapper pmsTypeMapper;
    @Override
    public List<PmsType> queryAll(Map map) {
        return pmsTypeMapper.selectAll(map);
    }

    @Override
    public int deleteByTypeName(String typeName) {
        return pmsTypeMapper.deleteByTypeName(typeName);
    }

    @Override
    public int addByName(String typeName) {
        return pmsTypeMapper.insertByTypeName(typeName);
    }

    @Override
    public int updateDateByTypeId(PmsType pmsType) {
        return pmsTypeMapper.updateByPrimaryKey(pmsType);
    }

    @Override
    public int queryCountByTypeId() {
        return pmsTypeMapper.selectTypeIdCount();
    }

    @Override
    public String queryTypeIdByTypeName(String typeName) {
        return pmsTypeMapper.selectTypeId(typeName);
    }
}
