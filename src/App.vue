<template lang="pug">
  div#app

    h1.ui.center.aligned.header 敲公平抽籤系統兒

    Steps
    
    .ui.container#form
      .ui.segment
        form.ui.form
          .field
            label 男生座號範圍
            .fields
              .seven.wide.field
                .ui.labeled.left.icon.input
                  i.man.icon
                  input(type='text', v-model='seatNumberBoyFrom', placeholder='如：1', v-on:keypress='numberCheck()')
              .two.wide.field
                .ui.labeled.input
                  .ui.basic.label#label-to ~
              .seven.wide.field
                .ui.labeled.left.icon.input
                  i.man.icon
                  input(type='text', v-model='seatNumberBoyTo', placeholder='如：20', v-on:keypress='numberCheck()')
          .field
            label 女生座號範圍
            .fields
              .seven.wide.field
                .ui.labeled.left.icon.input
                  i.woman.icon
                  input(type='text', v-model='seatNumberGirlFrom', placeholder='如：21', v-on:keypress='numberCheck()')
              .two.wide.field
                .ui.labeled.input
                  .ui.basic.label#label-to ~
              .seven.wide.field
                .ui.labeled.left.icon.input
                  i.woman.icon
                  input(type='text', v-model='seatNumberGirlTo', placeholder='如：35', v-on:keypress='numberCheck()')
          .field
            label 幽靈座號（缺席座號）
            .three.fields(v-for="(i, j) in ghostSeatNumberRows")
              .field(v-for="(k, l) in 3")
                input(type='text', v-model='ghostSeatNumbers[j * ghostSeatNumberRows + l]', placeholder='如：17', v-on:keypress='numberCheck()')
          .field
            label 要抽多少個座號？
            .ui.action.input
              input(v-model='seatNumberAmounts', type='text', placeholder='輸入數量，或使用旁邊的按鈕', v-on:keypress='numberCheck()')
              button#plusButton.ui.icon.positive.button(type='button', @click='addAmount')
                i.plus.icon
              button#minusButton.ui.icon.button(type='button', @click='minusAmount', disabled)
                i.minus.icon
      .ui.positive.fluid.button 變魔法吧！
      
    h4.ui.center.aligned.header(style="margin-top: 3em; margin-bottom: 1.5em")
      | Copyright &copy; 2017 Birkhoff Lee.
      | &nbsp;
      a(href="https://github.com/BirkhoffLee/cherry-pick") Source code
</template>

<script>
  import Steps from './components/Steps'

  export default {
    components: {
      Steps
    },

    data () {
      return {
        seatNumberAmounts: 1,
        ghostSeatNumberRows: 3,
        ghostSeatNumbers: [],
        seatNumberBoyFrom: null,
        seatNumberBoyTo: null,
        seatNumberGirlFrom: null,
        seatNumberGirlTo: null
      }
    },

    methods: {
      numberCheck: function (e) {
        e = e || window.event
        var charCode = (e.which) ? e.which : e.keyCode

        if ((charCode > 31 && (charCode < 48 || charCode > 57)) && charCode !== 46) {
          e.preventDefault()
        }

        return true
      },

      addAmount: function () {
        this.seatNumberAmounts++

        $('#minusButton').attr('disabled', false)
      },

      minusAmount: function () {
        this.seatNumberAmounts--

        if (this.seatNumberAmounts === 1) {
          $('#minusButton').attr('disabled', true)
        }
      }
    }
  }

  $(document).ready(function () {
  })
</script>

<style>
#app {
  margin-top: 3em
}

#form {
  width: 30%
}

#label-to {
  width: 100%;
  text-align: center;
  border: 0px
}
</style>