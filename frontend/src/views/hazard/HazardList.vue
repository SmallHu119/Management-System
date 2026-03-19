<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>隐患管理</span>
        </div>
      </template>

      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="标题">
          <el-input v-model="searchForm.title" placeholder="请输入标题" clearable />
        </el-form-item>
        <el-form-item label="隐患等级">
          <el-select v-model="searchForm.hazardLevel" placeholder="请选择等级" clearable>
            <el-option label="一般" value="一般" />
            <el-option label="较大" value="较大" />
            <el-option label="重大" value="重大" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="待处理" :value="0" />
            <el-option label="处理中" :value="1" />
            <el-option label="已解决" :value="2" />
            <el-option label="已关闭" :value="3" />
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
        <el-table-column prop="title" label="标题" min-width="150" />
        <el-table-column prop="hazardLevel" label="隐患等级" width="100">
          <template #default="{ row }">
            <el-tag :type="getLevelType(row.hazardLevel)">{{ row.hazardLevel }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="location" label="发现位置" width="150" />
        <el-table-column prop="reporterName" label="上报人" width="100" />
        <el-table-column prop="reportTime" label="上报时间" width="180" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ getStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleView(row)">查看</el-button>
            <el-button type="success" link @click="handleProcess(row)" v-if="row.status < 2">
              处理
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

    <!-- 查看详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="隐患详情" width="700px">
      <el-descriptions :column="2" border v-if="currentHazard">
        <el-descriptions-item label="标题" :span="2">{{ currentHazard.title }}</el-descriptions-item>
        <el-descriptions-item label="隐患等级">
          <el-tag :type="getLevelType(currentHazard.hazardLevel)">{{ currentHazard.hazardLevel }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="getStatusType(currentHazard.status)">{{ getStatusText(currentHazard.status) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="发现位置">{{ currentHazard.location }}</el-descriptions-item>
        <el-descriptions-item label="上报人">{{ currentHazard.reporterName }}</el-descriptions-item>
        <el-descriptions-item label="上报时间" :span="2">{{ currentHazard.reportTime }}</el-descriptions-item>
        <el-descriptions-item label="隐患描述" :span="2">
          <div class="detail-content">{{ currentHazard.description }}</div>
        </el-descriptions-item>
        <el-descriptions-item label="现场图片" :span="2" v-if="currentHazard.images">
          <el-image
            v-for="(img, index) in currentHazard.images.split(',')"
            :key="index"
            :src="img"
            :preview-src-list="currentHazard.images.split(',')"
            style="width: 100px; height: 100px; margin-right: 10px"
            fit="cover"
          />
        </el-descriptions-item>
        <template v-if="currentHazard.status >= 2">
          <el-descriptions-item label="处理人">{{ currentHazard.handlerName }}</el-descriptions-item>
          <el-descriptions-item label="处理时间">{{ currentHazard.handleTime }}</el-descriptions-item>
          <el-descriptions-item label="处理结果" :span="2">
            <div class="detail-content">{{ currentHazard.handleResult }}</div>
          </el-descriptions-item>
        </template>
      </el-descriptions>
    </el-dialog>

    <!-- 处理对话框 -->
    <el-dialog v-model="processDialogVisible" title="处理隐患" width="500px" destroy-on-close>
      <el-form ref="processFormRef" :model="processForm" :rules="processRules" label-width="100px">
        <el-form-item label="处理结果" prop="handleResult">
          <el-input v-model="processForm.handleResult" type="textarea" :rows="4" placeholder="请输入处理结果" />
        </el-form-item>
        <el-form-item label="处理状态" prop="status">
          <el-select v-model="processForm.status" style="width: 100%">
            <el-option label="处理中" :value="1" />
            <el-option label="已解决" :value="2" />
            <el-option label="已关闭" :value="3" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="processDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitProcess" :loading="processLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { hazardApi } from '@/api'

const loading = ref(false)
const tableData = ref([])

const searchForm = reactive({
  title: '',
  hazardLevel: '',
  status: null
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

const detailDialogVisible = ref(false)
const currentHazard = ref(null)

const processDialogVisible = ref(false)
const processLoading = ref(false)
const processFormRef = ref(null)
const processForm = reactive({
  id: null,
  handleResult: '',
  status: 2
})

const processRules = {
  handleResult: [{ required: true, message: '请输入处理结果', trigger: 'blur' }],
  status: [{ required: true, message: '请选择处理状态', trigger: 'change' }]
}

const getLevelType = (level) => {
  const map = { '一般': 'info', '较大': 'warning', '重大': 'danger' }
  return map[level] || 'info'
}

const getStatusType = (status) => {
  const map = { 0: 'info', 1: 'warning', 2: 'success', 3: 'default' }
  return map[status] || 'info'
}

const getStatusText = (status) => {
  const map = { 0: '待处理', 1: '处理中', 2: '已解决', 3: '已关闭' }
  return map[status] || '未知'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await hazardApi.getHazardList({
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
  searchForm.hazardLevel = ''
  searchForm.status = null
  handleSearch()
}

const handleView = (row) => {
  currentHazard.value = row
  detailDialogVisible.value = true
}

const handleProcess = (row) => {
  processForm.id = row.id
  processForm.handleResult = ''
  processForm.status = 2
  processDialogVisible.value = true
}

const handleSubmitProcess = async () => {
  await processFormRef.value.validate()
  processLoading.value = true
  try {
    await hazardApi.handleHazard(processForm.id, {
      handleResult: processForm.handleResult,
      status: processForm.status
    })
    ElMessage.success('处理成功')
    processDialogVisible.value = false
    loadData()
  } catch (error) {
    console.error(error)
  } finally {
    processLoading.value = false
  }
}

const handleDelete = async (row) => {
  try {
    await hazardApi.deleteHazard(row.id)
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
