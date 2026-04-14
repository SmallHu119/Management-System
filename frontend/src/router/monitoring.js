/**
 * 监测预警模块路由配置
 */
export default [
  {
    path: '/monitoring',
    name: 'Monitoring',
    redirect: '/monitoring/dashboard',
    meta: { title: '监测预警', icon: 'Monitor' },
    children: [
      {
        path: 'dashboard',
        name: 'MonitoringDashboard',
        component: () => import('@/views/monitoring/MonitoringDashboard.vue'),
        meta: { title: '监测概览', icon: 'DataAnalysis' }
      },
      {
        path: 'data',
        name: 'MonitoringData',
        component: () => import('@/views/monitoring/MonitoringData.vue'),
        meta: { title: '实时监测', icon: 'Odometer' }
      },
      {
        path: 'warning-records',
        name: 'WarningRecords',
        component: () => import('@/views/monitoring/WarningRecords.vue'),
        meta: { title: '预警记录', icon: 'Warning' }
      },
      {
        path: 'warning-rules',
        name: 'WarningRules',
        component: () => import('@/views/monitoring/WarningRules.vue'),
        meta: { title: '预警规则', icon: 'SetUp' }
      },
      {
        path: 'parameter-config',
        name: 'ParameterConfig',
        component: () => import('@/views/monitoring/ParameterConfig.vue'),
        meta: { title: '参数配置', icon: 'Setting' }
      }
    ]
  }
]
