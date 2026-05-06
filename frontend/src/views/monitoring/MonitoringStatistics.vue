<template>
  <div class="monitoring-statistics">
    <el-page-header @back="$router.go(-1)" content="监测统计分析" />
    
    <!-- 主要统计卡片 -->
    <el-row :gutter="20" style="margin-bottom: 20px">
      <el-col :span="6">
        <el-card class="stat-card primary">
          <template #header>
            <span>总预警次数</span>
          </template>
          <div class="stat-content">
            <el-icon class="stat-icon"><warning /></el-icon>
            <div class="stat-number">{{ mainStats.totalWarningCount }}</div>
            <div class="stat-desc">本月{{ mainStats.monthlyCount }}次，较上月{{ mainStats.monthlyChange > 0 ? '↑' : '↓' }}{{ Math.abs(mainStats.monthlyChange) }}%</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card warning">
          <template #header>
            <span>重大预警</span>
          </template>
          <div class="stat-content">
            <el-icon class="stat-icon"><warning-filled /></el-icon>
            <div class="stat-number">{{ mainStats.criticalWarningCount }}</div>
            <div class="stat-desc">占比{{ mainStats.criticalPercentage }}%</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card success">
          <template #header>
            <span>平均处理时长</span>
          </template>
          <div class="stat-content">
            <el-icon class="stat-icon"><clock /></el-icon>
            <div class="stat-number">{{ mainStats.avgHandleTime }}</div>
            <div class="stat-desc">较目标{{ mainStats.avgHandleTimeChange > 0 ? '慢' : '快' }}{{ Math.abs(mainStats.avgHandleTimeChange) }}分钟</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card danger">
          <template #header>
            <span>未处理预警</span>
          </template>
          <div class="stat-content">
            <el-icon class="stat-icon"><bell /></el-icon>
            <div class="stat-number">{{ mainStats.unhandledCount }}</div>
            <div class="stat-desc">逾期{{ mainStats.overdueCount }}条</div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 筛选工具栏 -->
    <el-card style="margin-bottom: 20px">
      <el-form :model="searchForm" inline @submit.prevent="refreshAllCharts">
        <el-form-item label="时间范围">
          <el-select v-model="searchForm.timeRange" placeholder="请选择时间范围">
            <el-option label="近7天" value="7d" />
            <el-option label="近15天" value="15d" />
            <el-option label="近30天" value="30d" />
            <el-option label="近90天" value="90d" />
            <el-option label="本年" value="year" />
            <el-option label="自定义" value="custom" />
          </el-select>
        </el-form-item>
        <el-form-item label="开始结束时间" v-if="searchForm.timeRange === 'custom'">
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
        <el-form-item label="危化品类别">
          <el-select v-model="searchForm.categoryId" placeholder="请选择类别" clearable>
            <el-option
              v-for="category in categoryList"
              :key="category.id"
              :label="category.name"
              :value="category.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="预警级别">
          <el-select v-model="searchForm.warningLevel" placeholder="请选择级别" multiple collapse-tags>
            <el-option label="一般" value="一般" />
            <el-option label="较大" value="较大" />
            <el-option label="重大" value="重大" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="refreshAllCharts" icon="Refresh">
            刷新统计
          </el-button>
          <el-button @click="exportStatistics" icon="Download">
            导出统计
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
    
    <!-- 预警趋势分析 -->
    <el-row :gutter="20" style="margin-bottom: 20px">
      <el-col :span="14">
        <el-card>
          <template #header>
            <span>预警趋势分析</span>
          </template>
          <div class="chart-toolbar">
            <el-button-group size="small">
              <el-button @click="changeTrendChartType('line')" type="primary" :plain="trendChartType !== 'line'">
                折线图
              </el-button>
              <el-button @click="changeTrendChartType('bar')" type="primary" :plain="trendChartType !== 'bar'">
                柱状图
              </el-button>
            </el-button-group>
            <el-select v-model="trendGroupBy" size="small" @change="refreshTrendChart">
              <el-option label="按天" value="day" />
              <el-option label="按小时" value="hour" />
            </el-select>
          </div>
          <div id="warningTrendChart" style="height: 400px;"></div>
        </el-card>
      </el-col>
      <el-col :span="10">
        <el-card>
          <template #header>
            <span>预警级别分布</span>
          </template>
          <div id="warningLevelChart" style="height: 400px;"></div>
          <div class="chart-legend">
            <div class="legend-item">
              <span class="legend-color" style="background-color: #67C23A;"></span>
              <span>一般预警: {{ levelStats.generalCount }} ({{ levelStats.generalPercentage }}%)</span>
            </div>
            <div class="legend-item">
              <span class="legend-color" style="background-color: #E6A23C;"></span>
              <span>较大预警: {{ levelStats.majorCount }} ({{ levelStats.majorPercentage }}%)</span>
            </div>
            <div class="legend-item">
              <span class="legend-color" style="background-color: #F56C6C;"></span>
              <span>重大预警: {{ levelStats.criticalCount }} ({{ levelStats.criticalPercentage }}%)</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 危化品风险排名 -->
    <el-row :gutter="20" style="margin-bottom: 20px">
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>危化品风险排名</span>
            <el-button size="small" @click="changeRankType('warningCount')" :type="rankType === 'warningCount' ? 'primary' : 'default'">
              预警次数
            </el-button>
            <el-button size="small" @click="changeRankType('criticalCount')" :type="rankType === 'criticalCount' ? 'primary' : 'default'">
              重大预警
            </el-button>
          </template>
          <div id="hazmatRankChart" style="height: 400px;"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>预警类型分布</span>
          </template>
          <div id="warningTypeChart" style="height: 400px;"></div>
        </el-card>
      </el-col>
    </el-row>
    
    <!-- 处理效率分析 -->
    <el-card style="margin-bottom: 20px">
      <template #header>
        <span>处理效率分析</span>
      </template>
      <div class="chart-toolbar">
        <el-button-group size="small">
          <el-button @click="changeEfficiencyType('handleTime')" type="primary" :plain="efficiencyType !== 'handleTime'">
            处理时长
          </el-button>
          <el-button @click="changeEfficiencyType('handleRate')" type="primary" :plain="efficiencyType !== 'handleRate'">
            处理率
          </el-button>
        </el-button-group>
      </div>
      <div id="handleEfficiencyChart" style="height: 400px;"></div>
    </el-card>
    
    <!-- 预警处理详情表格 -->
    <el-card>
      <template #header>
        <span>处理效率详情</span>
      </template>
      <el-table
        v-loading="loading"
        :data="efficiencyList"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="handlerName" label="处理人" min-width="120" align="center" />
        <el-table-column prop="totalCount" label="处理总数" width="100" align="center" />
        <el-table-column prop="avgHandleTime" label="平均处理时长(分钟)" width="150" align="center" />
        <el-table-column prop="maxHandleTime" label="最长处理时长(分钟)" width="150" align="center" />
        <el-table-column prop="onTimeRate" label="及时处理率" width="120" align="center">
          <template #default="scope">
            <el-progress :percentage="scope.row.onTimeRate" :stroke-width="16" text-inside />
          </template>
        </el-table-column>
        <el-table-column prop="overdueCount" label="逾期数量" width="100" align="center">
          <template #default="scope">
            <span style="color: #F56C6C; font-weight: bold;">
              {{ scope.row.overdueCount }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" align="center">
          <template #default="scope">
            <el-button size="small" type="primary" @click="viewHandleDetail(scope.row)">
              查看详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <!-- 详情对话框 -->
    <el-dialog
      v-model="showDetailDialog"
      title="处理详情"
      width="800px"
    >
      <el-table
        v-loading="detailLoading"
        :data="handleDetailList"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="warningTitle" label="预警标题" min-width="200" />
        <el-table-column prop="warningLevel" label="预警级别" width="100" align="center">
          <template #default="scope">
            <el-tag :type="getWarningLevelType(scope.row.warningLevel)" size="small">
              {{ scope.row.warningLevel }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="warningTime" label="预警时间" width="180" align="center" />
        <el-table-column prop="handleTime" label="处理时间" width="180" align="center" />
        <el-table-column prop="handleDuration" label="处理时长(分钟)" width="150" align="center" />
        <el-table-column prop="isOverdue" label="是否逾期" width="100" align="center">
          <template #default="scope">
            <el-tag :type="scope.row.isOverdue ? 'danger' : 'success'" size="small">
              {{ scope.row.isOverdue ? '是' : '否' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="handleResult" label="处理结果" min-width="150" />
      </el-table>
      
      <el-pagination
        v-model:current-page="detailPagination.pageNum"
        v-model:page-size="detailPagination.pageSize"
        :total="detailPagination.total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="refreshHandleDetail"
        @current-change="refreshHandleDetail"
      />
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, watch, onBeforeUnmount } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { monitoringApi, hazmatApi } from '@/api'
import { Warning, WarningFilled, Clock, Bell } from '@element-plus/icons-vue'
import * as echarts from 'echarts'

const loading = ref(false)
const detailLoading = ref(false)
const efficiencyList = ref([])
const handleDetailList = ref([])
const categoryList = ref([])

// 表单数据
const searchForm = reactive({
  timeRange: '90d',
  categoryId: null,
  warningLevel: []
})
const dateRange = ref([])

// 统计数据
const mainStats = reactive({
  totalWarningCount: 0,
  monthlyCount: 0,
  monthlyChange: 0,
  criticalWarningCount: 0,
  criticalPercentage: 0,
  avgHandleTime: '0分钟',
  avgHandleTimeChange: 0,
  unhandledCount: 0,
  overdueCount: 0
})

const levelStats = reactive({
  generalCount: 0,
  generalPercentage: 0,
  majorCount: 0,
  majorPercentage: 0,
  criticalCount: 0,
  criticalPercentage: 0
})

// 图表类型控制
const trendChartType = ref('line')
const trendGroupBy = ref('day')
const rankType = ref('warningCount')
const efficiencyType = ref('handleTime')

// 分页
const detailPagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

// 对话框
const showDetailDialog = ref(false)
const currentHandler = ref(null)

// 图表实例
let trendChart = null
let levelChart = null
let rankChart = null
let typeChart = null
let efficiencyChart = null

// 预警级别标签类型
const getWarningLevelType = (level) => {
  switch (level) {
    case '一般':
      return 'success'
    case '较大':
      return 'warning'
    case '重大':
      return 'danger'
    default:
      return 'info'
  }
}

// 获取主要统计数据
const getMainStatistics = async () => {
  try {
    const params = getQueryParams()
    const response = await monitoringApi.getMainStatistics(params)
    if (response.code === 200) {
      Object.assign(mainStats, response.data)
    } else {
      ElMessage.error(response.message || '获取统计数据失败')
    }
  } catch (error) {
    ElMessage.error('获取统计数据失败：' + error.message)
  }
}

// 获取级别统计数据
const getLevelStatistics = async () => {
  try {
    const params = getQueryParams()
    const response = await monitoringApi.getLevelStatistics(params)
    if (response.code === 200) {
      Object.assign(levelStats, response.data)
      renderLevelChart(response.data)
    } else {
      ElMessage.error(response.message || '获取级别统计失败')
    }
  } catch (error) {
    ElMessage.error('获取级别统计失败：' + error.message)
  }
}

// 获取效率统计数据
const getEfficiencyStatistics = async () => {
  loading.value = true
  try {
    const params = getQueryParams()
    const response = await monitoringApi.getEfficiencyStatistics(params)
    if (response.code === 200) {
      efficiencyList.value = response.data.list
      renderEfficiencyChart(response.data.chartData)
    } else {
      ElMessage.error(response.message || '获取效率统计失败')
    }
  } catch (error) {
    ElMessage.error('获取效率统计失败：' + error.message)
  } finally {
    loading.value = false
  }
}

// 获取危化品类别列表
const getCategoryList = async () => {
  try {
    const response = await hazmatApi.getHazmatCategories()
    if (response.code === 200) {
      categoryList.value = response.data
    } else {
      ElMessage.error(response.message || '获取类别列表失败')
    }
  } catch (error) {
    ElMessage.error('获取类别列表失败：' + error.message)
  }
}

// 获取查询参数
const getQueryParams = () => {
  const params = {
    timeRange: searchForm.timeRange,
    categoryId: searchForm.categoryId,
    warningLevel: searchForm.warningLevel.join(',')
  }
  
  if (searchForm.timeRange === 'custom' && dateRange.value && dateRange.value.length === 2) {
    params.startTime = dateRange.value[0]
    params.endTime = dateRange.value[1]
  }
  
  return params
}

// 刷新所有图表
const refreshAllCharts = () => {
  getMainStatistics()
  getLevelStatistics()
  refreshTrendChart()
  refreshRankChart()
  refreshTypeChart()
  getEfficiencyStatistics()
}

// 预警趋势图表
const refreshTrendChart = async () => {
  try {
    const params = {
      ...getQueryParams(),
      groupBy: trendGroupBy.value,
      chartType: trendChartType.value
    }
    const response = await monitoringApi.getTrendStatistics(params)
    if (response.code === 200) {
      renderTrendChart(response.data)
    } else {
      ElMessage.error(response.message || '获取趋势数据失败')
    }
  } catch (error) {
    ElMessage.error('获取趋势数据失败：' + error.message)
  }
}

const changeTrendChartType = (type) => {
  trendChartType.value = type
  refreshTrendChart()
}

const renderTrendChart = (data) => {
  const chartDom = document.getElementById('warningTrendChart')
  if (!chartDom) return
  
  if (!trendChart) {
    trendChart = echarts.init(chartDom)
  }
  
  const option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'cross'
      }
    },
    legend: {
      data: ['一般预警', '较大预警', '重大预警', '总计']
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
      data: data.xData
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        name: '一般预警',
        type: trendChartType.value,
        data: data.generalData,
        stack: '总量',
        itemStyle: {
          color: '#67C23A'
        }
      },
      {
        name: '较大预警',
        type: trendChartType.value,
        data: data.majorData,
        stack: '总量',
        itemStyle: {
          color: '#E6A23C'
        }
      },
      {
        name: '重大预警',
        type: trendChartType.value,
        data: data.criticalData,
        stack: '总量',
        itemStyle: {
          color: '#F56C6C'
        }
      },
      {
        name: '总计',
        type: 'line',
        data: data.totalData,
        itemStyle: {
          color: '#409EFF'
        },
        lineStyle: {
          width: 3
        }
      }
    ]
  }
  
  trendChart.setOption(option)
}

