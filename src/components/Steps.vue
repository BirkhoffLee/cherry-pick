<template lang="pug">
  div.ui.container(style="padding-top: 1.5em; padding-bottom: 3em")
    div.ui.three.steps
      div.active.step#settings-step
        i.settings.icon
        div.content
          div.title
            | 設定
          div.description
            | 設定籤筒

      div.disabled.step#draw-step
        i.refresh.icon
        div.content
          div.title
            | 抽籤
          div.description
            | 等待我們變魔法

      div.disabled.step#dala-step
        i.birthday.icon
        div.content
          div.title
            | 搭拉！
          div.description
            | 看看誰中獎惹
</template>

<script>
export default {
  name: 'steps',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
