/**
 * 监测预警模块 - API 接口定义
 * 
 * 统一使用 request 工具发送请求，所有接口均返回 Promise
 */
import request from './request'

// ==================== 认证模块 API ====================

export const authApi = {
  /** 用户登录 */
  login(data) {
    return request({
      url: '/auth/login',
      method: 'post',
      data
    })
  },
  
  /** 用户注册 */
  register(data) {
    return request({
      url: '/auth/register',
      method: 'post',
      data
    })
  },
  
  /** 修改密码 */
  changePassword(data) {
    return request({
      url: '/auth/change-password',
      method: 'post',
      data
    })
  },
  
  /** 获取用户信息 */
  getUserInfo() {
    return request({
      url: '/auth/user-info',
      method: 'get'
    })
  }
}

// ==================== 用户管理 API ====================

export const userApi = {
  /** 获取用户列表 */
  getUserList(params) {
    return request({
      url: '/user/list',
      method: 'get',
      params
    })
  },
  
  /** 获取用户详情 */
  getUserById(id) {
    return request({
      url: `/user/${id}`,
      method: 'get'
    })
  },
  
  /** 创建用户 */
  createUser(data) {
    return request({
      url: '/user',
      method: 'post',
      data
    })
  },
  
  /** 更新用户 */
  updateUser(data) {
    return request({
      url: '/user',
      method: 'put',
      data
    })
  },
  
  /** 删除用户 */
  deleteUser(id) {
    return request({
      url: `/user/${id}`,
      method: 'delete'
    })
  },

  /** 修改员工状态 */
  updateUserStatus(id, status) {
    return request({
      url: `/user/${id}/status/${status}`,
      method: 'put'
    })
  },

  /** 重置员工密码 */
  resetUserPassword(id, newPassword) {
    return request({
      url: `/user/${id}/reset-password`,
      method: 'put',
      params: { newPassword }
    })
  },

  /** 获取安全管理员列表 */
  getSafetyAdminList(params) {
    return request({
      url: '/user/safety-admin/list',
      method: 'get',
      params
    })
  },

  /** 获取安全管理员详情 */
  getSafetyAdminById(id) {
    return request({
      url: `/user/safety-admin/${id}`,
      method: 'get'
    })
  },

  /** 添加安全管理员 */
  addSafetyAdmin(data) {
    return request({
      url: '/user/safety-admin',
      method: 'post',
      data
    })
  },

  /** 更新安全管理员 */
  updateSafetyAdmin(data) {
    return request({
      url: '/user/safety-admin',
      method: 'put',
      data
    })
  },

  /** 删除安全管理员 */
  deleteSafetyAdmin(id) {
    return request({
      url: `/user/safety-admin/${id}`,
      method: 'delete'
    })
  },

  /** 修改安全管理员状态 */
  updateSafetyAdminStatus(id, status) {
    return request({
      url: `/user/safety-admin/${id}/status/${status}`,
      method: 'put'
    })
  },

  /** 重置安全管理员密码 */
  resetSafetyAdminPassword(id, newPassword) {
    return request({
      url: `/user/safety-admin/${id}/reset-password`,
      method: 'put',
      params: { newPassword }
    })
  },

  /** 获取系统管理员详情 */
  getAdminById(id) {
    return request({
      url: `/user/admin/${id}`,
      method: 'get'
    })
  },

  /** 更新系统管理员 */
  updateAdmin(data) {
    return request({
      url: '/user/admin',
      method: 'put',
      data
    })
  }
}

// ==================== 仪表盘 API ====================