// 预警级别分布图表
const renderLevelChart = (data) => {
  const chartDom = document.getElementById('warningLevelChart')
  if (!chartDom) return
  
  if (!levelChart) {
    levelChart = echarts.init(chartDom)
  }
  
  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b} : {c} ({d}%)'
    },
    series: [
      {
        name: '预警级别',
        type: 'pie',
        radius: ['40%', '70%'],
        center: ['50%', '50%'],
        data: [
          { value: data.generalCount, name: '一般预警', itemStyle: { color: '#67C23A' } },
          { value: data.majorCount, name: '较大预警', itemStyle: { color: '#E6A23C' } },
          { value: data.criticalCount, name: '重大预警', itemStyle: { color: '#F56C6C' } }
        ],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  }
  
  levelChart.setOption(option)
}

// 危化品风险排名图表
const refreshRankChart = async () => {
  try {
    const params = {
      ...getQueryParams(),
      rankType: rankType.value
    }
    const response = await monitoringApi.getHazmatRankStatistics(params)
    if (response.code === 200) {
      renderRankChart(response.data)
    } else {
      ElMessage.error(response.message || '获取排名数据失败')
    }
  } catch (error) {
    ElMessage.error('获取排名数据失败：' + error.message)
  }
}

const changeRankType = (type) => {
  rankType.value = type
  refreshRankChart()
}

