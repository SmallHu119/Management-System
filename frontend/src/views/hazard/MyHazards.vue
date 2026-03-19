<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>我的上报记录</span>
          <el-button type="primary" @click="$router.push('/hazard/report')">
            <el-icon><Plus /></el-icon> 上报隐患
          </el-button>
        </div>
      </template>

      <!-- 数据表格 -->
      <el-table :data="tableData" v-loading="loading" stripe>
        <el-table-column prop="title" label="标题" min-width="150" />
        <el-table-column prop="hazardLevel" label="隐患等级" width="100">
          <template #default="{ row }">
            <el-tag :type="getLevelType(row.hazardLevel)">{{ row.hazardLevel }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="location" label="发现位置" width="150" />
        <el-table-column prop="reportTime" label="上报时间" width="180" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">{{ getStatusText(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleView(row)">查看</el-button>
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
        <el-descriptions-item label="发现位置" :span="2">{{ currentHazard.location }}</el-descriptions-item>
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
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { hazardApi } from '@/api'

const loading = ref(false)
const tableData = ref([])

const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

const detailDialogVisible = ref(false)
const currentHazard = ref(null)

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
    const res = await hazardApi.getMyHazards({
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize
    })
    tableData.value = res.data.records || []
    pagination.total = res.data.total || 0
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const handleView = (row) => {
  currentHazard.value = row
  detailDialogVisible.value = true
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
