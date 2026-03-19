<template>
  <div class="not-found">
    <div class="content">
      <h1>404</h1>
      <h2>页面不存在</h2>
      <p>抱歉，您访问的页面不存在或已被删除</p>
      <el-button type="primary" @click="$router.push('/dashboard')">
        返回首页
      </el-button>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.not-found {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  
  .content {
    text-align: center;
    color: #fff;
    
    h1 {
      font-size: 120px;
      font-weight: bold;
      margin: 0;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
    }
    
    h2 {
      font-size: 32px;
      margin: 20px 0;
    }
    
    p {
      font-size: 16px;
      opacity: 0.8;
      margin-bottom: 30px;
    }
  }
}
</style>