const renderRankChart = (data) => {
  const chartDom = document.getElementById('hazmatRankChart')
  if (!chartDom) return
  
  if (!rankChart) {
    rankChart = echarts.init(chartDom)
  }
  
  const option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'value',
      boundaryGap: [0, 0.01]
    },
    yAxis: {
      type: 'category',
      data: data.names
    },
    series: [
      {
        name: '预警次数',
        type: 'bar',
        data: data.values,
        itemStyle: {
          color: function(params) {
            // 渐变色
            const colorList = ['#F56C6C', '#E6A23C', '#67C23A', '#409EFF', '#909399']
            return colorList[params.dataIndex % colorList.length]
          }
        }
      }
    ]
  }
  
  rankChart.setOption(option)
}

// 预警类型分布图表
const refreshTypeChart = async () => {
  try {
    const params = getQueryParams()
    const response = await monitoringApi.getTypeStatistics(params)
    if (response.code === 200) {
      renderTypeChart(response.data)
    } else {
      ElMessage.error(response.message || '获取类型数据失败')
    }
  } catch (error) {
    ElMessage.error('获取类型数据失败：' + error.message)
  }
}

const renderTypeChart = (data) => {
  const chartDom = document.getElementById('warningTypeChart')
  if (!chartDom) return
  
  if (!typeChart) {
    typeChart = echarts.init(chartDom)
  }
  
  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{a} <br/>{b} : {c} ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        name: '预警类型',
        type: 'pie',
        radius: '50%',
        center: ['60%', '50%'],
        data: [
          { value: data.thresholdCount, name: '阈值型' },
          { value: data.trendCount, name: '趋势型' },
          { value: data.correlationCount, name: '关联型' },
          { value: data.otherCount, name: '其他' }
        ],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  }
  
  typeChart.setOption(option)
}

