<template>
  <div class="warning-rules-list">
    <el-page-header @back="$router.go(-1)" content="预警规则管理" />
    
    <el-card>
      <template #header>
        <div class="card-header">
          <span>预警规则管理</span>
          <div class="header-buttons">
            <el-button type="primary" @click="openAddDialog" icon="Plus">
              添加规则
            </el-button>
            <el-button @click="refreshData" icon="Refresh">
              刷新
            </el-button>
          </div>
        </div>
      </template>
      
      <el-form :model="searchForm" inline @submit.prevent="getWarningRules">
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
        <el-form-item label="参数名称">
          <el-select v-model="searchForm.paramId" placeholder="请选择参数" clearable>
            <el-option
              v-for="param in parameterList"
              :key="param.id"
              :label="param.name"
              :value="param.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="规则状态">
          <el-select v-model="searchForm.enabled" placeholder="请选择状态" clearable>
            <el-option label="启用" :value="1" />
            <el-option label="禁用" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="getWarningRules" icon="Search">
            搜索
          </el-button>
          <el-button @click="resetSearch" icon="Refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
      
      <el-table
        v-loading="loading"
        :data="warningRules"
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
        <el-table-column prop="minValue" label="正常下限" width="100" align="right" />
        <el-table-column prop="maxValue" label="正常上限" width="100" align="right" />
        <el-table-column prop="warningMinValue" label="预警下限" width="100" align="right" />
        <el-table-column prop="warningMaxValue" label="预警上限" width="100" align="right" />
        <el-table-column prop="enabled" label="状态" width="80" align="center">
          <template #default="scope">
            <el-switch
              v-model="scope.row.enabled"
              :active-value="1"
              :inactive-value="0"
              @change="toggleRuleStatus(scope.row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" min-width="200" show-overflow-tooltip />
        <el-table-column label="操作" width="180" align="center">
          <template #default="scope">
            <el-button
              size="small"
              @click="editWarningRule(scope.row)"
              icon="Edit"
              type="primary"
            >
              编辑
            </el-button>
            <el-button
              size="small"
              @click="deleteWarningRule(scope.row.id)"
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
        @size-change="getWarningRules"
        @current-change="getWarningRules"
      />
    </el-card>
    
    <!-- 添加/编辑预警规则对话框 -->
    <el-dialog
      v-model="showDialog"
      :title="dialogTitle"
      width="600px"
      @close="resetForm"
    >
      <el-form
        ref="ruleFormRef"
        :model="ruleForm"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item label="危化品" prop="hazmatId">
          <el-select v-model="ruleForm.hazmatId" placeholder="请选择危化品" clearable style="width: 100%">
            <el-option
              v-for="hazmat in hazmatList"
              :key="hazmat.id"
              :label="hazmat.name"
              :value="hazmat.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="监测参数" prop="paramId">
          <el-select v-model="ruleForm.paramId" placeholder="请选择监测参数" clearable style="width: 100%">
            <el-option
              v-for="param in parameterList"
              :key="param.id"
              :label="param.name"
              :value="param.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="预警级别" prop="warningLevel">
          <el-select v-model="ruleForm.warningLevel" placeholder="请选择预警级别" style="width: 100%">
            <el-option label="低级" :value="1" />
            <el-option label="中级" :value="2" />
            <el-option label="高级" :value="3" />
            <el-option label="紧急" :value="4" />
          </el-select>
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="正常下限" prop="minValue">
              <el-input-number v-model="ruleForm.minValue" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="正常上限" prop="maxValue">
              <el-input-number v-model="ruleForm.maxValue" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="预警下限" prop="warningMinValue">
              <el-input-number v-model="ruleForm.warningMinValue" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="预警上限" prop="warningMaxValue">
              <el-input-number v-model="ruleForm.warningMaxValue" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="是否启用" prop="enabled">
          <el-switch
            v-model="ruleForm.enabled"
            :active-value="1"
            :inactive-value="0"
            active-text="启用"
            inactive-text="禁用"
          />
        </el-form-item>
        <el-form-item label="规则描述" prop="description">
          <el-input
            v-model="ruleForm.description"
            type="textarea"
            :rows="4"
            placeholder="请输入规则描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showDialog = false">取消</el-button>
        <el-button type="primary" @click="saveRule" :loading="saving">
          {{ saving ? '保存中...' : '保存' }}
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
const warningRules = ref([])
const hazmatList = ref([])
const parameterList = ref([])
const searchForm = reactive({
  hazmatId: null,
  paramId: null,
  enabled: null
})
const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

// 对话框相关
const showDialog = ref(false)
const dialogTitle = ref('')
const saving = ref(false)
const ruleFormRef = ref(null)
const ruleForm = reactive({
  id: null,
  hazmatId: null,
  paramId: null,
  warningLevel: null,
  minValue: null,
  maxValue: null,
  warningMinValue: null,
  warningMaxValue: null,
  enabled: 1,
  description: ''
})

