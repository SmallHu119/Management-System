<template>
  <div class="parameter-list">
    <el-page-header @back="$router.go(-1)" content="监测参数管理" />
    
    <el-card>
      <template #header>
        <div class="card-header">
          <span>监测参数列表</span>
          <el-button type="primary" @click="showAddDialog = true" icon="Plus">
            添加参数
          </el-button>
        </div>
      </template>
      
      <el-form :model="searchForm" inline @submit.prevent="getParameterList">
        <el-form-item label="参数名称">
          <el-input v-model="searchForm.name" placeholder="请输入参数名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="getParameterList" icon="Search">
            搜索
          </el-button>
          <el-button @click="resetSearch" icon="Refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
      
      <el-table
        v-loading="loading"
        :data="parameterList"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column prop="name" label="参数名称" min-width="120" />
        <el-table-column prop="code" label="参数编码" min-width="120" />
        <el-table-column prop="unit" label="计量单位" width="100" align="center" />
        <el-table-column prop="description" label="参数描述" min-width="200" />
        <el-table-column prop="sortOrder" label="排序" width="80" align="center" />
        <el-table-column
          prop="status"
          label="状态"
          width="100"
          align="center"
        >
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" align="center" />
        <el-table-column label="操作" width="180" align="center">
          <template #default="scope">
            <el-button
              size="small"
              icon="Edit"
              @click="editParameter(scope.row)"
              type="primary"
            >
              编辑
            </el-button>
            <el-button
              size="small"
              icon="Delete"
              @click="deleteParameter(scope.row.id)"
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
        @size-change="getParameterList"
        @current-change="getParameterList"
      />
    </el-card>
    
    <!-- 添加/编辑参数对话框 -->
    <el-dialog
      v-model="showDialog"
      :title="dialogTitle"
      width="500px"
      @close="resetDialog"
    >
      <el-form
        ref="parameterForm"
        :model="parameterForm"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="参数名称" prop="name">
          <el-input v-model="parameterForm.name" placeholder="请输入参数名称" />
        </el-form-item>
        <el-form-item label="参数编码" prop="code">
          <el-input v-model="parameterForm.code" placeholder="请输入参数编码" />
        </el-form-item>
        <el-form-item label="计量单位" prop="unit">
          <el-input v-model="parameterForm.unit" placeholder="请输入计量单位" />
        </el-form-item>
        <el-form-item label="参数描述" prop="description">
          <el-input
            v-model="parameterForm.description"
            type="textarea"
            placeholder="请输入参数描述"
            :rows="3"
          />
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number
            v-model="parameterForm.sortOrder"
            :min="0"
            :max="999"
            placeholder="请输入排序号"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-switch
            v-model="parameterForm.status"
            :active-value="1"
            :inactive-value="0"
            active-text="启用"
            inactive-text="禁用"
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
const parameterList = ref([])
const searchForm = reactive({
  name: ''
})
const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

// 对话框相关
const showAddDialog = ref(false)
const showDialog = ref(false)
const dialogTitle = ref('')
const saving = ref(false)
const parameterForm = reactive({
  id: null,
  name: '',
  code: '',
  unit: '',
  description: '',
  sortOrder: 0,
  status: 1
})

// 表单验证规则
const formRules = {
  name: [
    { required: true, message: '请输入参数名称', trigger: 'blur' },
    { min: 1, max: 100, message: '参数名称长度在1到100个字符', trigger: 'blur' }
  ],
  code: [
    { required: true, message: '请输入参数编码', trigger: 'blur' },
    { min: 1, max: 50, message: '参数编码长度在1到50个字符', trigger: 'blur' }
  ],
  unit: [
    { required: true, message: '请输入计量单位', trigger: 'blur' },
    { min: 1, max: 20, message: '计量单位长度在1到20个字符', trigger: 'blur' }
  ]
}

// 获取参数列表
const getParameterList = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      name: searchForm.name
    }
    const response = await monitoringApi.getParameterList(params)
    if (response.code === 200) {
      parameterList.value = response.data.list
      pagination.total = response.data.total
    } else {
      ElMessage.error(response.message || '获取参数列表失败')
    }
  } catch (error) {
    ElMessage.error('获取参数列表失败：' + error.message)
  } finally {
    loading.value = false
  }
}

// 重置搜索
const resetSearch = () => {
  searchForm.name = ''
  pagination.pageNum = 1
  getParameterList()
}

// 显示添加对话框
const showAddDialogHandler = () => {
  dialogTitle.value = '添加监测参数'
  resetDialog()
  showAddDialog.value = true
  showDialog.value = true
}

// 编辑参数
const editParameter = async (row) => {
  dialogTitle.value = '编辑监测参数'
  resetDialog()
  showDialog.value = true
  
  try {
    const response = await monitoringApi.getParameterById(row.id)
    if (response.code === 200) {
      Object.assign(parameterForm, response.data)
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
    '此操作将永久删除该参数, 是否继续?',
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
          getParameterList()
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

// 重置对话框
const resetDialog = () => {
  parameterForm.id = null
  parameterForm.name = ''
  parameterForm.code = ''
  parameterForm.unit = ''
  parameterForm.description = ''
  parameterForm.sortOrder = 0
  parameterForm.status = 1
  
  if (parameterFormRef.value) {
    parameterFormRef.value.clearValidate()
  }
}

// 保存参数
const saveParameter = async () => {
  if (!parameterFormRef.value) return
  
  try {
    await parameterFormRef.value.validate()
    saving.value = true
    
    let response
    if (parameterForm.id) {
      response = await monitoringApi.updateParameter(parameterForm)
    } else {
      response = await monitoringApi.addParameter(parameterForm)
    }
    
    if (response.code === 200) {
      ElMessage.success(parameterForm.id ? '更新成功' : '添加成功')
      showDialog.value = false
      getParameterList()
    } else {
      ElMessage.error(response.message || '保存失败')
    }
  } catch (error) {
    if (error.name === 'ValidationError') {
      ElMessage.error('请填写完整表单信息')
    } else {
      ElMessage.error('保存失败：' + error.message)
    }
  } finally {
    saving.value = false
  }
}

// 监听添加对话框显示
onMounted(() => {
  getParameterList()
})

// 表单引用
const parameterFormRef = ref(null)
</script>

<style scoped>
.parameter-list {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>