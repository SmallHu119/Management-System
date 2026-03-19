<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>隐患上报</span>
        </div>
      </template>

      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px" class="form-container">
        <el-form-item label="隐患标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入隐患标题" />
        </el-form-item>

        <el-form-item label="隐患等级" prop="hazardLevel">
          <el-radio-group v-model="form.hazardLevel">
            <el-radio label="一般">一般</el-radio>
            <el-radio label="较大">较大</el-radio>
            <el-radio label="重大">重大</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="发现位置" prop="location">
          <el-input v-model="form.location" placeholder="请输入发现隐患的位置" />
        </el-form-item>

        <el-form-item label="隐患描述" prop="description">
          <el-input 
            v-model="form.description" 
            type="textarea" 
            :rows="5" 
            placeholder="请详细描述发现的隐患情况，包括可能造成的危害等" 
          />
        </el-form-item>

        <el-form-item label="现场图片">
          <el-upload
            v-model:file-list="fileList"
            action="/api/file/upload/image"
            list-type="picture-card"
            :headers="uploadHeaders"
            :on-success="handleUploadSuccess"
            :on-remove="handleUploadRemove"
            :before-upload="beforeUpload"
            accept="image/*"
          >
            <el-icon><Plus /></el-icon>
            <template #tip>
              <div class="el-upload__tip">支持jpg/png格式，单个文件不超过5MB</div>
            </template>
          </el-upload>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="handleSubmit" :loading="loading">
            <el-icon><Check /></el-icon> 提交上报
          </el-button>
          <el-button @click="handleReset">
            <el-icon><Refresh /></el-icon> 重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { hazardApi } from '@/api'

const formRef = ref(null)
const loading = ref(false)
const fileList = ref([])
const uploadedImages = ref([])

const form = reactive({
  title: '',
  hazardLevel: '一般',
  location: '',
  description: '',
  images: ''
})

const rules = {
  title: [{ required: true, message: '请输入隐患标题', trigger: 'blur' }],
  hazardLevel: [{ required: true, message: '请选择隐患等级', trigger: 'change' }],
  location: [{ required: true, message: '请输入发现位置', trigger: 'blur' }],
  description: [
    { required: true, message: '请描述隐患情况', trigger: 'blur' },
    { min: 10, message: '描述内容不少于10个字符', trigger: 'blur' }
  ]
}

const uploadHeaders = computed(() => ({
  Authorization: `Bearer ${localStorage.getItem('token')}`
}))

const beforeUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过5MB!')
    return false
  }
  return true
}

const handleUploadSuccess = (response, file) => {
  if (response.code === 200) {
    uploadedImages.value.push(response.data)
    ElMessage.success('上传成功')
  } else {
    ElMessage.error(response.message || '上传失败')
  }
}

const handleUploadRemove = (file) => {
  const url = file.response?.data || file.url
  const index = uploadedImages.value.indexOf(url)
  if (index > -1) {
    uploadedImages.value.splice(index, 1)
  }
}

const handleSubmit = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    form.images = uploadedImages.value.join(',')
    await hazardApi.reportHazard(form)
    ElMessage.success('上报成功')
    handleReset()
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const handleReset = () => {
  formRef.value.resetFields()
  fileList.value = []
  uploadedImages.value = []
}
</script>

<style lang="scss" scoped>
.form-container {
  max-width: 700px;
}
</style>