// 处理效率图表
const changeEfficiencyType = (type) => {
  efficiencyType.value = type
  refreshEfficiencyChart()
}

const renderEfficiencyChart = (data) => {
  const chartDom = document.getElementById('handleEfficiencyChart')
  if (!chartDom) return
  
  if (!efficiencyChart) {
    efficiencyChart = echarts.init(chartDom)
  }
  
  let option
  
  if (efficiencyType.value === 'handleTime') {
    // 处理时长柱状图
    option = {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        }
      },
      legend: {
        data: ['平均处理时长', '目标时长']
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        data: data.xData
      },
      yAxis: {
        type: 'value',
        name: '分钟'
      },
      series: [
        {
          name: '平均处理时长',
          type: 'bar',
          data: data.avgTimeData,
          itemStyle: {
            color: '#409EFF'
          }
        },
        {
          name: '目标时长',
          type: 'line',
          data: data.targetTimeData,
          itemStyle: {
            color: '#F56C6C'
          },
          lineStyle: {
            width: 2,
            type: 'dashed'
          }
        }
      ]
    }
  } else {
    // 处理率柱状图
    option = {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        }
      },
      legend: {
        data: ['及时处理率', '逾期率']
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        data: data.xData
      },
      yAxis: {
        type: 'value',
        name: '百分比',
        axisLabel: {
          formatter: '{value}%'
        }
      },
      series: [
        {
          name: '及时处理率',
          type: 'bar',
          data: data.onTimeRateData,
          itemStyle: {
            color: '#67C23A'
          }
        },
        {
          name: '逾期率',
          type: 'bar',
          data: data.overdueRateData,
          itemStyle: {
            color: '#F56C6C'
          }
        }
      ]
    }
  }
  
  efficiencyChart.setOption(option)
}

