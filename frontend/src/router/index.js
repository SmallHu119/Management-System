import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录', requiresAuth: false }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue'),
    meta: { title: '注册', requiresAuth: false }
  },
  {
    path: '/',
    component: () => import('@/layouts/MainLayout.vue'),
    redirect: '/dashboard',
    children: [
      // 首页
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue'),
        meta: { title: '首页', icon: 'HomeFilled' }
      },
      // 个人中心
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('@/views/Profile.vue'),
        meta: { title: '个人中心', icon: 'User' }
      },
      // 危化品管理
      {
        path: 'hazmat',
        name: 'Hazmat',
        redirect: '/hazmat/list',
        meta: { title: '危化品管理', icon: 'Warning' },
        children: [
          {
            path: 'list',
            name: 'HazmatList',
            component: () => import('@/views/hazmat/HazmatList.vue'),
            meta: { title: '危化品列表' }
          },
          {
            path: 'category',
            name: 'HazmatCategory',
            component: () => import('@/views/hazmat/CategoryList.vue'),
            meta: { title: '类别管理', roles: ['admin'] }
          },
          {
            path: 'detail/:id',
            name: 'HazmatDetail',
            component: () => import('@/views/hazmat/HazmatDetail.vue'),
            meta: { title: '危化品详情', hidden: true }
          }
        ]
      },
      // 安全检查
      {
        path: 'check',
        name: 'Check',
        redirect: '/check/plan',
        meta: { title: '安全检查', icon: 'DocumentChecked', roles: ['admin', 'safety_admin'] },
        children: [
          {
            path: 'plan',
            name: 'CheckPlan',
            component: () => import('@/views/check/PlanList.vue'),
            meta: { title: '检查计划' }
          },
          {
            path: 'record',
            name: 'CheckRecord',
            component: () => import('@/views/check/RecordList.vue'),
            meta: { title: '检查记录' }
          }
        ]
      },
      // 隐患管理
      {
        path: 'hazard',
        name: 'Hazard',
        redirect: '/hazard/list',
        meta: { title: '隐患管理', icon: 'Bell' },
        children: [
          {
            path: 'list',
            name: 'HazardList',
            component: () => import('@/views/hazard/HazardList.vue'),
            meta: { title: '隐患列表', roles: ['admin', 'safety_admin'] }
          },
          {
            path: 'report',
            name: 'HazardReport',
            component: () => import('@/views/hazard/HazardReport.vue'),
            meta: { title: '隐患上报' }
          },
          {
            path: 'my',
            name: 'MyHazards',
            component: () => import('@/views/hazard/MyHazards.vue'),
            meta: { title: '我的上报', roles: ['user'] }
          }
        ]
      },
      // 安全知识
      {
        path: 'knowledge',
        name: 'Knowledge',
        redirect: '/knowledge/list',
        meta: { title: '安全知识', icon: 'Reading' },
        children: [
          {
            path: 'list',
            name: 'KnowledgeList',
            component: () => import('@/views/knowledge/KnowledgeList.vue'),
            meta: { title: '知识列表' }
          },
          {
            path: 'manage',
            name: 'KnowledgeManage',
            component: () => import('@/views/knowledge/KnowledgeManage.vue'),
            meta: { title: '知识管理', roles: ['admin', 'safety_admin'] }
          },
          {
            path: 'detail/:id',
            name: 'KnowledgeDetail',
            component: () => import('@/views/knowledge/KnowledgeDetail.vue'),
            meta: { title: '知识详情', hidden: true }
          }
        ]
      },
      // 公告管理
      {
        path: 'announcement',
        name: 'Announcement',
        redirect: '/announcement/list',
        meta: { title: '公告管理', icon: 'Notification', roles: ['admin'] },
        children: [
          {
            path: 'list',
            name: 'AnnouncementList',
            component: () => import('@/views/announcement/AnnouncementList.vue'),
            meta: { title: '公告列表' }
          }
        ]
      },
      // 用户管理
      {
        path: 'user',
        name: 'User',
        redirect: '/user/list',
        meta: { title: '用户管理', icon: 'UserFilled', roles: ['admin'] },
        children: [
          {
            path: 'list',
            name: 'UserList',
            component: () => import('@/views/user/UserList.vue'),
            meta: { title: '员工管理' }
          },
          {
            path: 'safety-admin',
            name: 'SafetyAdminList',
            component: () => import('@/views/user/SafetyAdminList.vue'),
            meta: { title: '安全管理员' }
          }
        ]
      },
      // 风险监测与预警
      {
        path: 'monitoring',
        name: 'Monitoring',
        redirect: '/monitoring/realtime',
        meta: { title: '风险监测与预警', icon: 'Monitor', roles: ['admin', 'safety_admin'] },
        children: [
          {
            path: 'parameter',
            name: 'MonitoringParameter',
            component: () => import('@/views/monitoring/ParameterList.vue'),
            meta: { title: '监测参数管理', roles: ['admin'] }
          },
          {
            path: 'warning-rule',
            name: 'WarningRule',
            component: () => import('@/views/monitoring/WarningRules.vue'),
            meta: { title: '预警规则配置', roles: ['admin', 'safety_admin'] }
          },
          {
            path: 'realtime',
            name: 'RealTimeMonitoring',
            component: () => import('@/views/monitoring/MonitoringData.vue'),
            meta: { title: '实时监测数据' }
          },
          {
            path: 'warning-record',
            name: 'WarningRecord',
            component: () => import('@/views/monitoring/WarningRecords.vue'),
            meta: { title: '预警记录管理' }
          },
          {
            path: 'statistics',
            name: 'MonitoringStatistics',
            component: () => import('@/views/monitoring/MonitoringStatistics.vue'),
            meta: { title: '监测统计分析', roles: ['admin', 'safety_admin'] }
          }
        ]
      }
    ]
  },
  // 404页面
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFound.vue'),
    meta: { title: '页面不存在', requiresAuth: false }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 设置页面标题
  document.title = to.meta.title ? `${to.meta.title} - 企业危化品安全管理系统` : '企业危化品安全管理系统'
  
  const token = localStorage.getItem('token')
  const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}')
  
  // 不需要认证的页面
  if (to.meta.requiresAuth === false) {
    if (token && (to.path === '/login' || to.path === '/register')) {
      next('/dashboard')
    } else {
      next()
    }
    return
  }
  
  // 需要认证的页面
  if (!token) {
    next('/login')
    return
  }
  
  // 检查角色权限
  if (to.meta.roles && to.meta.roles.length > 0) {
    if (!to.meta.roles.includes(userInfo.role)) {
      next('/dashboard')
      return
    }
  }
  
  next()
})

export default router
