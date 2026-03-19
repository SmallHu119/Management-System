<template>
  <div class="page-container">
    <el-card shadow="never" v-loading="loading">
      <template #header>
        <div class="card-header">
          <span>安全知识详情</span>
          <el-button @click="$router.back()">
            <el-icon><Back /></el-icon> 返回
          </el-button>
        </div>
      </template>

      <div class="knowledge-detail" v-if="detail">
        <h1 class="detail-title">{{ detail.title }}</h1>
        <div class="detail-meta">
          <el-tag>{{ detail.category }}</el-tag>
          <span class="meta-item">
            <el-icon><View /></el-icon> {{ detail.viewCount || 0 }} 次浏览
          </span>
          <span class="meta-item">
            <el-icon><Clock /></el-icon> {{ detail.createTime }}
          </span>
        </div>
        <el-divider />
        <div class="detail-summary" v-if="detail.summary">
          <strong>摘要：</strong>{{ detail.summary }}
        </div>
        <div class="detail-content rich-content">
          <pre>{{ detail.content }}</pre>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { knowledgeApi } from '@/api'

const route = useRoute()
const loading = ref(false)
const detail = ref(null)

const loadDetail = async () => {
  loading.value = true
  try {
    const res = await knowledgeApi.getKnowledgeById(route.params.id)
    detail.value = res.data
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadDetail()
})
</script>

<style lang="scss" scoped>
.knowledge-detail {
  max-width: 900px;
  margin: 0 auto;
  
  .detail-title {
    font-size: 28px;
    font-weight: 600;
    color: #303133;
    margin-bottom: 20px;
    line-height: 1.4;
  }
  
  .detail-meta {
    display: flex;
    align-items: center;
    gap: 20px;
    color: #909399;
    font-size: 14px;
    
    .meta-item {
      display: flex;
      align-items: center;
      gap: 5px;
    }
  }
  
  .detail-summary {
    background-color: #f5f7fa;
    padding: 15px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    color: #606266;
    line-height: 1.6;
  }
  
  .detail-content {
    pre {
      white-space: pre-wrap;
      word-wrap: break-word;
      font-family: inherit;
      font-size: 15px;
      line-height: 1.8;
      color: #303133;
    }
  }
}
</style>
