<template>
  <div class="parameter-config-list">
    <el-page-header @back="$router.go(-1)" content="监测参数配置" />
    
    <el-card>
      <template #header>
        <div class="card-header">
          <span>监测参数配置</span>
          <div class="header-buttons">
            <el-button type="primary" @click="openAddDialog" icon="Plus">
              添加参数
            </el-button>
            <el-button @click="refreshData" icon="Refresh">
              刷新
            </el-button>
          </div>
        </div>
      </template>
      
      <el-form :model="searchForm" inline @submit.prevent="getParameters">
        <el-form-item label="参数名称">
          <el-input v-model="searchForm.name" placeholder="请输入参数名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="getParameters" icon="Search">
            搜索
          </el-button>
          <el-button @click="resetSearch" icon="Refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
      
      <el-table
        v-loading="loading"
        :data="parameters"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column prop="name" label="参数名称" min-width="150" />
        <el-table-column prop="code" label="参数编码" min-width="120" />
        <el-table-column prop="unit" label="单位" width="100" align="center" />
        <el-table-column prop="dataType" label="数据类型" width="100" align="center">
          <template #default="scope">
            <el-tag size="small">{{ scope.row.dataType || '数值型' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="normalMin" label="正常下限" width="100" align="right" />
        <el-table-column prop="normalMax" label="正常上限" width="100" align="right" />
        <el-table-column prop="description" label="描述" min-width="200" show-overflow-tooltip />
        <el-table-column label="操作" width="180" align="center">
          <template #default="scope">
            <el-button
              size="small"
              @click="editParameter(scope.row)"
              icon="Edit"
              type="primary"
            >
              编辑
            </el-button>
            <el-button
              size="small"
              @click="deleteParameter(scope.row.id)"
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
        @size-change="getParameters"
        @current-change="getParameters"
      />
    </el-card>
    
    <!-- 添加/编辑参数对话框 -->
    <el-dialog
      v-model="showDialog"
      :title="dialogTitle"
      width="500px"
      @close="resetForm"
    >
      <el-form
        ref="paramFormRef"
        :model="paramForm"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="参数名称" prop="name">
          <el-input v-model="paramForm.name" placeholder="请输入参数名称" />
        </el-form-item>
        <el-form-item label="参数编码" prop="code">
          <el-input v-model="paramForm.code" placeholder="请输入参数编码" />
        </el-form-item>
        <el-form-item label="单位" prop="unit">
          <el-input v-model="paramForm.unit" placeholder="请输入单位" />
        </el-form-item>
        <el-form-item label="数据类型" prop="dataType">
          <el-select v-model="paramForm.dataType" placeholder="请选择数据类型" style="width: 100%">
            <el-option label="数值型" value="数值型" />
            <el-option label="文本型" value="文本型" />
            <el-option label="布尔型" value="布尔型" />
          </el-select>
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="正常下限" prop="normalMin">
              <el-input-number v-model="paramForm.normalMin" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="正常上限" prop="normalMax">
              <el-input-number v-model="paramForm.normalMax" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="paramForm.description"
            type="textarea"
            :rows="4"
            placeholder="请输入参数描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showDialog = false">取消</el-button>
        <el-button type="primary" @click="saveParameter" :loading="saving">
          {{ saving ? '保存中...' : '保存' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { monitoringApi } from '@/api'

const loading = ref(false)
const parameters = ref([])
const searchForm = reactive({
  name: ''
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
const paramFormRef = ref(null)
const paramForm = reactive({
  id: null,
  name: '',
  code: '',
  unit: '',
  dataType: '数值型',
  normalMin: null,
  normalMax: null,
  description: ''
})

// 表单验证规则
const formRules = {
  name: [{ required: true, message: '请输入参数名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入参数编码', trigger: 'blur' }],
  unit: [{ required: true, message: '请输入单位', trigger: 'blur' }]
}

// 获取参数列表
const getParameters = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      name: searchForm.name || undefined
    }
    const response = await monitoringApi.getParameters(params)
    if (response.code === 200) {
      parameters.value = response.data.list || response.data || []
      pagination.total = response.data.total || 0
    } else {
      ElMessage.error(response.message || '获取参数列表失败')
    }
  } catch (error) {
    ElMessage.error('获取参数列表失败：' + error.message)
  } finally {
    loading.value = false
  }
}

// 刷新
const refreshData = () => {
  getParameters()
  ElMessage.success('数据已刷新')
}

// 重置搜索
const resetSearch = () => {
  searchForm.name = ''
  pagination.pageNum = 1
  getParameters()
}

// 打开添加对话框
const openAddDialog = () => {
  dialogTitle.value = '添加监测参数'
  resetForm()
  showDialog.value = true
}

// 编辑参数
const editParameter = async (row) => {
  dialogTitle.value = '编辑监测参数'
  resetForm()
  
  try {
    const response = await monitoringApi.getParameterById(row.id)
    if (response.code === 200) {
      const data = response.data
      Object.assign(paramForm, {
        id: data.id,
        name: data.name,
        code: data.code,
        unit: data.unit,
        dataType: data.dataType || '数值型',
        normalMin: data.normalMin,
        normalMax: data.normalMax,
        description: data.description
      })
      showDialog.value = true
    } else {
      ElMessage.error(response.message || '获取参数详情失败')
    }
  } catch (error) {
    ElMessage.error('获取参数详情失败：' + error.message)
  }
}

// 删除参数
const deleteParameter = (id) => {
  ElMessageBox.confirm(
    '此操作将永久删除该监测参数, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  )
    .then(async () => {
      try {
        const response = await monitoringApi.deleteParameter(id)
        if (response.code === 200) {
          ElMessage.success('删除成功!')
          getParameters()
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
  paramForm.id = null
  paramForm.name = ''
  paramForm.code = ''
  paramForm.unit = ''
  paramForm.dataType = '数值型'
  paramForm.normalMin = null
  paramForm.normalMax = null
  paramForm.description = ''
  if (paramFormRef.value) {
    paramFormRef.value.clearValidate()
  }
}

// 保存参数
const saveParameter = async () => {
  if (!paramFormRef.value) return
  
  try {
    await paramFormRef.value.validate()
    saving.value = true
    
    let response
    if (paramForm.id) {
      response = await monitoringApi.updateParameter(paramForm)
    } else {
      response = await monitoringApi.addParameter(paramForm)
    }
    
    if (response.code === 200) {
      ElMessage.success(paramForm.id ? '更新成功' : '添加成功')
      showDialog.value = false
      getParameters()
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

onMounted(() => {
  getParameters()
})
</script>

<style scoped>
.parameter-config-list {
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
