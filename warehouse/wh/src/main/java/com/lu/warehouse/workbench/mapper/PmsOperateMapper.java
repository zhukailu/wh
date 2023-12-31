package com.lu.warehouse.workbench.mapper;

import com.lu.warehouse.workbench.domain.PmsOperate;

import java.util.List;
import java.util.Map;

public interface PmsOperateMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table pms_operate
     *
     * @mbggenerated Tue Oct 04 16:11:36 CST 2022
     */
    int deleteByPrimaryKey(Long operateId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table pms_operate
     *
     * @mbggenerated Tue Oct 04 16:11:36 CST 2022
     */
    int insert(PmsOperate record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table pms_operate
     *
     * @mbggenerated Tue Oct 04 16:11:36 CST 2022
     */
    int insertSelective(PmsOperate record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table pms_operate
     *
     * @mbggenerated Tue Oct 04 16:11:36 CST 2022
     */
    PmsOperate selectByPrimaryKey(Long operateId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table pms_operate
     *
     * @mbggenerated Tue Oct 04 16:11:36 CST 2022
     */
    int updateByPrimaryKeySelective(PmsOperate record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table pms_operate
     *
     * @mbggenerated Tue Oct 04 16:11:36 CST 2022
     */
    int updateByPrimaryKey(PmsOperate record);

    List<PmsOperate> selectAll(Map map);

    int selectCount(Map map);

}