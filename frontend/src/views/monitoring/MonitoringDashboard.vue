<template>
  <div class="monitoring-dashboard">
    <el-page-header @back="$router.go(-1)" content="监测预警概览" />
    
    <!-- 统计卡片 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon-wrapper" style="background: rgba(64, 158, 255, 0.1)">
              <el-icon :size="28" color="#409EFF"><DataAnalysis /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics.monitoringCount }}</div>
              <div class="stat-label">监测数据总量</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon-wrapper" style="background: rgba(230, 162, 60, 0.1)">
              <el-icon :size="28" color="#E6A23C"><Warning /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics.pendingWarnings }}</div>
              <div class="stat-label">待处理预警</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon-wrapper" style="background: rgba(103, 194, 58, 0.1)">
              <el-icon :size="28" color="#67C23A"><Check /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics.normalRate }}%</div>
              <div class="stat-label">正常率</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon-wrapper" style="background: rgba(245, 108, 108, 0.1)">
              <el-icon :size="28" color="#F56C6C"><WarningFilled /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics.activeRules }}</div>
              <div class="stat-label">活跃预警规则</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 图表区域 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>预警趋势</span>
              <el-select v-model="trendRange" size="small" @change="loadTrendData" style="width: 120px">
                <el-option label="近7天" value="7d" />
                <el-option label="近30天" value="30d" />
              </el-select>
            </div>
          </template>
          <div id="trendChart" style="height: 350px;"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>危化品预警排名</span>
            </div>
          </template>
          <div id="rankChart" style="height: 350px;"></div>
        </el-card>
      </el-col>
    </el-row>
    
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>参数预警分布</span>
            </div>
          </template>
          <div id="paramChart" style="height: 350px;"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>预警级别分布</span>
            </div>
          </template>
          <div id="levelChart" style="height: 350px;"></div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 最新预警记录 -->
    <el-card shadow="hover" style="margin-top: 20px">
      <template #header>
        <div class="card-header">
          <span>最新预警记录</span>
          <el-button type="primary" link @click="$router.push('/monitoring/warning-records')">
            查看更多
          </el-button>
        </div>
      </template>
      <el-table
        v-loading="loadingWarnings"
        :data="latestWarnings"
        stripe
        style="width: 100%"
      >
        <el-table-column prop="hazmatName" label="危化品名称" min-width="150" />
        <el-table-column prop="paramName" label="参数名称" min-width="120" />
        <el-table-column prop="warningLevel" label="预警级别" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getLevelTagType(scope.row.warningLevel)" size="small">
              {{ getLevelText(scope.row.warningLevel) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="warningValue" label="预警值" min-width="100" align="right">
          <template #default="scope">
            {{ scope.row.warningValue }}
            <span style="margin-left: 5px; color: #909399;">{{ scope.row.paramUnit }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="处理状态" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getStatusTagType(scope.row.status)" size="small">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="warningTime" label="预警时间" width="180" align="center" />
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, onBeforeUnmount } from 'vue'
import { ElMessage } from 'element-plus'
import { monitoringApi } from '@/api'
import { DataAnalysis, Warning, WarningFilled, Check } from '@element-plus/icons-vue'
import * as echarts from 'echarts'

const statistics = reactive({
  monitoringCount: 0,
  pendingWarnings: 0,
  normalRate: 100,
  activeRules: 0
})
const trendRange = ref('7d')
const loadingWarnings = ref(false)
const latestWarnings = ref([])

let trendChart = null
let rankChart = null
let paramChart = null
let levelChart = null

// 获取统计概览数据
const loadStatistics = async () => {
  try {
    const response = await monitoringApi.getMonitoringStatistics()
    if (response.code === 200) {
      Object.assign(statistics, response.data)
    }
  } catch (error) {
    ElMessage.error('获取统计数据失败：' + error.message)
  }
}

// 获取最新预警记录
const loadLatestWarnings = async () => {
  loadingWarnings.value = true
  try {
    const response = await monitoringApi.getWarningRecords({
      pageNum: 1,
      pageSize: 10
    })
    if (response.code === 200) {
      latestWarnings.value = response.data.list || []
    }
  } catch (error) {
    ElMessage.error('获取预警记录失败：' + error.message)
  } finally {
    loadingWarnings.value = false
  }
}

// 加载预警趋势数据
const loadTrendData = async () => {
  try {
    const response = await monitoringApi.getWarningTrend(trendRange.value)
    if (response.code === 200) {
      updateTrendChart(response.data)
    }
  } catch (error) {
    ElMessage.error('获取趋势数据失败：' + error.message)
  }
}

// 初始化趋势图表
const initTrendChart = () => {
  trendChart = echarts.init(document.getElementById('trendChart'))
  const option = {
    tooltip: { trigger: 'axis' },
    legend: { data: ['预警数', '已处理'] },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'category', boundaryGap: false, data: [] },
    yAxis: { type: 'value' },
    series: [
      {
        name: '预警数',
        type: 'line',
        smooth: true,
        data: [],
        lineStyle: { color: '#E6A23C' },
        areaStyle: {
          color: {
            type: 'linear', x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(230, 162, 60, 0.4)' },
              { offset: 1, color: 'rgba(230, 162, 60, 0.05)' }
            ]
          }
        }
      },
      {
        name: '已处理',
        type: 'line',
        smooth: true,
        data: [],
        lineStyle: { color: '#67C23A' },
        areaStyle: {
          color: {
            type: 'linear', x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(103, 194, 58, 0.4)' },
              { offset: 1, color: 'rgba(103, 194, 58, 0.05)' }
            ]
          }
        }
      }
    ]
  }
  trendChart.setOption(option)
}

