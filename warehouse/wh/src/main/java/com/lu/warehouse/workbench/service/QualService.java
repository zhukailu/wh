package com.lu.warehouse.workbench.service;

import com.lu.warehouse.workbench.domain.PmsQual;

public interface QualService {
    int saveAll(PmsQual pmsQual);

    int deleteByTypeId(String typeId);

    PmsQual queryByTypeId(String typeId);

    int updateByTypeId(PmsQual pmsQual);

    int queryCountByTypeId(String typeId);

}