export const dashboardApi = {
  /** 获取仪表盘统计数据 */
  getStats() {
    return request({
      url: '/dashboard/stats',
      method: 'get'
    })
  },
  
  /** 获取最新公告 */
  getLatestAnnouncements() {
    return request({
      url: '/dashboard/announcements',
      method: 'get'
    })
  },
  
  /** 获取热门安全知识 */
  getHotKnowledge() {
    return request({
      url: '/dashboard/hot-knowledge',
      method: 'get'
    })
  },
  
  /** 获取待处理隐患 */
  getPendingHazards() {
    return request({
      url: '/dashboard/pending-hazards',
      method: 'get'
    })
  },
  
  /** 获取待处理检查计划 */
  getPendingPlans() {
    return request({
      url: '/dashboard/pending-plans',
      method: 'get'
    })
  },
  
  /** 获取危化品分类统计 */
  getHazmatByCategory() {
    return request({
      url: '/dashboard/hazmat-by-category',
      method: 'get'
    })
  }
}

// ==================== 监测预警模块 API ====================

export const monitoringApi = {
  // ========== 实时监测数据 ==========
  
  /** 获取实时监测数据列表（分页） */
  getMonitoringData(params) {
    return request({
      url: '/monitoring/realtime/list',
      method: 'get',
      params
    })
  },
  
  /** 获取最新监测数据（概览页用） */
  getLatestMonitoringData() {
    return request({
      url: '/monitoring/realtime/latest',
      method: 'get'
    })
  },
  
  /** 获取当前监测数据（实时） */
  getCurrentMonitoringData() {
    return request({
      url: '/monitoring/realtime/current',
      method: 'get'
    })
  },
  
  /** 根据ID获取监测数据详情 */
  getMonitoringDataById(id) {
    return request({
      url: `/monitoring/realtime/${id}`,
      method: 'get'
    })
  },
  
  /** 添加监测数据 */
  addMonitoringData(data) {
    return request({
      url: '/monitoring/realtime',
      method: 'post',
      data
    })
  },
  
  /** 更新监测数据 */
  updateMonitoringData(data) {
    return request({
      url: '/monitoring/realtime',
      method: 'put',
      data
    })
  },
  
  /** 删除监测数据 */
  deleteMonitoringData(id) {
    return request({
      url: `/monitoring/realtime/${id}`,
      method: 'delete'
    })
  },
  
  /** 获取监测数据趋势 */
  getMonitoringTrend(hazmatId, paramId, timeRange) {
    return request({
      url: '/monitoring/realtime/trend',
      method: 'get',
      params: { hazmatId, paramId, timeRange }
    })
  },
  
  // ========== 预警记录 ==========
  
  /** 获取所有预警记录 */
  getAllWarningRecords() {
    return request({
      url: '/warning/record/all',
      method: 'get'
    })
  },
  
  /** 获取预警记录列表（分页） */
  getWarningRecords(params) {
    return request({
      url: '/warning/record/list',
      method: 'get',
      params
    })
  },
  
  /** 获取未处理的预警记录 */
  getUnhandledWarningRecords() {
    return request({
      url: '/warning/record/unhandled',
      method: 'get'
    })
  },
  
  /** 根据ID获取预警记录详情 */
  getWarningRecordById(id) {
    return request({
      url: `/warning/record/${id}`,
      method: 'get'
    })
  },
  
  /** 获取预警详情(含趋势数据) */
  getWarningDetail(id) {
    return request({
      url: `/warning/record/detail/${id}`,
      method: 'get'
    })
  },
  
  /** 添加预警记录 */
  addWarningRecord(data) {
    return request({
      url: '/warning/record',
      method: 'post',
      data
    })
  },
  
  /** 处理预警记录 */
  handleWarningRecord(id, data) {
    return request({
      url: `/warning/record/handle/${id}`,
      method: 'put',
      data
    })
  },
  
  /** 关闭预警记录 */
  closeWarningRecord(id) {
    return request({
      url: `/warning/record/close/${id}`,
      method: 'put'
    })
  },
  
  /** 删除预警记录 */
  deleteWarningRecord(id) {
    return request({
      url: `/warning/record/${id}`,
      method: 'delete'
    })
  },
  
  /** 统计预警记录数量 */
  countWarningRecords(params) {
    return request({
      url: '/warning/record/count',
      method: 'get',
      params
    })
  },
  
  /** 按预警级别统计 */
  countByWarningLevel() {
    return request({
      url: '/warning/record/count-by-level',
      method: 'get'
    })
  },
  
  /** 获取预警统计数据 */
  getWarningStatistics() {
    return request({
      url: '/warning/record/statistics',
      method: 'get'
    })
  },
  
  // ========== 预警规则 ==========
  
  /** 获取所有预警规则 */
  getAllWarningRules() {
    return request({
      url: '/warning/rule/all',
      method: 'get'
    })
  },
  
  /** 获取预警规则列表（分页） */
  getWarningRules(params) {
    return request({
      url: '/warning/rule/list',
      method: 'get',
      params
    })
  },
  
  /** 根据危化品ID获取预警规则 */
  getWarningRulesByHazmatId(hazmatId) {
    return request({
      url: `/warning/rule/by-hazmat/${hazmatId}`,
      method: 'get'
    })
  },
  
  /** 根据ID获取预警规则详情 */
  getWarningRuleById(id) {
    return request({
      url: `/warning/rule/${id}`,
      method: 'get'
    })
  },
  
  /** 添加预警规则 */
  addWarningRule(data) {
    return request({
      url: '/warning/rule',
      method: 'post',
      data
    })
  },
  
  /** 更新预警规则 */
  updateWarningRule(data) {
    return request({
      url: '/warning/rule',
      method: 'put',
      data
    })
  },
  
  /** 删除预警规则 */
  deleteWarningRule(id) {
    return request({
      url: `/warning/rule/${id}`,
      method: 'delete'
    })
  },
  
  /** 更新预警规则状态 */
  updateWarningRuleStatus(id, data) {
    return request({
      url: `/warning/rule/status/${id}`,
      method: 'put',
      data
    })
  },
  
  // ========== 监测参数 ==========
  
  /** 获取所有监测参数 */
  getAllParameters() {
    return request({
      url: '/monitoring/parameter/all',
      method: 'get'
    })
  },
  
  /** 获取监测参数列表（分页） */
  getParameters(params) {
    return request({
      url: '/monitoring/parameter/list',
      method: 'get',
      params
    })
  },
  
  /** 获取监测参数列表（分页）- 别名方法 */
  getParameterList(params) {
    return request({
      url: '/monitoring/parameter/list',
      method: 'get',
      params
    })
  },
  
  /** 根据ID获取监测参数详情 */
  getParameterById(id) {
    return request({
      url: `/monitoring/parameter/${id}`,
      method: 'get'
    })
  },
  
  /** 添加监测参数 */
  addParameter(data) {
    return request({
      url: '/monitoring/parameter',
      method: 'post',
      data
    })
  },
  
  /** 更新监测参数 */
  updateParameter(data) {
    return request({
      url: '/monitoring/parameter',
      method: 'put',
      data
    })
  },
  
  /** 删除监测参数 */
  deleteParameter(id) {
    return request({
      url: `/monitoring/parameter/${id}`,
      method: 'delete'
    })
  },
  
  // ========== 统计分析 ==========
  
  /** 获取监测统计概览数据 */
  getMonitoringStatistics() {
    return request({
      url: '/monitoring/statistics/overview',
      method: 'get'
    })
  },
  
  /** 获取预警趋势数据 */
  getWarningTrend(timeRange) {
    return request({
      url: '/monitoring/statistics/warning-trend',
      method: 'get',
      params: { timeRange }
    })
  },
  
  /** 获取危化品预警排名 */
  getHazmatRank() {
    return request({
      url: '/monitoring/statistics/hazmat-rank',
      method: 'get'
    })
  },
  
  /** 获取参数预警分布 */
  getParamDistribution() {
    return request({
      url: '/monitoring/statistics/param-distribution',
      method: 'get'
    })
  },
  
  /** 获取预警级别分布 */
  getLevelDistribution() {
    return request({
      url: '/monitoring/statistics/level-distribution',
      method: 'get'
    })
  },
  
  /** 获取主要统计数据 */
  getMainStatistics(params) {
    return request({
      url: '/monitoring/statistics/main',
      method: 'get',
      params
    })
  },
  
  /** 获取预警级别统计 */
  getLevelStatistics(params) {
    return request({
      url: '/monitoring/statistics/level',
      method: 'get',
      params
    })
  },
  
  /** 获取预警趋势统计 */
  getTrendStatistics(params) {
    return request({
      url: '/monitoring/statistics/trend',
      method: 'get',
      params
    })
  },
  
  /** 获取危化品排名统计 */
  getHazmatRankStatistics(params) {
    return request({
      url: '/monitoring/statistics/hazmat-rank',
      method: 'get',
      params
    })
  },
  
  /** 获取预警类型统计 */
  getTypeStatistics(params) {
    return request({
      url: '/monitoring/statistics/type',
      method: 'get',
      params
    })
  },
  
  /** 获取处理效率统计 */
  getEfficiencyStatistics(params) {
    return request({
      url: '/monitoring/statistics/efficiency',
      method: 'get',
      params
    })
  },
  
  /** 获取处理详情 */
  getHandleDetail(params) {
    return request({
      url: '/monitoring/statistics/handle-detail',
      method: 'get',
      params
    })
  },
  
  /** 导出统计数据 */
  exportStatistics(params) {
    return request({
      url: '/monitoring/statistics/export',
      method: 'get',
      params,
      responseType: 'blob'
    })
  }
}

