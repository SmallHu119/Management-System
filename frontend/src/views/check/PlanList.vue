<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>检查计划</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon> 添加计划
          </el-button>
        </div>
      </template>

      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="计划标题">
          <el-input v-model="searchForm.title" placeholder="请输入计划标题" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="待执行" :value="0" />
            <el-option label="进行中" :value="1" />
            <el-option label="已完成" :value="2" />
            <el-option label="已取消" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon> 搜索
          </el-button>
          <el-button @click="handleReset">
            <el-icon><Refresh /></el-icon> 重置
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table :data="tableData" v-loading="loading" stripe>
        <el-table-column prop="title" label="计划标题" min-width="150" />
        <el-table-column prop="checkArea" label="检查区域" width="150" />
        <el-table-column prop="planDate" label="计划日期" width="120" />
        <el-table-column prop="checkerName" label="检查人" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ getStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="success" link @click="handleAddRecord(row)" v-if="row.status !== 2">
              添加记录
            </el-button>
            <el-popconfirm title="确定要删除吗？" @confirm="handleDelete(row)">
              <template #reference>
                <el-button type="danger" link>删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="pagination.pageNum"
          v-model:page-size="pagination.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="pagination.total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="loadData"
          @current-change="loadData"
        />
      </div>
    </el-card>

    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="计划标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入计划标题" />
        </el-form-item>
        <el-form-item label="检查区域" prop="checkArea">
          <el-input v-model="form.checkArea" placeholder="请输入检查区域" />
        </el-form-item>
        <el-form-item label="计划日期" prop="planDate">
          <el-date-picker v-model="form.planDate" type="date" value-format="YYYY-MM-DD" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="检查人">
          <el-input v-model="form.checkerName" placeholder="请输入检查人姓名" />
        </el-form-item>
        <el-form-item label="检查内容">
          <el-input v-model="form.checkContent" type="textarea" :rows="3" placeholder="请输入检查内容" />
        </el-form-item>
        <el-form-item label="状态" v-if="form.id">
          <el-select v-model="form.status" style="width: 100%">
            <el-option label="待执行" :value="0" />
            <el-option label="进行中" :value="1" />
            <el-option label="已完成" :value="2" />
            <el-option label="已取消" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>

    <!-- 添加检查记录对话框 -->
    <el-dialog v-model="recordDialogVisible" title="添加检查记录" width="600px" destroy-on-close>
      <el-form ref="recordFormRef" :model="recordForm" :rules="recordRules" label-width="100px">
        <el-form-item label="关联计划">
          <el-input :value="currentPlan?.title" disabled />
        </el-form-item>
        <el-form-item label="记录标题" prop="title">
          <el-input v-model="recordForm.title" placeholder="请输入记录标题" />
        </el-form-item>
        <el-form-item label="检查日期" prop="checkDate">
          <el-date-picker v-model="recordForm.checkDate" type="date" value-format="YYYY-MM-DD" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="检查结果" prop="checkResult">
          <el-select v-model="recordForm.checkResult" style="width: 100%">
            <el-option label="正常" value="正常" />
            <el-option label="存在隐患" value="存在隐患" />
            <el-option label="严重问题" value="严重问题" />
          </el-select>
        </el-form-item>
        <el-form-item label="问题描述">
          <el-input v-model="recordForm.problemDescription" type="textarea" :rows="3" placeholder="请描述发现的问题" />
        </el-form-item>
        <el-form-item label="整改建议">
          <el-input v-model="recordForm.rectificationSuggestion" type="textarea" :rows="3" placeholder="请输入整改建议" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="recordDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitRecord" :loading="recordSubmitLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { checkApi } from '@/api'

const userStore = useUserStore()

const loading = ref(false)
const tableData = ref([])

const searchForm = reactive({
  title: '',
  status: null
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

// 计划对话框
const dialogVisible = ref(false)
const dialogTitle = ref('')
const submitLoading = ref(false)
const formRef = ref(null)

const form = reactive({
  id: null,
  title: '',
  checkArea: '',
  planDate: '',
  checkerId: null,
  checkerName: '',
  checkContent: '',
  status: 0,
  remark: ''
})

const rules = {
  title: [{ required: true, message: '请输入计划标题', trigger: 'blur' }],
  checkArea: [{ required: true, message: '请输入检查区域', trigger: 'blur' }],
  planDate: [{ required: true, message: '请选择计划日期', trigger: 'change' }]
}

// 记录对话框
const recordDialogVisible = ref(false)
const recordSubmitLoading = ref(false)
const recordFormRef = ref(null)
const currentPlan = ref(null)

const recordForm = reactive({
  planId: null,
  title: '',
  checkDate: '',
  checkResult: '',
  problemDescription: '',
  rectificationSuggestion: ''
})

const recordRules = {
  title: [{ required: true, message: '请输入记录标题', trigger: 'blur' }],
  checkDate: [{ required: true, message: '请选择检查日期', trigger: 'change' }],
  checkResult: [{ required: true, message: '请选择检查结果', trigger: 'change' }]
}

const getStatusType = (status) => {
  const map = { 0: 'info', 1: 'warning', 2: 'success', 3: 'danger' }
  return map[status] || 'info'
}

const getStatusText = (status) => {
  const map = { 0: '待执行', 1: '进行中', 2: '已完成', 3: '已取消' }
  return map[status] || '未知'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await checkApi.getPlanList({
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      ...searchForm
    })
    tableData.value = res.data.records || []
    pagination.total = res.data.total || 0
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  pagination.pageNum = 1
  loadData()
}

const handleReset = () => {
  searchForm.title = ''
  searchForm.status = null
  handleSearch()
}

const handleAdd = () => {
  dialogTitle.value = '添加检查计划'
  Object.keys(form).forEach(key => {
    form[key] = key === 'status' ? 0 : (key === 'id' || key === 'checkerId' ? null : '')
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑检查计划'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  await formRef.value.validate()
  submitLoading.value = true
  try {
    if (form.id) {
      await checkApi.updatePlan(form)
      ElMessage.success('更新成功')
    } else {
      await checkApi.addPlan(form)
      ElMessage.success('添加成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (error) {
    console.error(error)
  } finally {
    submitLoading.value = false
  }
}

const handleDelete = async (row) => {
  try {
    await checkApi.deletePlan(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    console.error(error)
  }
}

const handleAddRecord = (plan) => {
  currentPlan.value = plan
  recordForm.planId = plan.id
  recordForm.title = `${plan.title} - 检查记录`
  recordForm.checkDate = ''
  recordForm.checkResult = ''
  recordForm.problemDescription = ''
  recordForm.rectificationSuggestion = ''
  recordDialogVisible.value = true
}

const handleSubmitRecord = async () => {
  await recordFormRef.value.validate()
  recordSubmitLoading.value = true
  try {
    await checkApi.addRecord({
      ...recordForm,
      checkerId: userStore.userId,
      checkerName: userStore.realName || userStore.username
    })
    ElMessage.success('添加成功')
    recordDialogVisible.value = false
    // 更新计划状态为进行中
    if (currentPlan.value.status === 0) {
      await checkApi.updatePlanStatus(currentPlan.value.id, 1)
      loadData()
    }
  } catch (error) {
    console.error(error)
  } finally {
    recordSubmitLoading.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>
