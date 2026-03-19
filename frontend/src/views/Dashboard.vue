<template>
  <div class="page-container dashboard">
    <!-- 欢迎信息 -->
    <el-card class="welcome-card" shadow="never">
      <div class="welcome-content">
        <div class="welcome-text">
          <h2>欢迎回来，{{ userStore.realName || userStore.username }}！</h2>
          <p>{{ currentTime }}</p>
        </div>
        <div class="welcome-icon">
          <el-icon size="60" color="#409eff"><Warning /></el-icon>
        </div>
      </div>
    </el-card>

    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stat-row">
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)">
            <el-icon size="28"><Warning /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.hazmatCount || 0 }}</div>
            <div class="stat-label">危化品数量</div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%)">
            <el-icon size="28"><Bell /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.pendingHazardCount || 0 }}</div>
            <div class="stat-label">待处理隐患</div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)">
            <el-icon size="28"><DocumentChecked /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.checkPlanCount || 0 }}</div>
            <div class="stat-label">检查计划</div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)">
            <el-icon size="28"><Reading /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.knowledgeCount || 0 }}</div>
            <div class="stat-label">安全知识</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 内容区域 -->
    <el-row :gutter="20">
      <!-- 最新公告 -->
      <el-col :xs="24" :lg="12">
        <el-card class="content-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span><el-icon><Notification /></el-icon> 最新公告</span>
              <el-button text type="primary" @click="$router.push('/announcement/list')" v-if="userStore.isAdmin">
                更多 <el-icon><ArrowRight /></el-icon>
              </el-button>
            </div>
          </template>
          <el-empty v-if="announcements.length === 0" description="暂无公告" />
          <div v-else class="announcement-list">
            <div 
              v-for="item in announcements" 
              :key="item.id" 
              class="announcement-item"
            >
              <div class="announcement-title">
                <el-tag size="small" :type="item.type === '通知' ? 'warning' : 'info'">
                  {{ item.type }}
                </el-tag>
                <span>{{ item.title }}</span>
              </div>
              <div class="announcement-time">{{ formatDate(item.publishTime) }}</div>
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 热门知识 -->
      <el-col :xs="24" :lg="12">
        <el-card class="content-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span><el-icon><Reading /></el-icon> 热门安全知识</span>
              <el-button text type="primary" @click="$router.push('/knowledge/list')">
                更多 <el-icon><ArrowRight /></el-icon>
              </el-button>
            </div>
          </template>
          <el-empty v-if="hotKnowledge.length === 0" description="暂无知识" />
          <div v-else class="knowledge-list">
            <div 
              v-for="item in hotKnowledge" 
              :key="item.id" 
              class="knowledge-item"
              @click="$router.push(`/knowledge/detail/${item.id}`)"
            >
              <div class="knowledge-title">{{ item.title }}</div>
              <div class="knowledge-meta">
                <span><el-icon><View /></el-icon> {{ item.viewCount }}</span>
                <span>{{ item.category }}</span>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 待处理事项（管理员可见） -->
    <el-row :gutter="20" v-if="userStore.isAdmin || userStore.isSafetyAdmin">
      <el-col :xs="24" :lg="12">
        <el-card class="content-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span><el-icon><Bell /></el-icon> 待处理隐患</span>
              <el-button text type="primary" @click="$router.push('/hazard/list')">
                更多 <el-icon><ArrowRight /></el-icon>
              </el-button>
            </div>
          </template>
          <el-empty v-if="pendingHazards.length === 0" description="暂无待处理隐患" />
          <div v-else class="hazard-list">
            <div v-for="item in pendingHazards.slice(0, 5)" :key="item.id" class="hazard-item">
              <div class="hazard-info">
                <el-tag size="small" :type="getLevelType(item.hazardLevel)">{{ item.hazardLevel }}</el-tag>
                <span class="hazard-title">{{ item.title }}</span>
              </div>
              <div class="hazard-reporter">{{ item.reporterName }} · {{ formatDate(item.reportTime) }}</div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :lg="12">
        <el-card class="content-card" shadow="never">
          <template #header>
            <div class="card-header">
              <span><el-icon><DocumentChecked /></el-icon> 待执行检查计划</span>
              <el-button text type="primary" @click="$router.push('/check/plan')">
                更多 <el-icon><ArrowRight /></el-icon>
              </el-button>
            </div>
          </template>
          <el-empty v-if="pendingPlans.length === 0" description="暂无待执行计划" />
          <div v-else class="plan-list">
            <div v-for="item in pendingPlans.slice(0, 5)" :key="item.id" class="plan-item">
              <div class="plan-info">
                <el-tag size="small" :type="item.status === 0 ? 'info' : 'warning'">
                  {{ item.status === 0 ? '待执行' : '进行中' }}
                </el-tag>
                <span class="plan-title">{{ item.title }}</span>
              </div>
              <div class="plan-date">计划日期：{{ item.planDate }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useUserStore } from '@/stores/user'
