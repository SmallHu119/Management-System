<template>
  <div class="warning-records-list">
    <el-page-header @back="$router.go(-1)" content="预警记录管理" />
    
    <el-card>
      <template #header>
        <div class="card-header">
          <span>预警记录管理</span>
          <div class="header-buttons">
            <el-button type="primary" @click="openAddDialog" icon="Plus">
              添加预警
            </el-button>
            <el-button @click="refreshData" icon="Refresh">
              刷新
            </el-button>
          </div>
        </div>
      </template>
      
      <el-form :model="searchForm" inline @submit.prevent="getWarningRecords">
        <el-form-item label="危化品名称">
          <el-select v-model="searchForm.hazmatId" placeholder="请选择危化品" clearable>
            <el-option
              v-for="hazmat in hazmatList"
              :key="hazmat.id"
              :label="hazmat.name"
              :value="hazmat.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="预警状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="未处理" :value="0" />
            <el-option label="处理中" :value="1" />
            <el-option label="已解决" :value="2" />
            <el-option label="已忽略" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="预警级别">
          <el-select v-model="searchForm.warningLevel" placeholder="请选择预警级别" clearable>
            <el-option label="低级" :value="1" />
            <el-option label="中级" :value="2" />
            <el-option label="高级" :value="3" />
            <el-option label="紧急" :value="4" />
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围">
          <el-date-picker
            v-model="dateRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="getWarningRecords" icon="Search">
            搜索
          </el-button>
          <el-button @click="resetSearch" icon="Refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
      
      <el-table
        v-loading="loading"
        :data="warningRecords"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column prop="hazmatName" label="危化品名称" min-width="150" />
        <el-table-column prop="paramName" label="参数名称" min-width="120" />
        <el-table-column prop="warningLevel" label="预警级别" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getLevelTagType(scope.row.warningLevel)">
              {{ getLevelText(scope.row.warningLevel) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="warningValue" label="预警值" min-width="100" align="right">
          <template #default="scope">
            {{ scope.row.warningValue }}
            <span style="margin-left: 5px; color: #909399;">
              {{ scope.row.paramUnit }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="thresholdValue" label="阈值" min-width="100" align="right">
          <template #default="scope">
            {{ scope.row.thresholdValue }}
            <span style="margin-left: 5px; color: #909399;">
              {{ scope.row.paramUnit }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="处理状态" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getStatusTagType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="warningTime" label="预警时间" width="180" align="center" />
        <el-table-column prop="handlerName" label="处理人" width="100" align="center" />
        <el-table-column prop="handleTime" label="处理时间" width="180" align="center" />
        <el-table-column label="操作" width="260" align="center">
          <template #default="scope">
            <el-button
              size="small"
              @click="viewWarningRecord(scope.row)"
              icon="View"
            >
              查看
            </el-button>
            <el-button
              size="small"
              @click="handleWarningRecord(scope.row)"
              icon="Edit"
              type="warning"
              :disabled="scope.row.status === 2 || scope.row.status === 3"
            >
              处理
            </el-button>
            <el-button
              size="small"
              @click="deleteWarningRecord(scope.row.id)"
              icon="Delete"
              type="danger"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <el-pagination
        v-model:current-page="pagination.pageNum"
        v-model:page-size="pagination.pageSize"
        :total="pagination.total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="getWarningRecords"
        @current-change="getWarningRecords"
      />
    </el-card>
    
    <!-- 查看预警记录详情对话框 -->
    <el-dialog
      v-model="showViewDialog"
      title="预警记录详情"
      width="600px"
    >
      <el-descriptions :column="2" border>
        <el-descriptions-item label="ID">{{ currentRecord.id }}</el-descriptions-item>
        <el-descriptions-item label="危化品名称">{{ currentRecord.hazmatName }}</el-descriptions-item>
        <el-descriptions-item label="参数名称">{{ currentRecord.paramName }}</el-descriptions-item>
        <el-descriptions-item label="预警级别">
          <el-tag :type="getLevelTagType(currentRecord.warningLevel)">
            {{ getLevelText(currentRecord.warningLevel) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="预警值">
          {{ currentRecord.warningValue }} {{ currentRecord.paramUnit }}
        </el-descriptions-item>
        <el-descriptions-item label="阈值">
          {{ currentRecord.thresholdValue }} {{ currentRecord.paramUnit }}
        </el-descriptions-item>
        <el-descriptions-item label="处理状态">
          <el-tag :type="getStatusTagType(currentRecord.status)">
            {{ getStatusText(currentRecord.status) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="预警时间">{{ currentRecord.warningTime }}</el-descriptions-item>
        <el-descriptions-item label="处理人">{{ currentRecord.handlerName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="处理时间">{{ currentRecord.handleTime || '-' }}</el-descriptions-item>
        <el-descriptions-item label="预警描述" :span="2">
          {{ currentRecord.description || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="处理备注" :span="2">
          {{ currentRecord.handleRemark || '-' }}
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="showViewDialog = false">关闭</el-button>
      </template>
    </el-dialog>
    
    <!-- 处理预警记录对话框 -->
    <el-dialog
      v-model="showHandleDialog"
      title="处理预警记录"
      width="500px"
    >
      <el-form
        ref="handleFormRef"
        :model="handleForm"
        :rules="handleFormRules"
        label-width="100px"
      >
        <el-form-item label="处理状态" prop="status">
          <el-select v-model="handleForm.status" placeholder="请选择处理状态">
            <el-option label="处理中" :value="1" />
            <el-option label="已解决" :value="2" />
            <el-option label="已忽略" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="处理人" prop="handlerName">
          <el-input v-model="handleForm.handlerName" placeholder="请输入处理人姓名" />
        </el-form-item>
        <el-form-item label="处理备注" prop="handleRemark">
          <el-input
            v-model="handleForm.handleRemark"
            type="textarea"
            :rows="4"
            placeholder="请输入处理备注"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showHandleDialog = false">取消</el-button>
        <el-button type="primary" @click="submitHandle" :loading="handling">
          {{ handling ? '提交中...' : '提交' }}
        </el-button>
      </template>
    </el-dialog>
    
    <!-- 添加预警记录对话框 -->
    <el-dialog
      v-model="showAddDialog"
      title="添加预警记录"
      width="500px"
      @close="resetAddForm"
    >
      <el-form
        ref="addFormRef"
        :model="addForm"
        :rules="addFormRules"
        label-width="120px"
      >
        <el-form-item label="危化品" prop="hazmatId">
          <el-select v-model="addForm.hazmatId" placeholder="请选择危化品" clearable>
            <el-option
              v-for="hazmat in hazmatList"
              :key="hazmat.id"
              :label="hazmat.name"
              :value="hazmat.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="参数" prop="paramId">
          <el-select v-model="addForm.paramId" placeholder="请选择参数" clearable>
            <el-option
              v-for="param in parameterList"
              :key="param.id"
              :label="param.name"
              :value="param.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="预警级别" prop="warningLevel">
          <el-select v-model="addForm.warningLevel" placeholder="请选择预警级别">
            <el-option label="低级" :value="1" />
            <el-option label="中级" :value="2" />
            <el-option label="高级" :value="3" />
            <el-option label="紧急" :value="4" />
          </el-select>
        </el-form-item>
        <el-form-item label="预警值" prop="warningValue">
          <el-input-number v-model="addForm.warningValue" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="阈值" prop="thresholdValue">
          <el-input-number v-model="addForm.thresholdValue" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="预警描述" prop="description">
          <el-input
            v-model="addForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入预警描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="submitAdd" :loading="adding">
          {{ adding ? '提交中...' : '提交' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { monitoringApi, hazmatApi } from '@/api'

const loading = ref(false)
const warningRecords = ref([])
const hazmatList = ref([])
const parameterList = ref([])
const searchForm = reactive({
  hazmatId: null,
  status: null,
  warningLevel: null
})
const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})
const dateRange = ref([])

// 查看详情相关
const showViewDialog = ref(false)
const currentRecord = ref({})

// 处理预警相关
const showHandleDialog = ref(false)
const handling = ref(false)
const handleFormRef = ref(null)
const handleForm = reactive({
  id: null,
  status: null,
  handlerName: '',
  handleRemark: ''
})
const handleFormRules = {
  status: [{ required: true, message: '请选择处理状态', trigger: 'change' }],
  handlerName: [{ required: true, message: '请输入处理人姓名', trigger: 'blur' }],
  handleRemark: [{ required: true, message: '请输入处理备注', trigger: 'blur' }]
}

// 添加预警相关
const showAddDialog = ref(false)
const adding = ref(false)
const addFormRef = ref(null)
const addForm = reactive({
  hazmatId: null,
  paramId: null,
  warningLevel: null,
  warningValue: null,
  thresholdValue: null,
  description: ''
})
const addFormRules = {
  hazmatId: [{ required: true, message: '请选择危化品', trigger: 'change' }],
  paramId: [{ required: true, message: '请选择参数', trigger: 'change' }],
  warningLevel: [{ required: true, message: '请选择预警级别', trigger: 'change' }],
  warningValue: [{ required: true, message: '请输入预警值', trigger: 'blur' }],
  thresholdValue: [{ required: true, message: '请输入阈值', trigger: 'blur' }]
}

// 获取级别标签类型
const getLevelTagType = (level) => {
  switch (level) {
    case 1: return 'info'
    case 2: return 'warning'
    case 3: return 'danger'
    case 4: return 'danger'
    default: return 'info'
  }
}

// 获取级别文本
const getLevelText = (level) => {
  switch (level) {
    case 1: return '低级'
    case 2: return '中级'
    case 3: return '高级'
    case 4: return '紧急'
    default: return '未知'
  }
}

// 获取状态标签类型
const getStatusTagType = (status) => {
  switch (status) {
    case 0: return 'danger'
    case 1: return 'warning'
    case 2: return 'success'
    case 3: return 'info'
    default: return 'info'
  }
}

// 获取状态文本
const getStatusText = (status) => {
  switch (status) {
    case 0: return '未处理'
    case 1: return '处理中'
    case 2: return '已解决'
    case 3: return '已忽略'
    default: return '未知'
  }
}

// 获取预警记录
const getWarningRecords = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      hazmatId: searchForm.hazmatId,
      status: searchForm.status,
      warningLevel: searchForm.warningLevel,
      startTime: dateRange.value[0],
      endTime: dateRange.value[1]
    }
    const response = await monitoringApi.getWarningRecords(params)
    if (response.code === 200) {
      const list = response.data.list || []
      warningRecords.value = list.map(item => ({
        ...item,
        hazmatName: item.hazmatName || hazmatList.value.find(h => h.id === item.hazmatId)?.name || `危化品#${item.hazmatId}`,
        paramName: item.paramName || parameterList.value.find(p => p.id === item.paramId)?.name || `参数#${item.paramId}`,
        paramUnit: item.paramUnit || parameterList.value.find(p => p.id === item.paramId)?.unit || ''
      }))
      pagination.total = response.data.total
    } else {
      ElMessage.error(response.message || '获取预警记录失败')
    }
  } catch (error) {
    ElMessage.error('获取预警记录失败：' + error.message)
  } finally {
    loading.value = false
  }
}

// 获取危化品列表
const getHazmatList = async () => {
  try {
    const response = await hazmatApi.getAllHazmats()
    if (response.code === 200) {
      hazmatList.value = response.data
    }
  } catch (error) {
    ElMessage.error('获取危化品列表失败：' + error.message)
  }
}

// 获取参数列表
const getParameterList = async () => {
  try {
    const response = await monitoringApi.getAllParameters()
    if (response.code === 200) {
      parameterList.value = response.data
    }
  } catch (error) {
    ElMessage.error('获取参数列表失败：' + error.message)
  }
}

// 刷新
const refreshData = () => {
  getWarningRecords()
  ElMessage.success('数据已刷新')
}

// 重置搜索
const resetSearch = () => {
  searchForm.hazmatId = null
  searchForm.status = null
  searchForm.warningLevel = null
  dateRange.value = []
  pagination.pageNum = 1
  getWarningRecords()
}

// 查看预警记录详情
const viewWarningRecord = async (row) => {
  try {
    const response = await monitoringApi.getWarningRecordById(row.id)
    if (response.code === 200) {
      const data = response.data
      currentRecord.value = {
        ...data,
        hazmatName: data.hazmatName || hazmatList.value.find(h => h.id === data.hazmatId)?.name || `危化品#${data.hazmatId}`,
        paramName: data.paramName || parameterList.value.find(p => p.id === data.paramId)?.name || `参数#${data.paramId}`,
        paramUnit: data.paramUnit || parameterList.value.find(p => p.id === data.paramId)?.unit || ''
      }
      showViewDialog.value = true
    } else {
      ElMessage.error(response.message || '获取预警记录详情失败')
    }
  } catch (error) {
    ElMessage.error('获取预警记录详情失败：' + error.message)
  }
}

// 处理预警记录
const handleWarningRecord = (row) => {
  handleForm.id = row.id
  handleForm.status = row.status === 0 ? 1 : row.status
  handleForm.handlerName = ''
  handleForm.handleRemark = ''
  showHandleDialog.value = true
}

// 提交处理
const submitHandle = async () => {
  if (!handleFormRef.value) return
  
  try {
    await handleFormRef.value.validate()
    handling.value = true
    
    const response = await monitoringApi.handleWarningRecord(handleForm.id, {
      status: handleForm.status,
      handlerName: handleForm.handlerName,
      handleRemark: handleForm.handleRemark
    })
    
    if (response.code === 200) {
      ElMessage.success('处理成功')
      showHandleDialog.value = false
      getWarningRecords()
    } else {
      ElMessage.error(response.message || '处理失败')
    }
  } catch (error) {
    if (error.name !== 'ValidationError') {
      ElMessage.error('处理失败：' + error.message)
    }
  } finally {
    handling.value = false
  }
}

// 打开添加对话框
const openAddDialog = () => {
  resetAddForm()
  showAddDialog.value = true
}

// 重置添加表单
const resetAddForm = () => {
  addForm.hazmatId = null
  addForm.paramId = null
  addForm.warningLevel = null
  addForm.warningValue = null
  addForm.thresholdValue = null
  addForm.description = ''
  if (addFormRef.value) {
    addFormRef.value.clearValidate()
  }
}

// 提交添加
const submitAdd = async () => {
  if (!addFormRef.value) return
  
  try {
    await addFormRef.value.validate()
    adding.value = true
    
    const response = await monitoringApi.addWarningRecord(addForm)
    
    if (response.code === 200) {
      ElMessage.success('添加成功')
      showAddDialog.value = false
      getWarningRecords()
    } else {
      ElMessage.error(response.message || '添加失败')
    }
  } catch (error) {
    if (error.name !== 'ValidationError') {
      ElMessage.error('添加失败：' + error.message)
    }
  } finally {
    adding.value = false
  }
}

// 删除预警记录
const deleteWarningRecord = (id) => {
  ElMessageBox.confirm(
    '此操作将永久删除该预警记录, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  )
    .then(async () => {
      try {
        const response = await monitoringApi.deleteWarningRecord(id)
        if (response.code === 200) {
          ElMessage.success('删除成功!')
          getWarningRecords()
        } else {
          ElMessage.error(response.message || '删除失败')
        }
      } catch (error) {
        ElMessage.error('删除失败：' + error.message)
      }
    })
    .catch(() => {
      ElMessage.info('已取消删除')
    })
}

onMounted(async () => {
  await Promise.all([getHazmatList(), getParameterList()])
  getWarningRecords()
})
</script>

<style scoped>
.warning-records-list {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.header-buttons {
  display: flex;
  gap: 10px;
}
</style>
