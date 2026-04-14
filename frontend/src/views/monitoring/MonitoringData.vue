<template>
  <div class="monitoring-data-list">
    <el-page-header @back="$router.go(-1)" content="实时监测数据" />
    
    <el-card>
      <template #header>
        <div class="card-header">
          <span>实时监测数据</span>
          <div class="header-buttons">
            <el-button type="primary" @click="openAddDialog" icon="Plus">
              添加数据
            </el-button>
            <el-button @click="refreshData" icon="Refresh">
              刷新
            </el-button>
          </div>
        </div>
      </template>
      
      <el-form :model="searchForm" inline @submit.prevent="getMonitoringData">
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
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="正常" :value="0" />
            <el-option label="预警" :value="1" />
            <el-option label="报警" :value="2" />
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围">
          <el-date-picker
            v-model="dateRange"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            :default-time="['00:00:00', '23:59:59']"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="getMonitoringData" icon="Search">
            搜索
          </el-button>
          <el-button @click="resetSearch" icon="Refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
      
      <!-- 统计卡片 -->
      <el-row :gutter="20" style="margin-bottom: 20px">
        <el-col :span="6">
          <el-card class="stat-card">
            <template #header>
              <span>今日监测数据</span>
            </template>
            <div class="stat-content">
              <el-icon class="stat-icon"><data-analysis /></el-icon>
              <div class="stat-number">{{ todayStats.totalData }}</div>
              <div class="stat-desc">今日新增{{ todayStats.newData }}条</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card warning">
            <template #header>
              <span>预警记录</span>
            </template>
            <div class="stat-content">
              <el-icon class="stat-icon"><warning /></el-icon>
              <div class="stat-number">{{ todayStats.warningCount }}</div>
              <div class="stat-desc">今日新增{{ todayStats.newWarning }}条</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card danger">
            <template #header>
              <span>报警记录</span>
            </template>
            <div class="stat-content">
              <el-icon class="stat-icon"><warning-filled /></el-icon>
              <div class="stat-number">{{ todayStats.alertCount }}</div>
              <div class="stat-desc">今日新增{{ todayStats.newAlert }}条</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card class="stat-card success">
            <template #header>
              <span>正常率</span>
            </template>
            <div class="stat-content">
              <el-icon class="stat-icon"><check /></el-icon>
              <div class="stat-number">{{ todayStats.normalRate }}%</div>
              <div class="stat-desc">较昨日{{ todayStats.rateChange > 0 ? '↑' : '↓' }}{{ Math.abs(todayStats.rateChange) }}%</div>
            </div>
          </el-card>
        </el-col>
      </el-row>
      
      <el-table
        v-loading="loading"
        :data="monitoringData"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column prop="hazmatName" label="危化品名称" min-width="150" />
        <el-table-column prop="paramName" label="参数名称" min-width="120" />
        <el-table-column prop="paramValue" label="参数值" min-width="120" align="right">
          <template #default="scope">
            <span style="font-weight: bold;">
              {{ scope.row.paramValue }}
              <span style="font-weight: normal; margin-left: 5px;">
                {{ scope.row.paramUnit }}
              </span>
            </span>
          </template>
        </el-table-column>
        <el-table-column
          prop="status"
          label="状态"
          width="100"
          align="center"
        >
          <template #default="scope">
            <el-tag :type="getStatusTagType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="dataSource" label="数据来源" width="120" align="center" />
        <el-table-column prop="location" label="监测位置" min-width="150" />
        <el-table-column prop="monitorTime" label="监测时间" width="180" align="center" />
        <el-table-column label="操作" width="180" align="center">
          <template #default="scope">
            <el-button
              size="small"
              icon="Edit"
              @click="editMonitoringData(scope.row)"
              type="primary"
            >
              编辑
            </el-button>
            <el-button
              size="small"
              icon="Delete"
              @click="deleteMonitoringData(scope.row.id)"
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
        @size-change="getMonitoringData"
        @current-change="getMonitoringData"
      />
    </el-card>
    
    <!-- 趋势图卡片 -->
    <el-card style="margin-top: 20px">
      <template #header>
        <span>数据趋势分析</span>
      </template>
      
      <el-form :model="chartForm" inline style="margin-bottom: 20px">
        <el-form-item label="危化品">
          <el-select v-model="chartForm.hazmatId" placeholder="请选择危化品" @change="getTrendData">
            <el-option
              v-for="hazmat in hazmatList"
              :key="hazmat.id"
              :label="hazmat.name"
              :value="hazmat.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="参数">
          <el-select v-model="chartForm.paramId" placeholder="请选择参数" @change="getTrendData">
            <el-option
              v-for="param in parameterList"
              :key="param.id"
              :label="param.name"
              :value="param.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围">
          <el-select v-model="chartForm.timeRange" placeholder="请选择时间范围" @change="getTrendData">
            <el-option label="近6小时" value="6h" />
            <el-option label="近12小时" value="12h" />
            <el-option label="近24小时" value="24h" />
            <el-option label="近7天" value="7d" />
            <el-option label="近30天" value="30d" />
          </el-select>
        </el-form-item>
      </el-form>
      
      <div id="trendChart" style="height: 400px;"></div>
    </el-card>
    
    <!-- 添加/编辑数据对话框 -->
    <el-dialog
      v-model="showDialog"
      :title="dialogTitle"
      width="500px"
      @close="resetDialog"
    >
      <el-form
        ref="dataFormRef"
        :model="dataForm"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item label="危化品" prop="hazmatId">
          <el-select v-model="dataForm.hazmatId" placeholder="请选择危化品" clearable>
            <el-option
              v-for="hazmat in hazmatList"
              :key="hazmat.id"
              :label="hazmat.name"
              :value="hazmat.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="监测参数" prop="paramId">
          <el-select v-model="dataForm.paramId" placeholder="请选择监测参数" clearable>
            <el-option
              v-for="param in parameterList"
              :key="param.id"
              :label="param.name"
              :value="param.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="参数值" prop="paramValue">
          <el-input-number
            v-model="dataForm.paramValue"
            :min="0"
            :max="999999"
            :precision="2"
            placeholder="请输入参数值"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="数据来源" prop="dataSource">
          <el-select v-model="dataForm.dataSource" placeholder="请选择数据来源">
            <el-option label="传感器" value="传感器" />
            <el-option label="手动录入" value="手动录入" />
            <el-option label="外部接口" value="外部接口" />
          </el-select>
        </el-form-item>
        <el-form-item label="监测位置" prop="location">
          <el-input v-model="dataForm.location" placeholder="请输入监测位置" />
        </el-form-item>
        <el-form-item label="监测时间" prop="monitorTime">
          <el-date-picker
            v-model="dataForm.monitorTime"
            type="datetime"
            placeholder="请选择监测时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showDialog = false">取消</el-button>
        <el-button type="primary" @click="saveData" :loading="saving">
          {{ saving ? '保存中...' : '保存' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, onBeforeUnmount } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { monitoringApi, hazmatApi } from '@/api'
import { DataAnalysis, Warning, WarningFilled, Check } from '@element-plus/icons-vue'
import * as echarts from 'echarts'

const loading = ref(false)
const monitoringData = ref([])
const hazmatList = ref([])
const parameterList = ref([])
const searchForm = reactive({
  hazmatId: null,
  paramId: null,
  status: null
})
const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})
const dateRange = ref([])
const todayStats = reactive({
  totalData: 0,
  newData: 0,
  warningCount: 0,
  newWarning: 0,
  alertCount: 0,
  newAlert: 0,
  normalRate: 100,
  rateChange: 0
})

