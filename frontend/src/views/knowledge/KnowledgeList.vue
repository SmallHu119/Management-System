<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>安全知识学习</span>
        </div>
      </template>

      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="标题">
          <el-input v-model="searchForm.title" placeholder="请输入标题" clearable />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="searchForm.category" placeholder="请选择分类" clearable>
            <el-option label="安全法规" value="安全法规" />
            <el-option label="操作规程" value="操作规程" />
            <el-option label="应急处置" value="应急处置" />
            <el-option label="防护知识" value="防护知识" />
            <el-option label="案例分析" value="案例分析" />
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

      <!-- 知识列表 -->
      <div class="knowledge-grid" v-loading="loading">
        <el-empty v-if="tableData.length === 0" description="暂无安全知识" />
        <el-row :gutter="20" v-else>
          <el-col :xs="24" :sm="12" :lg="8" v-for="item in tableData" :key="item.id">
            <el-card class="knowledge-card" shadow="hover" @click="handleView(item)">
              <div class="knowledge-cover" v-if="item.coverImage">
                <el-image :src="item.coverImage" fit="cover" />
              </div>
              <div class="knowledge-cover placeholder" v-else>
                <el-icon size="48"><Reading /></el-icon>
              </div>
              <div class="knowledge-info">
                <h3 class="knowledge-title">{{ item.title }}</h3>
                <p class="knowledge-summary">{{ item.summary || '暂无简介' }}</p>
                <div class="knowledge-meta">
                  <el-tag size="small">{{ item.category }}</el-tag>
                  <span class="view-count">
                    <el-icon><View /></el-icon> {{ item.viewCount || 0 }}
                  </span>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="pagination.pageNum"
          v-model:page-size="pagination.pageSize"
          :page-sizes="[9, 18, 27, 36]"
          :total="pagination.total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="loadData"
          @current-change="loadData"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { knowledgeApi } from '@/api'

const router = useRouter()

const loading = ref(false)
const tableData = ref([])

const searchForm = reactive({
  title: '',
  category: ''
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 9,
  total: 0
})

const loadData = async () => {
  loading.value = true
  try {
    const res = await knowledgeApi.getPublishedKnowledge({
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
  searchForm.category = ''
  handleSearch()
}

const handleView = (item) => {
  router.push(`/knowledge/detail/${item.id}`)
}

onMounted(() => {
  loadData()
})
</script>

<style lang="scss" scoped>
.knowledge-grid {
  min-height: 300px;
}

.knowledge-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: transform 0.3s;
  
  &:hover {
    transform: translateY(-5px);
  }
  
  :deep(.el-card__body) {
    padding: 0;
  }
  
  .knowledge-cover {
    height: 150px;
    overflow: hidden;
    
    .el-image {
      width: 100%;
      height: 100%;
    }
    
    &.placeholder {
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: rgba(255, 255, 255, 0.5);
    }
  }
  
  .knowledge-info {
    padding: 15px;
    
    .knowledge-title {
      font-size: 16px;
      font-weight: 500;
      color: #303133;
      margin-bottom: 8px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    
    .knowledge-summary {
      font-size: 13px;
      color: #909399;
      line-height: 1.5;
      height: 40px;
      overflow: hidden;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
    }
    
    .knowledge-meta {
      margin-top: 10px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .view-count {
        font-size: 12px;
        color: #909399;
        display: flex;
        align-items: center;
        gap: 4px;
      }
    }
  }
}
</style>