// ==================== 危化品管理 API ====================

export const hazmatApi = {
  /** 获取所有危化品列表 */
  getAllHazmats() {
    return request({
      url: '/hazmat/info/all',
      method: 'get'
    })
  },

  /** 分页查询危化品（HazmatList.vue 使用） */
  getHazmatList(params) {
    return request({
      url: '/hazmat/info/list',
      method: 'get',
      params
    })
  },
  
  /** 获取危化品详情 */
  getHazmatById(id) {
    return request({
      url: `/hazmat/info/${id}`,
      method: 'get'
    })
  },
  
  /** 分页查询危化品 */
  getHazmatPage(params) {
    return request({
      url: '/hazmat/info/list',
      method: 'get',
      params
    })
  },
  
  /** 创建危化品 */
  createHazmat(data) {
    return request({
      url: '/hazmat/info',
      method: 'post',
      data
    })
  },

  /** 添加危化品（HazmatList.vue 使用） */
  addHazmat(data) {
    return request({
      url: '/hazmat/info',
      method: 'post',
      data
    })
  },
  
  /** 更新危化品 */
  updateHazmat(data) {
    return request({
      url: '/hazmat/info',
      method: 'put',
      data
    })
  },
  
  /** 删除危化品 */
  deleteHazmat(id) {
    return request({
      url: `/hazmat/info/${id}`,
      method: 'delete'
    })
  },
  
  /** 获取所有危化品分类（HazmatList.vue 使用） */
  getAllCategories() {
    return request({
      url: '/hazmat/category/all',
      method: 'get'
    })
  },

  /** 获取危化品分类列表 */
  getCategories() {
    return request({
      url: '/hazmat/category/all',
      method: 'get'
    })
  },

  /** 获取危化品类别列表（MonitoringStatistics.vue 使用） */
  getHazmatCategories() {
    return request({
      url: '/hazmat/category/all',
      method: 'get'
    })
  },
  
  /** 分页查询分类 */
  getCategoryPage(params) {
    return request({
      url: '/hazmat/category/list',
      method: 'get',
      params
    })
  },
  
  /** 获取分类详情 */
  getCategoryById(id) {
    return request({
      url: `/hazmat/category/${id}`,
      method: 'get'
    })
  },
  
  /** 创建分类 */
  createCategory(data) {
    return request({
      url: '/hazmat/category',
      method: 'post',
      data
    })
  },

  /** 添加分类（CategoryList.vue 使用） */
  addCategory(data) {
    return request({
      url: '/hazmat/category',
      method: 'post',
      data
    })
  },

  /** 获取分类分页列表（CategoryList.vue 使用） */
  getCategoryList(params) {
    return request({
      url: '/hazmat/category/list',
      method: 'get',
      params
    })
  },
  
  /** 更新分类 */
  updateCategory(data) {
    return request({
      url: '/hazmat/category',
      method: 'put',
      data
    })
  },
  
  /** 删除分类 */
  deleteCategory(id) {
    return request({
      url: `/hazmat/category/${id}`,
      method: 'delete'
    })
  },
  
  /** 统计危化品数量 */
  countHazmats() {
    return request({
      url: '/hazmat/count',
      method: 'get'
    })
  },
  
  /** 按类别统计 */
  countByCategory() {
    return request({
      url: '/hazmat/count-by-category',
      method: 'get'
    })
  }
}

