package com.hazmat.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hazmat.entity.HazmatInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 危化品信息Mapper接口
 */
@Mapper
public interface HazmatInfoMapper extends BaseMapper<HazmatInfo> {
    
    @Select("<script>" +
            "SELECT h.*, c.name as category_name FROM hazmat_info h " +
            "LEFT JOIN hazmat_category c ON h.category_id = c.id " +
            "WHERE 1=1 " +
            "<if test='name != null and name != \"\"'> AND h.name LIKE CONCAT('%', #{name}, '%')</if>" +
            "<if test='categoryId != null'> AND h.category_id = #{categoryId}</if>" +
            "<if test='dangerType != null and dangerType != \"\"'> AND h.danger_type LIKE CONCAT('%', #{dangerType}, '%')</if>" +
            " ORDER BY h.create_time DESC" +
            "</script>")
    IPage<HazmatInfo> selectPageWithCategory(Page<HazmatInfo> page, 
                                              @Param("name") String name,
                                              @Param("categoryId") Long categoryId,
                                              @Param("dangerType") String dangerType);
}
