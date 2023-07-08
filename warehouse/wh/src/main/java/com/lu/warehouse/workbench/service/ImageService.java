package com.lu.warehouse.workbench.service;

import com.lu.warehouse.workbench.domain.PmsImage;

public interface ImageService {
    int editAll(PmsImage pmsImage);

    String queryAddrByProId(Long productId);
}
