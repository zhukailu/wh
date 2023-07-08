package com.lu.warehouse.workbench.service.impl;

import com.lu.warehouse.workbench.domain.PmsImage;
import com.lu.warehouse.workbench.mapper.PmsImageMapper;
import com.lu.warehouse.workbench.service.ImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("imageService")
public class ImageServiceImpl implements ImageService {
    @Autowired
    private PmsImageMapper pmsImageMapper;

    @Override
    public int editAll(PmsImage pmsImage) {
        return pmsImageMapper.insertSelective(pmsImage);
    }

    @Override
    public String queryAddrByProId(Long productId) {
        return pmsImageMapper.selectImageAddrByImageProductIdInt(productId);
    }
}