import { dashboardApi } from '@/api'
import dayjs from 'dayjs'

const userStore = useUserStore()

const stats = ref({})
const announcements = ref([])
const hotKnowledge = ref([])
const pendingHazards = ref([])
const pendingPlans = ref([])

const currentTime = computed(() => {
  return dayjs().format('YYYY年MM月DD日 dddd')
})

const formatDate = (date) => {
  return date ? dayjs(date).format('MM-DD HH:mm') : ''
}

const getLevelType = (level) => {
  const map = { '一般': 'info', '较大': 'warning', '重大': 'danger' }
  return map[level] || 'info'
}

const loadData = async () => {
  try {
    const [statsRes, announcementsRes, knowledgeRes, hazardsRes, plansRes] = await Promise.all([
      dashboardApi.getStats(),
      dashboardApi.getLatestAnnouncements(),
      dashboardApi.getHotKnowledge(),
      dashboardApi.getPendingHazards(),
      dashboardApi.getPendingPlans()
    ])
    
    stats.value = statsRes.data || {}
    announcements.value = announcementsRes.data || []
    hotKnowledge.value = knowledgeRes.data || []
    pendingHazards.value = hazardsRes.data || []
    pendingPlans.value = plansRes.data || []
  } catch (error) {
    console.error('加载数据失败：', error)
  }
}

onMounted(() => {
  loadData()
})
</script>

<style lang="scss" scoped>
.dashboard {
  .welcome-card {
    margin-bottom: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    
    :deep(.el-card__body) {
      padding: 30px;
    }
    
    .welcome-content {
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .welcome-text {
        color: #fff;
        
        h2 {
          font-size: 24px;
          margin-bottom: 10px;
        }
        
        p {
          opacity: 0.8;
        }
      }
      
      .welcome-icon {
        opacity: 0.3;
      }
    }
  }
  
  .stat-row {
    margin-bottom: 20px;
    
    .stat-card {
      display: flex;
      align-items: center;
      padding: 20px;
      
      :deep(.el-card__body) {
        display: flex;
        align-items: center;
        width: 100%;
        padding: 0;
      }
      
      .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        margin-right: 15px;
      }
      
      .stat-info {
        .stat-value {
          font-size: 28px;
          font-weight: bold;
          color: #303133;
        }
        
        .stat-label {
          font-size: 14px;
          color: #909399;
          margin-top: 5px;
        }
      }
    }
  }
  
  .content-card {
    margin-bottom: 20px;
    
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      span {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
      }
    }
    
    .announcement-list {
      .announcement-item {
        padding: 12px 0;
        border-bottom: 1px solid #ebeef5;
        
        &:last-child {
          border-bottom: none;
        }
        
        .announcement-title {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 5px;
          
          span {
            color: #303133;
          }
        }
        
        .announcement-time {
          font-size: 12px;
          color: #909399;
        }
      }
    }
    
    .knowledge-list {
      .knowledge-item {
        padding: 12px 0;
        border-bottom: 1px solid #ebeef5;
        cursor: pointer;
        
        &:last-child {
          border-bottom: none;
        }
        
        &:hover {
          .knowledge-title {
            color: #409eff;
          }
        }
        
        .knowledge-title {
          color: #303133;
          margin-bottom: 5px;
          transition: color 0.3s;
        }
        
        .knowledge-meta {
          font-size: 12px;
          color: #909399;
          display: flex;
          gap: 15px;
          
          span {
            display: flex;
            align-items: center;
            gap: 4px;
          }
        }
      }
    }
    
    .hazard-list, .plan-list {
      .hazard-item, .plan-item {
        padding: 12px 0;
        border-bottom: 1px solid #ebeef5;
        
        &:last-child {
          border-bottom: none;
        }
        
        .hazard-info, .plan-info {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 5px;
          
          .hazard-title, .plan-title {
            color: #303133;
          }
        }
        
        .hazard-reporter, .plan-date {
          font-size: 12px;
          color: #909399;
        }
      }
    }
  }
}
</style>
