<template>
  <div class="page-container">
    <el-card shadow="never" v-loading="loading">
      <template #header>
        <div class="card-header">
          <span>危化品详情</span>
          <el-button @click="$router.back()">
            <el-icon><Back /></el-icon> 返回
          </el-button>
        </div>
      </template>

      <el-descriptions :column="2" border v-if="detail">
        <el-descriptions-item label="名称">{{ detail.name }}</el-descriptions-item>
        <el-descriptions-item label="编码">{{ detail.code }}</el-descriptions-item>
        <el-descriptions-item label="类别">{{ detail.categoryName }}</el-descriptions-item>
        <el-descriptions-item label="危险类型">
          <el-tag type="danger">{{ detail.dangerType }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="CAS号">{{ detail.casNumber || '-' }}</el-descriptions-item>
        <el-descriptions-item label="UN编号">{{ detail.unNumber || '-' }}</el-descriptions-item>
        <el-descriptions-item label="物理状态">{{ detail.physicalState || '-' }}</el-descriptions-item>
        <el-descriptions-item label="计量单位">{{ detail.unit || '-' }}</el-descriptions-item>
        <el-descriptions-item label="库存数量">{{ detail.stockQuantity }} {{ detail.unit }}</el-descriptions-item>
        <el-descriptions-item label="存放位置">{{ detail.location || '-' }}</el-descriptions-item>
        <el-descriptions-item label="供应商" :span="2">{{ detail.supplier || '-' }}</el-descriptions-item>
        <el-descriptions-item label="储存条件" :span="2">
          <div class="detail-content">{{ detail.storageCondition || '-' }}</div>
        </el-descriptions-item>
        <el-descriptions-item label="应急措施" :span="2">
          <div class="detail-content danger-text">{{ detail.emergencyMeasure || '-' }}</div>
        </el-descriptions-item>
        <el-descriptions-item label="防护措施" :span="2">
          <div class="detail-content">{{ detail.protectiveMeasure || '-' }}</div>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ detail.createTime }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ detail.updateTime }}</el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { hazmatApi } from '@/api'

const route = useRoute()
const loading = ref(false)
const detail = ref(null)

const loadDetail = async () => {
  loading.value = true
  try {
    const res = await hazmatApi.getHazmatById(route.params.id)
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
.detail-content {
  white-space: pre-wrap;
  line-height: 1.6;
}

.danger-text {
  color: #f56c6c;
}
</style>
