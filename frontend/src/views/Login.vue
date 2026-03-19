<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <el-icon size="48" color="#409eff"><Warning /></el-icon>
        <h1>企业危化品安全管理系统</h1>
        <p>Hazardous Chemical Safety Management System</p>
      </div>
      
      <el-form ref="formRef" :model="form" :rules="rules" class="login-form">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" size="large">
            <template #prefix>
              <el-icon><User /></el-icon>
            </template>
          </el-input>
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" size="large" show-password @keyup.enter="handleLogin">
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>
        
        <el-form-item prop="userType">
          <el-select v-model="form.userType" placeholder="请选择用户类型" size="large" style="width: 100%">
            <el-option label="普通员工" value="user" />
            <el-option label="安全管理员" value="safety_admin" />
            <el-option label="系统管理员" value="admin" />
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" size="large" style="width: 100%" :loading="loading" @click="handleLogin">
            登 录
          </el-button>
        </el-form-item>
        
        <div class="login-footer">
          <span>还没有账号？</span>
          <el-link type="primary" @click="$router.push('/register')">立即注册</el-link>
        </div>
      </el-form>
      
      <div class="demo-accounts">
        <el-divider>测试账号</el-divider>
        <div class="account-list">
          <div class="account-item">
            <span class="label">系统管理员：</span>
            <span class="value">admin / admin123</span>
          </div>
          <div class="account-item">
            <span class="label">安全管理员：</span>
            <span class="value">safety / safety123</span>
          </div>
          <div class="account-item">
            <span class="label">普通员工：</span>
            <span class="value">注册后使用</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()

const formRef = ref(null)
const loading = ref(false)

const form = reactive({
  username: '',
  password: '',
  userType: 'user'
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
  userType: [{ required: true, message: '请选择用户类型', trigger: 'change' }]
}

const handleLogin = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    await userStore.login(form)
    ElMessage.success('登录成功')
    router.push('/dashboard')
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.login-box {
  width: 100%;
  max-width: 420px;
  background: #fff;
  border-radius: 12px;
  padding: 40px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;

  h1 {
    font-size: 22px;
    color: #303133;
    margin: 15px 0 8px;
  }

  p {
    font-size: 12px;
    color: #909399;
  }
}

.login-form {
  .el-form-item {
    margin-bottom: 24px;
  }
}

.login-footer {
  text-align: center;
  color: #909399;
  font-size: 14px;
}

.demo-accounts {
  margin-top: 20px;
  
  .account-list {
    font-size: 12px;
    color: #909399;
    
    .account-item {
      display: flex;
      justify-content: space-between;
      padding: 4px 0;
      
      .label {
        color: #606266;
      }
      
      .value {
        font-family: monospace;
      }
    }
  }
}
</style>
