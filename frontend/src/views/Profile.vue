<template>
  <div class="page-container">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>个人信息</span>
        </div>
      </template>
      
      <el-form 
        ref="formRef" 
        :model="form" 
        :rules="rules" 
        label-width="100px" 
        class="form-container"
        :disabled="!isEditing"
      >
        <el-form-item label="用户名">
          <el-input v-model="form.username" disabled />
        </el-form-item>
        
        <el-form-item label="真实姓名" prop="realName">
          <el-input v-model="form.realName" placeholder="请输入真实姓名" />
        </el-form-item>
        
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        
        <el-form-item label="所属部门" prop="department" v-if="userStore.role !== 'admin'">
          <el-input v-model="form.department" placeholder="请输入所属部门" />
        </el-form-item>
        
        <el-form-item label="用户角色">
          <el-tag>{{ roleText }}</el-tag>
        </el-form-item>
        
        <el-form-item>
          <template v-if="!isEditing">
            <el-button type="primary" @click="isEditing = true">编辑信息</el-button>
          </template>
          <template v-else>
            <el-button type="primary" @click="handleSave" :loading="loading">保存</el-button>
            <el-button @click="handleCancel">取消</el-button>
          </template>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { userApi } from '@/api'

const userStore = useUserStore()

const formRef = ref(null)
const loading = ref(false)
const isEditing = ref(false)

const form = reactive({
  id: null,
  username: '',
  realName: '',
  phone: '',
  email: '',
  department: ''
})

const originalForm = ref({})

const roleText = computed(() => {
  const roleMap = {
    'admin': '系统管理员',
    'safety_admin': '安全管理员',
    'user': '普通员工'
  }
  return roleMap[userStore.role] || ''
})

const rules = {
  realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
  phone: [{ pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }],
  email: [{ type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }]
}

const loadUserInfo = async () => {
  try {
    let res
    if (userStore.role === 'admin') {
      res = await userApi.getAdminById(userStore.userId)
    } else if (userStore.role === 'safety_admin') {
      res = await userApi.getSafetyAdminById(userStore.userId)
    } else {
      res = await userApi.getUserById(userStore.userId)
    }
    
    if (res.data) {
      Object.assign(form, res.data)
      originalForm.value = { ...res.data }
    }
  } catch (error) {
    console.error('加载用户信息失败：', error)
  }
}

const handleSave = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    if (userStore.role === 'admin') {
      await userApi.updateAdmin(form)
    } else if (userStore.role === 'safety_admin') {
      await userApi.updateSafetyAdmin(form)
    } else {
      await userApi.updateUser(form)
    }
    
    // 更新本地存储的用户信息
    userStore.updateUserInfo({
      realName: form.realName
    })
    
    originalForm.value = { ...form }
    isEditing.value = false
    ElMessage.success('保存成功')
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const handleCancel = () => {
  Object.assign(form, originalForm.value)
  isEditing.value = false
}

onMounted(() => {
  loadUserInfo()
})
</script>

<style lang="scss" scoped>
.form-container {
  max-width: 500px;
}
</style>