// 查看处理详情
const viewHandleDetail = (row) => {
  currentHandler.value = row
  showDetailDialog.value = true
  detailPagination.pageNum = 1
  refreshHandleDetail()
}

// 刷新处理详情
const refreshHandleDetail = async () => {
  detailLoading.value = true
  try {
    const params = {
      handlerId: currentHandler.value.id,
      pageNum: detailPagination.pageNum,
      pageSize: detailPagination.pageSize,
      ...getQueryParams()
    }
    const response = await monitoringApi.getHandleDetail(params)
    if (response.code === 200) {
      handleDetailList.value = response.data.list
      detailPagination.total = response.data.total
    } else {
      ElMessage.error(response.message || '获取处理详情失败')
    }
  } catch (error) {
    ElMessage.error('获取处理详情失败：' + error.message)
  } finally {
    detailLoading.value = false
  }
}

// 导出统计
const exportStatistics = () => {
  ElMessageBox.confirm(
    '是否导出当前统计数据?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'info'
    }
  )
    .then(async () => {
      try {
        const params = getQueryParams()
        const response = await monitoringApi.exportStatistics(params)
        if (response.code === 200) {
          ElMessage.success('导出成功!')
          // 下载文件
          const url = window.URL.createObjectURL(new Blob([response.data]))
          const link = document.createElement('a')
          link.href = url
          link.setAttribute('download', `监测统计分析_${new Date().getTime()}.xlsx`)
          document.body.appendChild(link)
          link.click()
          link.remove()
        } else {
          ElMessage.error(response.message || '导出失败')
        }
      } catch (error) {
        ElMessage.error('导出失败：' + error.message)
      }
    })
    .catch(() => {
      ElMessage.info('已取消导出')
    })
}