// 图表相关
let trendChart = null
const chartForm = reactive({
  hazmatId: null,
  paramId: null,
  timeRange: '24h'
})
const chartData = reactive({
  xData: [],
  yData: [],
  warningMin: null,
  warningMax: null,
  normalMin: null,
  normalMax: null
})

// 对话框相关
const showDialog = ref(false)
const dialogTitle = ref('')
const saving = ref(false)
const dataForm = reactive({
  id: null,
  hazmatId: null,
  paramId: null,
  paramValue: null,
  dataSource: '',
  location: '',
  monitorTime: ''
})

// 表单引用 - 必须在使用前声明
const dataFormRef = ref(null)

// 打开添加对话框
const openAddDialog = () => {
  dialogTitle.value = '添加监测数据'
  resetDialog()
  showDialog.value = true
}

// 表单验证规则
const formRules = {
  hazmatId: [
    { required: true, message: '请选择危化品', trigger: 'change' }
  ],
  paramId: [
    { required: true, message: '请选择监测参数', trigger: 'change' }
  ],
  paramValue: [
    { required: true, message: '请输入参数值', trigger: 'blur' },
    { min: 0, message: '参数值不能为负数', trigger: 'blur' }
  ],
  dataSource: [
    { required: true, message: '请选择数据来源', trigger: 'change' }
  ],
  monitorTime: [
    { required: true, message: '请选择监测时间', trigger: 'change' }
  ]
}

