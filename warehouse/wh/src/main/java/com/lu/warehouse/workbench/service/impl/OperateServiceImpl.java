package com.lu.warehouse.workbench.service.impl;

import com.lu.warehouse.workbench.domain.PmsOperate;
import com.lu.warehouse.workbench.mapper.PmsOperateMapper;
import com.lu.warehouse.workbench.service.OperateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("operateService")
public class OperateServiceImpl implements OperateService {
    @Autowired
    private PmsOperateMapper pmsOperateMapper;


    @Override
    public int addAll(PmsOperate pmsOperate) {
        return pmsOperateMapper.insertSelective(pmsOperate);
    }

    @Override
    public List<PmsOperate> queryAll(Map map) {
        return pmsOperateMapper.selectAll(map);
    }

    @Override
    public int queryCount(Map map) {
        return pmsOperateMapper.selectCount(map);
    }

    @Override
    public PmsOperate queryInfById(Long operateId) {
        return pmsOperateMapper.selectByPrimaryKey(operateId);
    }
}