// ==================== 隐患管理 API ====================

export const hazardApi = {
  /** 获取隐患列表 */
  getHazardList(params) {
    return request({
      url: '/hazard/list',
      method: 'get',
      params
    })
  },
  
  /** 获取隐患详情 */
  getHazardById(id) {
    return request({
      url: `/hazard/${id}`,
      method: 'get'
    })
  },
  
  /** 上报隐患 */
  reportHazard(data) {
    return request({
      url: '/hazard',
      method: 'post',
      data
    })
  },
  
  /** 处理隐患 */
  handleHazard(id, data) {
    return request({
      url: `/hazard/handle/${id}`,
      method: 'put',
      data
    })
  },
  
  /** 删除隐患 */
  deleteHazard(id) {
    return request({
      url: `/hazard/${id}`,
      method: 'delete'
    })
  },
  
  /** 获取我的隐患 */
  getMyHazards(params) {
    return request({
      url: '/hazard/my',
      method: 'get',
      params
    })
  },
  
  /** 获取待处理隐患 */
  getPendingHazards() {
    return request({
      url: '/hazard/pending',
      method: 'get'
    })
  }
}

// ==================== 安全检查 API ====================

export const checkApi = {
  /** 获取检查计划列表 */
  getPlanList(params) {
    return request({
      url: '/check/plan/list',
      method: 'get',
      params
    })
  },
  
  /** 获取检查计划详情 */
  getPlanById(id) {
    return request({
      url: `/check/plan/${id}`,
      method: 'get'
    })
  },
  
  /** 创建检查计划 */
  createPlan(data) {
    return request({
      url: '/check/plan',
      method: 'post',
      data
    })
  },

  /** 添加检查计划（PlanList.vue 使用） */
  addPlan(data) {
    return request({
      url: '/check/plan',
      method: 'post',
      data
    })
  },
  
  /** 更新检查计划 */
  updatePlan(data) {
    return request({
      url: '/check/plan',
      method: 'put',
      data
    })
  },

  /** 更新计划状态（PlanList.vue 使用） */
  updatePlanStatus(id, status) {
    return request({
      url: `/check/plan/${id}/status/${status}`,
      method: 'put'
    })
  },
  
  /** 删除检查计划 */
  deletePlan(id) {
    return request({
      url: `/check/plan/${id}`,
      method: 'delete'
    })
  },
  
  /** 获取待执行检查计划 */
  getPendingPlans() {
    return request({
      url: '/check/plan/pending',
      method: 'get'
    })
  },
  
  /** 获取检查记录列表 */
  getRecordList(params) {
    return request({
      url: '/check/record/list',
      method: 'get',
      params
    })
  },
  
  /** 提交检查记录 */
  submitRecord(data) {
    return request({
      url: '/check/record',
      method: 'post',
      data
    })
  },

  /** 添加检查记录（PlanList.vue 使用） */
  addRecord(data) {
    return request({
      url: '/check/record',
      method: 'post',
      data
    })
  },

  /** 删除检查记录（RecordList.vue 使用） */
  deleteRecord(id) {
    return request({
      url: `/check/record/${id}`,
      method: 'delete'
    })
  },

  /** 审核检查记录（RecordList.vue 使用） */
  auditRecord(id, status) {
    return request({
      url: `/check/record/${id}/audit/${status}`,
      method: 'put'
    })
  }
}