// 更新趋势图表
const updateTrendChart = (data) => {
  if (!trendChart) return
  trendChart.setOption({
    xAxis: { data: data.xData || [] },
    series: [
      { data: data.warningCount || [] },
      { data: data.handledCount || [] }
    ]
  })
}

// 初始化危化品排名图表
const initRankChart = async () => {
  rankChart = echarts.init(document.getElementById('rankChart'))
  try {
    const response = await monitoringApi.getHazmatRank()
    if (response.code === 200) {
      const data = response.data || []
      rankChart.setOption({
        tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
        grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
        xAxis: { type: 'value' },
        yAxis: {
          type: 'category',
          data: data.map(item => item.name),
          inverse: true
        },
        series: [{
          type: 'bar',
          data: data.map(item => ({
            value: item.count,
            itemStyle: {
              color: {
                type: 'linear', x: 0, y: 0, x2: 1, y2: 0,
                colorStops: [
                  { offset: 0, color: '#E6A23C' },
                  { offset: 1, color: '#F56C6C' }
                ]
              }
            }
          })),
          barWidth: '60%'
        }]
      })
    }
  } catch (error) {
    ElMessage.error('获取排名数据失败：' + error.message)
  }
}

// 初始化参数预警分布图表
const initParamChart = async () => {
  paramChart = echarts.init(document.getElementById('paramChart'))
  try {
    const response = await monitoringApi.getParamDistribution()
    if (response.code === 200) {
      const data = response.data || []
      paramChart.setOption({
        tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
        legend: { orient: 'vertical', left: 'left' },
        series: [{
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
          label: { show: false, position: 'center' },
          emphasis: {
            label: { show: true, fontSize: 20, fontWeight: 'bold' }
          },
          labelLine: { show: false },
          data: data.map(item => ({ name: item.name, value: item.count }))
        }]
      })
    }
  } catch (error) {
    ElMessage.error('获取参数分布数据失败：' + error.message)
  }
}

// 初始化预警级别分布图表
const initLevelChart = async () => {
  levelChart = echarts.init(document.getElementById('levelChart'))
  try {
    const response = await monitoringApi.getLevelDistribution()
    if (response.code === 200) {
      const data = response.data || []
      const colors = ['#909399', '#E6A23C', '#F56C6C', '#C45656']
      levelChart.setOption({
        tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
        legend: { orient: 'vertical', left: 'left' },
        series: [{
          type: 'pie',
          radius: '70%',
          data: data.map((item, index) => ({
            name: item.name,
            value: item.count,
            itemStyle: { color: colors[index] || colors[0] }
          })),
          emphasis: {
            itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' }
          }
        }]
      })
    }
  } catch (error) {
    ElMessage.error('获取级别分布数据失败：' + error.message)
  }
}

// 工具函数
const getLevelTagType = (level) => {
  switch (level) {
    case 1: return 'info'
    case 2: return 'warning'
    case 3: return 'danger'
    case 4: return 'danger'
    default: return 'info'
  }
}

const getLevelText = (level) => {
  switch (level) {
    case 1: return '低级'
    case 2: return '中级'
    case 3: return '高级'
    case 4: return '紧急'
    default: return '未知'
  }
}

const getStatusTagType = (status) => {
  switch (status) {
    case 0: return 'danger'
    case 1: return 'warning'
    case 2: return 'success'
    case 3: return 'info'
    default: return 'info'
  }
}

const getStatusText = (status) => {
  switch (status) {
    case 0: return '未处理'
    case 1: return '处理中'
    case 2: return '已解决'
    case 3: return '已忽略'
    default: return '未知'
  }
}

// 窗口大小变化时重置图表
const resizeCharts = () => {
  if (trendChart) trendChart.resize()
  if (rankChart) rankChart.resize()
  if (paramChart) paramChart.resize()
  if (levelChart) levelChart.resize()
}

onMounted(async () => {
  loadStatistics()
  loadLatestWarnings()
  initTrendChart()
  loadTrendData()
  initRankChart()
  initParamChart()
  initLevelChart()
  window.addEventListener('resize', resizeCharts)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeCharts)
  if (trendChart) trendChart.dispose()
  if (rankChart) rankChart.dispose()
  if (paramChart) paramChart.dispose()
  if (levelChart) levelChart.dispose()
})
</script>

<style scoped>
.monitoring-dashboard {
  padding: 20px;
}
.stat-card {
  transition: all 0.3s;
}
.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 20px rgba(0, 0, 0, 0.1);
}
.stat-content {
  display: flex;
  align-items: center;
  padding: 10px 0;
}
.stat-icon-wrapper {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16px;
  flex-shrink: 0;
}
.stat-info {
  flex: 1;
}
.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #303133;
  line-height: 1.2;
}
.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 4px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
