import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '@/api'
import router from '@/router'

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref(localStorage.getItem('token') || '')
  const userInfo = ref(JSON.parse(localStorage.getItem('userInfo') || '{}'))

  // 计算属性
  const isLoggedIn = computed(() => !!token.value)
  const username = computed(() => userInfo.value.username || '')
  const realName = computed(() => userInfo.value.realName || userInfo.value.username || '')
  const role = computed(() => userInfo.value.role || '')
  const userId = computed(() => userInfo.value.userId || null)

  // 角色判断
  const isAdmin = computed(() => role.value === 'admin')
  const isSafetyAdmin = computed(() => role.value === 'safety_admin')
  const isUser = computed(() => role.value === 'user')

  // 登录
  async function login(loginData) {
    const res = await authApi.login(loginData)
    if (res.code === 200) {
      token.value = res.data.token
      userInfo.value = {
        userId: res.data.userId,
        username: res.data.username,
        realName: res.data.realName,
        role: res.data.role,
        avatar: res.data.avatar
      }
      localStorage.setItem('token', res.data.token)
      localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
      return res.data
    }
    throw new Error(res.message)
  }

  // 注册
  async function register(registerData) {
    const res = await authApi.register(registerData)
    if (res.code === 200) {
      return true
    }
    throw new Error(res.message)
  }

  // 登出
  function logout() {
    token.value = ''
    userInfo.value = {}
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
    router.push('/login')
  }

  // 修改密码
  async function changePassword(data) {
    const res = await authApi.changePassword(data)
    if (res.code === 200) {
      return true
    }
    throw new Error(res.message)
  }

  // 更新用户信息
  function updateUserInfo(info) {
    userInfo.value = { ...userInfo.value, ...info }
    localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
  }

  return {
    token,
    userInfo,
    isLoggedIn,
    username,
    realName,
    role,
    userId,
    isAdmin,
    isSafetyAdmin,
    isUser,
    login,
    register,
    logout,
    changePassword,
    updateUserInfo
  }
})