// ==================== 安全知识 API ====================

export const knowledgeApi = {
  /** 获取知识列表 */
  getKnowledgeList(params) {
    return request({
      url: '/knowledge/list',
      method: 'get',
      params
    })
  },

  /** 获取已发布的知识列表（员工端 KnowledgeList.vue 使用） */
  getPublishedKnowledge(params) {
    return request({
      url: '/knowledge/published',
      method: 'get',
      params
    })
  },
  
  /** 获取知识详情 */
  getKnowledgeById(id) {
    return request({
      url: `/knowledge/${id}`,
      method: 'get'
    })
  },
  
  /** 创建知识 */
  createKnowledge(data) {
    return request({
      url: '/knowledge',
      method: 'post',
      data
    })
  },

  /** 添加知识（KnowledgeManage.vue 使用） */
  addKnowledge(data) {
    return request({
      url: '/knowledge',
      method: 'post',
      data
    })
  },
  
  /** 更新知识 */
  updateKnowledge(data) {
    return request({
      url: '/knowledge',
      method: 'put',
      data
    })
  },

  /** 发布/取消发布知识（KnowledgeManage.vue 使用） */
  publishKnowledge(id, status) {
    return request({
      url: `/knowledge/${id}/publish/${status}`,
      method: 'put'
    })
  },
  
  /** 删除知识 */
  deleteKnowledge(id) {
    return request({
      url: `/knowledge/${id}`,
      method: 'delete'
    })
  }
}

