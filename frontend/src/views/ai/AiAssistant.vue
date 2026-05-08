<template>
  <div class="ai-assistant">
    <el-card shadow="never" class="chat-card">
      <template #header>
        <div class="chat-header">
          <span class="title">
            <el-icon color="#409EFF"><ChatDotRound /></el-icon>
            AI安全助手
          </span>
          <el-button text type="danger" size="small" @click="handleClear" :loading="clearing">
            清除对话
          </el-button>
        </div>
      </template>

      <div class="chat-body" ref="chatBody">
        <div v-if="messages.length === 0" class="welcome">
          <el-icon size="48" color="#409EFF"><ChatDotRound /></el-icon>
          <h3>我是危化品安全管理AI助手</h3>
          <p>可以向我咨询危化品储存、安全检查、隐患处理、预警解读等问题</p>
          <div class="quick-questions">
            <el-tag
              v-for="q in quickQuestions"
              :key="q"
              class="quick-tag"
              @click="sendQuickQuestion(q)"
            >
              {{ q }}
            </el-tag>
          </div>
        </div>

        <div v-for="(msg, idx) in messages" :key="idx" class="msg-row" :class="msg.role">
          <div class="msg-avatar">
            <el-avatar :size="36" v-if="msg.role === 'user'">
              {{ userStore.realName?.charAt(0) || 'U' }}
            </el-avatar>
            <el-avatar :size="36" v-else style="background:#409EFF">
              <el-icon><Cpu /></el-icon>
            </el-avatar>
          </div>
          <div class="msg-bubble" :class="msg.role">
            <div class="msg-text">{{ msg.content }}</div>
            <div class="msg-time">{{ msg.time }}</div>
          </div>
        </div>

        <div v-if="loading" class="msg-row assistant">
          <div class="msg-avatar">
            <el-avatar :size="36" style="background:#409EFF">
              <el-icon><Cpu /></el-icon>
            </el-avatar>
          </div>
          <div class="msg-bubble assistant typing">
            <span class="dot"></span><span class="dot"></span><span class="dot"></span>
          </div>
        </div>
      </div>

      <div class="chat-input">
        <el-input
          v-model="inputText"
          placeholder="请输入您的问题..."
          :disabled="loading"
          @keyup.enter="handleSend"
          resize="none"
        >
          <template #append>
            <el-button :disabled="!inputText.trim() || loading" type="primary" @click="handleSend">
              <el-icon><Promotion /></el-icon>
            </el-button>
          </template>
        </el-input>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { aiApi } from '@/api'

const userStore = useUserStore()

const messages = ref([])
const inputText = ref('')
const loading = ref(false)
const clearing = ref(false)
const chatBody = ref(null)

const quickQuestions = [
  '硫酸储存有哪些注意事项？',
  '发现盐酸泄漏应该怎么做？',
  '预警级别是如何划分的？',
  '检查计划到期了会提醒吗？'
]

const formatTime = () => {
  const now = new Date()
  return `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
}

const scrollToBottom = async () => {
  await nextTick()
  if (chatBody.value) {
    chatBody.value.scrollTop = chatBody.value.scrollHeight
  }
}

const handleSend = async () => {
  const text = inputText.value.trim()
  if (!text || loading.value) return

  messages.value.push({ role: 'user', content: text, time: formatTime() })
  inputText.value = ''
  loading.value = true
  await scrollToBottom()

  try {
    const res = await aiApi.chat(text)
    if (res.code === 200) {
      messages.value.push({ role: 'assistant', content: res.data.reply, time: formatTime() })
    } else {
      messages.value.push({ role: 'assistant', content: '抱歉，AI服务暂时不可用', time: formatTime() })
    }
  } catch (error) {
    messages.value.push({ role: 'assistant', content: '网络异常，请稍后重试', time: formatTime() })
  } finally {
    loading.value = false
    await scrollToBottom()
  }
}

const sendQuickQuestion = (q) => {
  inputText.value = q
  handleSend()
}

const handleClear = async () => {
  clearing.value = true
  try {
    await aiApi.clearHistory()
    messages.value = []
    ElMessage.success('对话已清除')
  } catch {
    messages.value = []
  } finally {
    clearing.value = false
  }
}

onMounted(() => {
  inputText.value = ''
})
</script>

<style lang="scss" scoped>
.ai-assistant {
  height: calc(100vh - 140px);
  padding: 0 20px;

  .chat-card {
    height: 100%;
    display: flex;
    flex-direction: column;

    :deep(.el-card__header) {
      padding: 12px 20px;
    }

    :deep(.el-card__body) {
      flex: 1;
      display: flex;
      flex-direction: column;
      padding: 0;
      overflow: hidden;
    }
  }
}

.chat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;

  .title {
    font-size: 16px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 8px;
  }
}

.chat-body {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: #f5f7fa;
}

.welcome {
  text-align: center;
  padding: 60px 20px;
  color: #909399;

  h3 {
    margin: 16px 0 8px;
    color: #303133;
  }

  p {
    margin-bottom: 20px;
    font-size: 14px;
  }
}

.quick-questions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 10px;

  .quick-tag {
    cursor: pointer;
    padding: 8px 16px;
    font-size: 13px;
    border-radius: 20px;
    transition: all 0.2s;

    &:hover {
      background: #409EFF;
      color: #fff;
      border-color: #409EFF;
    }
  }
}

.msg-row {
  display: flex;
  margin-bottom: 20px;
  gap: 12px;

  &.user {
    flex-direction: row-reverse;
  }
}

.msg-avatar {
  flex-shrink: 0;
}

.msg-bubble {
  max-width: 70%;
  padding: 12px 16px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.6;

  &.user {
    background: #409EFF;
    color: #fff;
    border-bottom-right-radius: 4px;
  }

  &.assistant {
    background: #fff;
    color: #303133;
    border-bottom-left-radius: 4px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
  }
}

.msg-time {
  font-size: 11px;
  margin-top: 4px;
  opacity: 0.6;
}

.typing {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 16px 20px;

  .dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #c0c4cc;
    animation: typingBounce 1.4s infinite both;

    &:nth-child(2) { animation-delay: 0.2s; }
    &:nth-child(3) { animation-delay: 0.4s; }
  }
}

@keyframes typingBounce {
  0%, 60%, 100% { transform: translateY(0); }
  30% { transform: translateY(-8px); }
}

.chat-input {
  padding: 12px 20px;
  border-top: 1px solid #ebeef5;
  background: #fff;

  :deep(.el-input-group__append) {
    padding: 0 8px;
  }
}
</style>