// 获取状态标签类型
const getStatusTagType = (status) => {
  switch (status) {
    case 0:
      return 'success'
    case 1:
      return 'warning'
    case 2:
      return 'danger'
    default:
      return 'info'
  }
}

// 获取状态文本
const getStatusText = (status) => {
  switch (status) {
    case 0:
      return '正常'
    case 1:
      return '预警'
    case 2:
      return '报警'
    default:
      return '未知'
  }
}

// 获取监测数据
const getMonitoringData = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      hazmatId: searchForm.hazmatId,
      paramId: searchForm.paramId,
      status: searchForm.status,
      startTime: dateRange.value[0],
      endTime: dateRange.value[1]
    }
    const response = await monitoringApi.getMonitoringData(params)
    if (response.code === 200) {
      const list = response.data.list || []
      // 补全危化品名称和参数名称（后端未关联查询时前端兜底）
      monitoringData.value = list.map(item => ({
        ...item,
        hazmatName: item.hazmatName || hazmatList.value.find(h => h.id === item.hazmatId)?.name || `危化品#${item.hazmatId}`,
        paramName: item.paramName || parameterList.value.find(p => p.id === item.paramId)?.name || `参数#${item.paramId}`,
        paramUnit: item.paramUnit || parameterList.value.find(p => p.id === item.paramId)?.unit || ''
      }))
      pagination.total = response.data.total
    } else {
      ElMessage.error(response.message || '获取监测数据失败')
    }
  } catch (error) {
    ElMessage.error('获取监测数据失败：' + error.message)
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
    } else {
      ElMessage.error(response.message || '获取危化品列表失败')
    }
  } catch (error) {
    ElMessage.error('获取危化品列表失败：' + error.message)
  }
}

// 获取监测参数列表
const getParameterList = async () => {
  try {
    const response = await monitoringApi.getAllParameters()
    if (response.code === 200) {
      parameterList.value = response.data
    } else {
      ElMessage.error(response.message || '获取监测参数列表失败')
    }
  } catch (error) {
    ElMessage.error('获取监测参数列表失败：' + error.message)
  }
}

// 获取统计数据
const getStatistics = async () => {
  try {
    const response = await monitoringApi.getMonitoringStatistics()
    if (response.code === 200) {
      Object.assign(todayStats, response.data)
    } else {
      ElMessage.error(response.message || '获取统计数据失败')
    }
  } catch (error) {
    ElMessage.error('获取统计数据失败：' + error.message)
  }
}

// 刷新数据
const refreshData = () => {
  getMonitoringData()
  getStatistics()
  getTrendData()
  ElMessage.success('数据已刷新')
}

// 重置搜索
const resetSearch = () => {
  searchForm.hazmatId = null
  searchForm.paramId = null
  searchForm.status = null
  dateRange.value = []
  pagination.pageNum = 1
  getMonitoringData()
}

// 编辑监测数据
const editMonitoringData = async (row) => {
  dialogTitle.value = '编辑监测数据'
  resetDialog()
  showDialog.value = true
  
  try {
    const response = await monitoringApi.getMonitoringDataById(row.id)
    if (response.code === 200) {
      Object.assign(dataForm, response.data)
    } else {
      ElMessage.error(response.message || '获取数据详情失败')
    }
  } catch (error) {
    ElMessage.error('获取数据详情失败：' + error.message)
  }
}