// 窗口大小变化时重置图表
const resizeCharts = () => {
  if (trendChart) trendChart.resize()
  if (levelChart) levelChart.resize()
  if (rankChart) rankChart.resize()
  if (typeChart) typeChart.resize()
  if (efficiencyChart) efficiencyChart.resize()
}

onMounted(() => {
  getMainStatistics()
  getLevelStatistics()
  getEfficiencyStatistics()
  refreshTrendChart()
  refreshRankChart()
  refreshTypeChart()
  getCategoryList()
  window.addEventListener('resize', resizeCharts)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', resizeCharts)
  
  // 销毁所有图表
  if (trendChart) trendChart.dispose()
  if (levelChart) levelChart.dispose()
  if (rankChart) rankChart.dispose()
  if (typeChart) typeChart.dispose()
  if (efficiencyChart) efficiencyChart.dispose()
})

// 监听时间范围变化
watch(() => searchForm.timeRange, (newVal) => {
  if (newVal !== 'custom') {
    dateRange.value = []
  }
})
</script>

<style scoped>
.monitoring-statistics {
  padding: 20px;
}

.stat-card {
  transition: all 0.3s;
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 20px rgba(0, 0, 0, 0.1);
  }
}

.stat-card.primary {
  border-top: 4px solid #409EFF;
}

.stat-card.warning {
  border-top: 4px solid #E6A23C;
}

.stat-card.success {
  border-top: 4px solid #67C23A;
}

.stat-card.danger {
  border-top: 4px solid #F56C6C;
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

.stat-card.warning .stat-icon {
  color: #E6A23C;
}

.stat-card.success .stat-icon {
  color: #67C23A;
}

.stat-card.danger .stat-icon {
  color: #F56C6C;
}

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

.chart-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.chart-legend {
  padding: 10px;
  background: #fafafa;
  border-top: 1px solid #ebeef5;
}

.legend-item {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}

.legend-color {
  width: 20px;
  height: 20px;
  border-radius: 4px;
  margin-right: 10px;
}

.chart-container {
  display: flex;
  flex-direction: column;
  height: 100%;
}
</style>