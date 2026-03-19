<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>危化品列表</span>
          <el-button type="primary" @click="handleAdd" v-if="canManage">
            <el-icon><Plus /></el-icon> 添加危化品
          </el-button>
        </div>
      </template>

      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="名称">
          <el-input v-model="searchForm.name" placeholder="请输入危化品名称" clearable />
        </el-form-item>
        <el-form-item label="类别">
          <el-select v-model="searchForm.categoryId" placeholder="请选择类别" clearable>
            <el-option v-for="item in categories" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="危险类型">
          <el-input v-model="searchForm.dangerType" placeholder="请输入危险类型" clearable />
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
        <el-table-column prop="code" label="编码" width="100" />
        <el-table-column prop="name" label="名称" min-width="120" />
        <el-table-column prop="categoryName" label="类别" width="120" />
        <el-table-column prop="dangerType" label="危险类型" width="150" />
        <el-table-column prop="physicalState" label="物理状态" width="100" />
        <el-table-column prop="stockQuantity" label="库存" width="100">
          <template #default="{ row }">
            {{ row.stockQuantity }} {{ row.unit }}
          </template>
        </el-table-column>
        <el-table-column prop="location" label="存放位置" width="150" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleView(row)">查看</el-button>
            <el-button type="primary" link @click="handleEdit(row)" v-if="canManage">编辑</el-button>
            <el-popconfirm title="确定要删除吗？" @confirm="handleDelete(row)" v-if="canManage">
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

    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="700px" destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入危化品名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="编码" prop="code">
              <el-input v-model="form.code" placeholder="请输入编码" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="类别" prop="categoryId">
              <el-select v-model="form.categoryId" placeholder="请选择类别" style="width: 100%">
                <el-option v-for="item in categories" :key="item.id" :label="item.name" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="危险类型" prop="dangerType">
              <el-input v-model="form.dangerType" placeholder="如：易燃、易爆、剧毒" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="CAS号">
              <el-input v-model="form.casNumber" placeholder="请输入CAS号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="UN编号">
              <el-input v-model="form.unNumber" placeholder="请输入UN编号" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="物理状态">
              <el-select v-model="form.physicalState" placeholder="请选择" style="width: 100%">
                <el-option label="固体" value="固体" />
                <el-option label="液体" value="液体" />
                <el-option label="气体" value="气体" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="计量单位">
              <el-input v-model="form.unit" placeholder="如：千克、升" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="库存数量">
              <el-input-number v-model="form.stockQuantity" :min="0" :precision="2" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="存放位置">
              <el-input v-model="form.location" placeholder="请输入存放位置" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="供应商">
          <el-input v-model="form.supplier" placeholder="请输入供应商" />
        </el-form-item>
        <el-form-item label="储存条件">
          <el-input v-model="form.storageCondition" type="textarea" :rows="2" placeholder="请输入储存条件" />
        </el-form-item>
        <el-form-item label="应急措施">
          <el-input v-model="form.emergencyMeasure" type="textarea" :rows="2" placeholder="请输入应急处置措施" />
        </el-form-item>
        <el-form-item label="防护措施">
          <el-input v-model="form.protectiveMeasure" type="textarea" :rows="2" placeholder="请输入防护措施" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { hazmatApi } from '@/api'

const router = useRouter()
const userStore = useUserStore()

const canManage = computed(() => userStore.isAdmin || userStore.isSafetyAdmin)

const loading = ref(false)
const tableData = ref([])
const categories = ref([])

const searchForm = reactive({
  name: '',
  categoryId: null,
  dangerType: ''
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

// 对话框
const dialogVisible = ref(false)
const dialogTitle = ref('')
const submitLoading = ref(false)
const formRef = ref(null)

const form = reactive({
  id: null,
  name: '',
  code: '',
  categoryId: null,
  casNumber: '',
  unNumber: '',
  dangerType: '',
  physicalState: '',
  storageCondition: '',
  emergencyMeasure: '',
  protectiveMeasure: '',
  stockQuantity: 0,
  unit: '',
  location: '',
  supplier: ''
})

const rules = {
  name: [{ required: true, message: '请输入危化品名称', trigger: 'blur' }],
  categoryId: [{ required: true, message: '请选择类别', trigger: 'change' }]
}

const loadCategories = async () => {
  try {
    const res = await hazmatApi.getAllCategories()
    categories.value = res.data || []
  } catch (error) {
    console.error(error)
  }
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await hazmatApi.getHazmatList({
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
  searchForm.name = ''
  searchForm.categoryId = null
  searchForm.dangerType = ''
  handleSearch()
}

const handleView = (row) => {
  router.push(`/hazmat/detail/${row.id}`)
}

const handleAdd = () => {
  dialogTitle.value = '添加危化品'
  Object.keys(form).forEach(key => {
    form[key] = key === 'stockQuantity' ? 0 : (key === 'id' || key === 'categoryId' ? null : '')
  })
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑危化品'
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleSubmit = async () => {
  await formRef.value.validate()
  submitLoading.value = true
  try {
    if (form.id) {
      await hazmatApi.updateHazmat(form)
      ElMessage.success('更新成功')
    } else {
      await hazmatApi.addHazmat(form)
      ElMessage.success('添加成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (error) {
    console.error(error)
  } finally {
    submitLoading.value = false
  }
}

const handleDelete = async (row) => {
  try {
    await hazmatApi.deleteHazmat(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    console.error(error)
  }
}

onMounted(() => {
  loadCategories()
  loadData()
})
</script>