// 删除监测数据
const deleteMonitoringData = (id) => {
  ElMessageBox.confirm(
    '此操作将永久删除该数据记录, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  )
    .then(async () => {
      try {
        const response = await monitoringApi.deleteMonitoringData(id)
        if (response.code === 200) {
          ElMessage.success('删除成功!')
          getMonitoringData()
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
  dataForm.id = null
  dataForm.hazmatId = null
  dataForm.paramId = null
  dataForm.paramValue = null
  dataForm.dataSource = ''
  dataForm.location = ''
  dataForm.monitorTime = ''
  
  if (dataFormRef.value) {
    dataFormRef.value.clearValidate()
  }
}

// 保存数据
const saveData = async () => {
  if (!dataFormRef.value) return
  
  try {
    await dataFormRef.value.validate()
    saving.value = true
    
    let response
    if (dataForm.id) {
      response = await monitoringApi.updateMonitoringData(dataForm)
    } else {
      response = await monitoringApi.addMonitoringData(dataForm)
    }
    
    if (response.code === 200) {
      ElMessage.success(dataForm.id ? '更新成功' : '添加成功')
      showDialog.value = false
      getMonitoringData()
      getTrendData()
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

// 获取趋势数据
const getTrendData = async () => {
  if (!chartForm.hazmatId || !chartForm.paramId) return
  
  try {
    const response = await monitoringApi.getMonitoringTrend(chartForm.hazmatId, chartForm.paramId, chartForm.timeRange)
    if (response.code === 200) {
      chartData.xData = response.data.xData
      chartData.yData = response.data.yData
      chartData.warningMin = response.data.warningMin
      chartData.warningMax = response.data.warningMax
      chartData.normalMin = response.data.normalMin
      chartData.normalMax = response.data.normalMax
      
      updateChart()
    } else {
      ElMessage.error(response.message || '获取趋势数据失败')
    }
  } catch (error) {
    ElMessage.error('获取趋势数据失败：' + error.message)
  }
}

// 初始化图表
const initChart = () => {
  trendChart = echarts.init(document.getElementById('trendChart'))
  
  const option = {
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['参数值', '预警下限', '预警上限', '正常范围']
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: []
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        name: '参数值',
        type: 'line',
        smooth: true,
        data: [],
        lineStyle: { color: '#409EFF' },
        areaStyle: {
          color: {
            type: 'linear', x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(64, 158, 255, 0.5)' },
              { offset: 1, color: 'rgba(64, 158, 255, 0.1)' }
            ]
          }
        }
      },
      {
        name: '预警下限',
        type: 'line',
        data: [],
        lineStyle: { color: '#F56C6C', type: 'dashed' }
      },
      {
        name: '预警上限',
        type: 'line',
        data: [],
        lineStyle: { color: '#F56C6C', type: 'dashed' }
      },
      {
        name: '正常范围',
        type: 'line',
        data: [],
        lineStyle: { color: '#67C23A', type: 'dashed' }
      }
    ]
  }
  
  trendChart.setOption(option)
}

// 更新图表
const updateChart = () => {
  if (!trendChart) return
  
  const warningMinData = chartData.xData.map(() => chartData.warningMin)
  const warningMaxData = chartData.xData.map(() => chartData.warningMax)
  const normalRangeData = chartData.xData.map(() => chartData.normalMax)
  
  const option = {
    xAxis: { data: chartData.xData },
    series: [
      { data: chartData.yData },
      { data: warningMinData },
      { data: warningMaxData },
      { data: normalRangeData }
    ]
  }
  
  trendChart.setOption(option)
}

// 窗口大小变化时重置图表
const resizeChart = () => {
  if (trendChart) {
    trendChart.resize()
  }
}

onMounted(async () => {
  await Promise.all([getHazmatList(), getParameterList()])
  getMonitoringData()
  getStatistics()
  initChart()
  window.addEventListener('resize', resizeChart)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeChart)
  if (trendChart) {
    trendChart.dispose()
  }
})
</script>

<style scoped>
.monitoring-data-list {
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
.stat-card {
  transition: all 0.3s;
}
.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 20px rgba(0, 0, 0, 0.1);
}
.stat-card.warning {
  border-top: 4px solid #E6A23C;
}
.stat-card.danger {
  border-top: 4px solid #F56C6C;
}
.stat-card.success {
  border-top: 4px solid #67C23A;
}
.stat-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 120px;
}
.stat-icon {
  font-size: 40px;
  margin-bottom: 10px;
  color: #409EFF;
}
.stat-card.warning .stat-icon { color: #E6A23C; }
.stat-card.danger .stat-icon { color: #F56C6C; }
.stat-card.success .stat-icon { color: #67C23A; }
.stat-number {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 5px;
  color: #303133;
}
.stat-desc {
  font-size: 14px;
  color: #909399;
}
</style>