// 表单验证规则
const formRules = {
  hazmatId: [{ required: true, message: '请选择危化品', trigger: 'change' }],
  paramId: [{ required: true, message: '请选择监测参数', trigger: 'change' }],
  warningLevel: [{ required: true, message: '请选择预警级别', trigger: 'change' }],
  minValue: [{ required: true, message: '请输入正常下限', trigger: 'blur' }],
  maxValue: [{ required: true, message: '请输入正常上限', trigger: 'blur' }],
  warningMinValue: [{ required: true, message: '请输入预警下限', trigger: 'blur' }],
  warningMaxValue: [{ required: true, message: '请输入预警上限', trigger: 'blur' }]
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

// 获取预警规则
const getWarningRules = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      hazmatId: searchForm.hazmatId,
      paramId: searchForm.paramId,
      enabled: searchForm.enabled
    }
    const response = await monitoringApi.getWarningRules(params)
    if (response.code === 200) {
      const list = response.data.list || []
      warningRules.value = list.map(item => ({
        ...item,
        hazmatName: item.hazmatName || hazmatList.value.find(h => h.id === item.hazmatId)?.name || `危化品#${item.hazmatId}`,
        paramName: item.paramName || parameterList.value.find(p => p.id === item.paramId)?.name || `参数#${item.paramId}`
      }))
      pagination.total = response.data.total
    } else {
      ElMessage.error(response.message || '获取预警规则失败')
    }
  } catch (error) {
    ElMessage.error('获取预警规则失败：' + error.message)
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
  getWarningRules()
  ElMessage.success('数据已刷新')
}

// 重置搜索
const resetSearch = () => {
  searchForm.hazmatId = null
  searchForm.paramId = null
  searchForm.enabled = null
  pagination.pageNum = 1
  getWarningRules()
}

// 打开添加对话框
const openAddDialog = () => {
  dialogTitle.value = '添加预警规则'
  resetForm()
  showDialog.value = true
}

// 编辑预警规则
const editWarningRule = async (row) => {
  dialogTitle.value = '编辑预警规则'
  resetForm()
  
  try {
    const response = await monitoringApi.getWarningRuleById(row.id)
    if (response.code === 200) {
      const data = response.data
      Object.assign(ruleForm, {
        id: data.id,
        hazmatId: data.hazmatId,
        paramId: data.paramId,
        warningLevel: data.warningLevel,
        minValue: data.minValue,
        maxValue: data.maxValue,
        warningMinValue: data.warningMinValue,
        warningMaxValue: data.warningMaxValue,
        enabled: data.enabled,
        description: data.description
      })
      showDialog.value = true
    } else {
      ElMessage.error(response.message || '获取规则详情失败')
    }
  } catch (error) {
    ElMessage.error('获取规则详情失败：' + error.message)
  }
}

// 切换规则状态
const toggleRuleStatus = async (row) => {
  try {
    const response = await monitoringApi.updateWarningRule({
      id: row.id,
      enabled: row.enabled
    })
    if (response.code === 200) {
      ElMessage.success(row.enabled ? '已启用' : '已禁用')
    } else {
      row.enabled = row.enabled === 1 ? 0 : 1
      ElMessage.error(response.message || '操作失败')
    }
  } catch (error) {
    row.enabled = row.enabled === 1 ? 0 : 1
    ElMessage.error('操作失败：' + error.message)
  }
}

// 删除预警规则
const deleteWarningRule = (id) => {
  ElMessageBox.confirm(
    '此操作将永久删除该预警规则, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  )
    .then(async () => {
      try {
        const response = await monitoringApi.deleteWarningRule(id)
        if (response.code === 200) {
          ElMessage.success('删除成功!')
          getWarningRules()
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

// 重置表单
const resetForm = () => {
  ruleForm.id = null
  ruleForm.hazmatId = null
  ruleForm.paramId = null
  ruleForm.warningLevel = null
  ruleForm.minValue = null
  ruleForm.maxValue = null
  ruleForm.warningMinValue = null
  ruleForm.warningMaxValue = null
  ruleForm.enabled = 1
  ruleForm.description = ''
  if (ruleFormRef.value) {
    ruleFormRef.value.clearValidate()
  }
}

// 保存规则
const saveRule = async () => {
  if (!ruleFormRef.value) return
  
  try {
    await ruleFormRef.value.validate()
    saving.value = true
    
    // 验证范围值逻辑
    if (ruleForm.minValue >= ruleForm.maxValue) {
      ElMessage.error('正常下限必须小于正常上限')
      return
    }
    if (ruleForm.warningMinValue >= ruleForm.warningMaxValue) {
      ElMessage.error('预警下限必须小于预警上限')
      return
    }
    
    let response
    if (ruleForm.id) {
      response = await monitoringApi.updateWarningRule(ruleForm)
    } else {
      response = await monitoringApi.addWarningRule(ruleForm)
    }
    
    if (response.code === 200) {
      ElMessage.success(ruleForm.id ? '更新成功' : '添加成功')
      showDialog.value = false
      getWarningRules()
    } else {
      ElMessage.error(response.message || '保存失败')
    }
  } catch (error) {
    if (error.name !== 'ValidationError') {
      ElMessage.error('保存失败：' + error.message)
    }
  } finally {
    saving.value = false
  }
}

onMounted(async () => {
  await Promise.all([getHazmatList(), getParameterList()])
  getWarningRules()
})
</script>

<style scoped>
.warning-rules-list {
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
