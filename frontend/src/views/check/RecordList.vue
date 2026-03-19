<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>检查记录</span>
        </div>
      </template>

      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="记录标题">
          <el-input v-model="searchForm.title" placeholder="请输入记录标题" clearable />
        </el-form-item>
        <el-form-item label="审核状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="待审核" :value="0" />
            <el-option label="已通过" :value="1" />
            <el-option label="已驳回" :value="2" />
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
        <el-table-column prop="title" label="记录标题" min-width="150" />
        <el-table-column prop="checkDate" label="检查日期" width="120" />
        <el-table-column prop="checkerName" label="检查人" width="100" />
        <el-table-column prop="checkResult" label="检查结果" width="120">
          <template #default="{ row }">
            <el-tag :type="getResultType(row.checkResult)">{{ row.checkResult }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="审核状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ getStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleView(row)">查看</el-button>
            <template v-if="userStore.isAdmin && row.status === 0">
              <el-button type="success" link @click="handleAudit(row, 1)">通过</el-button>
              <el-button type="danger" link @click="handleAudit(row, 2)">驳回</el-button>
            </template>
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

    <!-- 查看详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="检查记录详情" width="600px">
      <el-descriptions :column="2" border v-if="currentRecord">
        <el-descriptions-item label="记录标题" :span="2">{{ currentRecord.title }}</el-descriptions-item>
        <el-descriptions-item label="检查日期">{{ currentRecord.checkDate }}</el-descriptions-item>
        <el-descriptions-item label="检查人">{{ currentRecord.checkerName }}</el-descriptions-item>
        <el-descriptions-item label="检查结果">
          <el-tag :type="getResultType(currentRecord.checkResult)">{{ currentRecord.checkResult }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="审核状态">
          <el-tag :type="getStatusType(currentRecord.status)">{{ getStatusText(currentRecord.status) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="问题描述" :span="2">
          <div class="detail-content">{{ currentRecord.problemDescription || '无' }}</div>
        </el-descriptions-item>
        <el-descriptions-item label="整改建议" :span="2">
          <div class="detail-content">{{ currentRecord.rectificationSuggestion || '无' }}</div>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ currentRecord.createTime }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ currentRecord.updateTime }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
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

const detailDialogVisible = ref(false)
const currentRecord = ref(null)

const getResultType = (result) => {
  const map = { '正常': 'success', '存在隐患': 'warning', '严重问题': 'danger' }
  return map[result] || 'info'
}

const getStatusType = (status) => {
  const map = { 0: 'info', 1: 'success', 2: 'danger' }
  return map[status] || 'info'
}

const getStatusText = (status) => {
  const map = { 0: '待审核', 1: '已通过', 2: '已驳回' }
  return map[status] || '未知'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await checkApi.getRecordList({
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

const handleView = (row) => {
  currentRecord.value = row
  detailDialogVisible.value = true
}

const handleAudit = async (row, status) => {
  const action = status === 1 ? '通过' : '驳回'
  try {
    await ElMessageBox.confirm(`确定要${action}这条检查记录吗？`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await checkApi.auditRecord(row.id, status)
    ElMessage.success(`${action}成功`)
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}

const handleDelete = async (row) => {
  try {
    await checkApi.deleteRecord(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    console.error(error)
  }
}

onMounted(() => {
  loadData()
})
</script>

<style lang="scss" scoped>
.detail-content {
  white-space: pre-wrap;
  line-height: 1.6;
}
</style>
