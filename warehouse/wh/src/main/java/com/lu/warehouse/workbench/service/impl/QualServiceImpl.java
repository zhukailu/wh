package com.lu.warehouse.workbench.service.impl;

import com.lu.warehouse.workbench.domain.PmsQual;
import com.lu.warehouse.workbench.mapper.PmsQualMapper;
import com.lu.warehouse.workbench.service.QualService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("qualService")
public class QualServiceImpl implements QualService {
    @Autowired
    private PmsQualMapper pmsQualMapper;
    @Override
    public int saveAll(PmsQual pmsQual) {
        return pmsQualMapper.insertAll(pmsQual);
    }

    @Override
    public int deleteByTypeId(String typeId) {
        return pmsQualMapper.deleteByPrimaryKey(typeId);
    }

    @Override
    public PmsQual queryByTypeId(String typeId) {
        return pmsQualMapper.selectByPrimaryKey(typeId);
    }

    @Override
    public int updateByTypeId(PmsQual pmsQual) {
        return pmsQualMapper.updateByPrimaryKey(pmsQual);
    }

    @Override
    public int queryCountByTypeId(String typeId) {
        return pmsQualMapper.selectCountByTypeId(typeId);
    }
}