// ==================== 公告管理 API ====================

export const announcementApi = {
  /** 获取公告列表 */
  getAnnouncementList(params) {
    return request({
      url: '/announcement/list',
      method: 'get',
      params
    })
  },
  
  /** 获取公告详情 */
  getAnnouncementById(id) {
    return request({
      url: `/announcement/${id}`,
      method: 'get'
    })
  },
  
  /** 创建公告 */
  createAnnouncement(data) {
    return request({
      url: '/announcement',
      method: 'post',
      data
    })
  },

  /** 添加公告（AnnouncementList.vue 使用） */
  addAnnouncement(data) {
    return request({
      url: '/announcement',
      method: 'post',
      data
    })
  },
  
  /** 更新公告 */
  updateAnnouncement(data) {
    return request({
      url: '/announcement',
      method: 'put',
      data
    })
  },

  /** 发布/取消发布公告（AnnouncementList.vue 使用） */
  publishAnnouncement(id, status) {
    return request({
      url: `/announcement/${id}/publish/${status}`,
      method: 'put'
    })
  },
  
  /** 删除公告 */
  deleteAnnouncement(id) {
    return request({
      url: `/announcement/${id}`,
      method: 'delete'
    })
  }
}

// ==================== AI助手 API ====================

export const aiApi = {
  /** AI对话 */
  chat(message) {
    return request({
      url: '/ai/chat',
      method: 'post',
      data: { message }
    })
  },

  /** 清除对话历史 */
  clearHistory() {
    return request({
      url: '/ai/history',
      method: 'delete'
    })
  }
}

export default {
  authApi,
  userApi,
  dashboardApi,
  monitoringApi,
  hazmatApi,
  hazardApi,
  checkApi,
  knowledgeApi,
  announcementApi,
  aiApi
}
