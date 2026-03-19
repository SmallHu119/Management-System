import request from '@/utils/request'

// ==================== 认证相关 ====================
export const authApi = {
  login: (data) => request.post('/auth/login', data),
  register: (data) => request.post('/auth/register', data),
  logout: () => request.post('/auth/logout'),
  changePassword: (data) => request.post('/auth/change-password', data),
  getUserInfo: () => request.get('/auth/info')
}

// ==================== 用户管理 ====================
export const userApi = {
  // 普通员工
  getUserList: (params) => request.get('/user/list', { params }),
  getUserById: (id) => request.get(`/user/${id}`),
  updateUser: (data) => request.put('/user', data),
  deleteUser: (id) => request.delete(`/user/${id}`),
  updateUserStatus: (id, status) => request.put(`/user/${id}/status/${status}`),
  resetUserPassword: (id, password) => request.put(`/user/${id}/reset-password`, null, { params: { newPassword: password } }),
  
  // 安全管理员
  getSafetyAdminList: (params) => request.get('/user/safety-admin/list', { params }),
  getSafetyAdminById: (id) => request.get(`/user/safety-admin/${id}`),
  addSafetyAdmin: (data) => request.post('/user/safety-admin', data),
  updateSafetyAdmin: (data) => request.put('/user/safety-admin', data),
  deleteSafetyAdmin: (id) => request.delete(`/user/safety-admin/${id}`),
  updateSafetyAdminStatus: (id, status) => request.put(`/user/safety-admin/${id}/status/${status}`),
  resetSafetyAdminPassword: (id, password) => request.put(`/user/safety-admin/${id}/reset-password`, null, { params: { newPassword: password } }),
  
  // 系统管理员
  getAdminById: (id) => request.get(`/user/admin/${id}`),
  updateAdmin: (data) => request.put('/user/admin', data)
}

// ==================== 危化品管理 ====================
export const hazmatApi = {
  // 类别
  getAllCategories: () => request.get('/hazmat/category/all'),
  getCategoryList: (params) => request.get('/hazmat/category/list', { params }),
  getCategoryById: (id) => request.get(`/hazmat/category/${id}`),
  addCategory: (data) => request.post('/hazmat/category', data),
  updateCategory: (data) => request.put('/hazmat/category', data),
  deleteCategory: (id) => request.delete(`/hazmat/category/${id}`),
  
  // 危化品信息
  getHazmatList: (params) => request.get('/hazmat/info/list', { params }),
  getAllHazmats: () => request.get('/hazmat/info/all'),
  getHazmatById: (id) => request.get(`/hazmat/info/${id}`),
  addHazmat: (data) => request.post('/hazmat/info', data),
  updateHazmat: (data) => request.put('/hazmat/info', data),
  deleteHazmat: (id) => request.delete(`/hazmat/info/${id}`),
  
  // 统计
  countHazmats: () => request.get('/hazmat/count'),
  countByCategory: () => request.get('/hazmat/count-by-category')
}

// ==================== 安全检查 ====================
export const checkApi = {
  // 检查计划
  getPlanList: (params) => request.get('/check/plan/list', { params }),
  getPendingPlans: () => request.get('/check/plan/pending'),
  getPlanById: (id) => request.get(`/check/plan/${id}`),
  addPlan: (data) => request.post('/check/plan', data),
  updatePlan: (data) => request.put('/check/plan', data),
  deletePlan: (id) => request.delete(`/check/plan/${id}`),
  updatePlanStatus: (id, status) => request.put(`/check/plan/${id}/status/${status}`),
  
  // 检查记录
  getRecordList: (params) => request.get('/check/record/list', { params }),
  getRecordById: (id) => request.get(`/check/record/${id}`),
  addRecord: (data) => request.post('/check/record', data),
  updateRecord: (data) => request.put('/check/record', data),
  deleteRecord: (id) => request.delete(`/check/record/${id}`),
  auditRecord: (id, status) => request.put(`/check/record/${id}/audit/${status}`),
  
  // 统计
  countPlans: () => request.get('/check/plan/count'),
  countRecords: () => request.get('/check/record/count')
}

// ==================== 隐患管理 ====================
export const hazardApi = {
  getHazardList: (params) => request.get('/hazard/list', { params }),
  getMyHazards: (params) => request.get('/hazard/my', { params }),
  getPendingHazards: () => request.get('/hazard/pending'),
  getHazardById: (id) => request.get(`/hazard/${id}`),
  reportHazard: (data) => request.post('/hazard', data),
  updateHazard: (data) => request.put('/hazard', data),
  deleteHazard: (id) => request.delete(`/hazard/${id}`),
  handleHazard: (id, data) => request.post(`/hazard/${id}/handle`, null, { params: data }),
  countHazards: () => request.get('/hazard/count'),
  countPendingHazards: () => request.get('/hazard/count/pending')
}

// ==================== 安全知识 ====================
export const knowledgeApi = {
  getKnowledgeList: (params) => request.get('/knowledge/list', { params }),
  getPublishedKnowledge: (params) => request.get('/knowledge/published', { params }),
  getKnowledgeById: (id) => request.get(`/knowledge/${id}`),
  addKnowledge: (data) => request.post('/knowledge', data),
  updateKnowledge: (data) => request.put('/knowledge', data),
  deleteKnowledge: (id) => request.delete(`/knowledge/${id}`),
  publishKnowledge: (id, status) => request.put(`/knowledge/${id}/publish/${status}`),
  getHotKnowledge: (limit) => request.get('/knowledge/hot', { params: { limit } }),
  getLatestKnowledge: (limit) => request.get('/knowledge/latest', { params: { limit } }),
  countKnowledge: () => request.get('/knowledge/count')
}

// ==================== 公告管理 ====================
export const announcementApi = {
  getAnnouncementList: (params) => request.get('/announcement/list', { params }),
  getPublishedAnnouncements: (params) => request.get('/announcement/published', { params }),
  getAnnouncementById: (id) => request.get(`/announcement/${id}`),
  addAnnouncement: (data) => request.post('/announcement', data),
  updateAnnouncement: (data) => request.put('/announcement', data),
  deleteAnnouncement: (id) => request.delete(`/announcement/${id}`),
  publishAnnouncement: (id, status) => request.put(`/announcement/${id}/publish/${status}`),
  getLatestAnnouncements: (limit) => request.get('/announcement/latest', { params: { limit } }),
  getSystemIntro: () => request.get('/announcement/intro'),
  countAnnouncements: () => request.get('/announcement/count')
}

// ==================== 首页统计 ====================
export const dashboardApi = {
  getStats: () => request.get('/dashboard/stats'),
  getLatestAnnouncements: () => request.get('/dashboard/announcements'),
  getPendingHazards: () => request.get('/dashboard/pending-hazards'),
  getPendingPlans: () => request.get('/dashboard/pending-plans'),
  getHotKnowledge: () => request.get('/dashboard/hot-knowledge'),
  getHazmatByCategory: () => request.get('/dashboard/hazmat-by-category')
}

// ==================== 文件上传 ====================
export const fileApi = {
  uploadFile: (file) => {
    const formData = new FormData()
    formData.append('file', file)
    return request.post('/file/upload', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  },
  uploadImage: (file) => {
    const formData = new FormData()
    formData.append('file', file)
    return request.post('/file/upload/image', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
  },
  deleteFile: (filePath) => request.delete('/file', { params: { filePath } })
}
