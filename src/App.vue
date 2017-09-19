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
      .ui.positive.fluid.button(@click="startDraw") 變魔法吧！

    .ui.container#magic
      .ui.segment
        .loader-spin
        h2.ui.center.aligned.header(style="margin-top: 4em; margin-bottom: 1.5em") 正在施展黑魔法，請稍候 ……

    .ui.container#dala
      .ui.segment
        h1.ui.center.aligned.header(style="margin-top: .3em; margin-bottom: .5em") {{ partyPopperEmoji }} 搭拉！
        .ui.three.column.grid(v-for="(resultsCol, index) in results")
          .centered.column(v-for="(seatNumber, index) in resultsCol")
            .ui.fluid.card
              .image
                img(src='./assets/boy.png', v-if="isBoy(seatNumber)")
                img(src='./assets/girl.png', v-else)
              .content
                p.header(v-if="isBoy(seatNumber)") {{ seatNumber }} 號男同學
                p.header(v-else) {{ seatNumber }} 號女同學

    h4.ui.center.aligned.header(style="margin-top: 3em; margin-bottom: 1.5em")
      | Copyright &copy; 2017 Birkhoff Lee.
      | &nbsp;
      a(href="https://github.com/BirkhoffLee/cherry-pick") Source code
</template>

<script>
  import Steps from './components/Steps'

  let range = (start, end) => {
    return Array(end - start + 1).fill().map((_, idx) => start + idx)
  }

  let flattenArray = array => {
    return array.reduce((a, b) => {
      return a.concat(b)
    }, [])
  }

  let times = x => f => {
    if (x > 0) {
      f()
      times(x - 1)(f)
    }
  }

  // https://stackoverflow.com/a/6274398/2465955
  let shuffle = array => {
    let counter = array.length

    // While there are elements in the array
    while (counter > 0) {
      // Pick a random index
      let index = Math.floor(Math.random() * counter)

      // Decrease counter by 1
      counter--

      // And swap the last element with it
      let temp = array[counter]
      array[counter] = array[index]
      array[index] = temp
    }

    return array
  }

  let unflatten = (arrayToUnflatten, unflattenLength) => {
    return Promise.all(new Array(Math.ceil(arrayToUnflatten.length / unflattenLength)).fill('').map((_, index) => new Promise(resolve => {
      resolve(arrayToUnflatten.slice(index * unflattenLength, index * unflattenLength + unflattenLength))
    })))
  }

  export default {
    components: {
      Steps
    },

    data () {
      return {
        seatNumberAmounts: 1,
        ghostSeatNumberRows: 3,
        ghostSeatNumbers: [],
        seatNumberBoyFrom: 1,
        seatNumberBoyTo: 20,
        seatNumberGirlFrom: 21,
        seatNumberGirlTo: 35,
        // seatNumberBoyFrom: null,
        // seatNumberBoyTo: null,
        // seatNumberGirlFrom: null,
        // seatNumberGirlTo: null,
        results: null,
        partyPopperEmoji: String.fromCodePoint(127881)
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

      addAmount () {
        this.seatNumberAmounts++

        $('#minusButton').attr('disabled', false)
      },

      minusAmount () {
        this.seatNumberAmounts--

        if (this.seatNumberAmounts === 1) {
          $('#minusButton').attr('disabled', true)
        }
      },

      calculate () {
        let self = this
        let possibleSeatNumbers = []

        possibleSeatNumbers.push(range(parseInt(this.seatNumberBoyFrom), parseInt(this.seatNumberBoyTo)))
        possibleSeatNumbers.push(range(parseInt(this.seatNumberGirlFrom), parseInt(this.seatNumberGirlTo)))

        possibleSeatNumbers = flattenArray(possibleSeatNumbers)
        possibleSeatNumbers = possibleSeatNumbers.filter((e) => !this.ghostSeatNumbers.map(Number).includes(e))
        possibleSeatNumbers = shuffle(possibleSeatNumbers)

        Promise.all((new Array(parseInt(this.seatNumberAmounts)).fill('')).map(() => new Promise((resolve) => {
          let seatNumber = possibleSeatNumbers[Math.floor(Math.random() * possibleSeatNumbers.length)]
          resolve(seatNumber)
        })))
        .then((result) => unflatten(result, 3))
        .then((result) => { self.results = result })
      },

      startDraw () {
        let self = this

        $('#settings-step').addClass('disabled')
        $('#settings-step').removeClass('active')
        $('#draw-step').addClass('active')
        $('#draw-step').removeClass('disabled')

        $('#form').transition({
          animation: 'fly left',
          onComplete: function () {
            $('#magic').transition({
              animation: 'fly right',
              onComplete: function () {
                self.calculate()

                setTimeout(function () {
                  self.endDraw()
                }, 1300)
              }
            })
          }
        })
      },

      endDraw () {
        $('#draw-step').addClass('disabled')
        $('#draw-step').removeClass('active')
        $('#dala-step').addClass('active')
        $('#dala-step').removeClass('disabled')

        $('#magic').transition({
          animation: 'fly left',
          onComplete: function () {
            $('#dala').transition({
              animation: 'fly right'
              // onComplete: function () {

              // }
            })
          }
        })
      },

      isBoy (number) {
        if (number >= this.seatNumberBoyFrom && number <= this.seatNumberBoyTo) {
          return true
        } else if (number >= this.seatNumberGirlFrom && number <= this.seatNumberGirlTo) {
          return false
        }

        return null
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

#magic {
  width: 40%;
  display: none
}

#dala {
  width: 45%;
  display: none
}

#label-to {
  width: 100%;
  text-align: center;
  border: 0px
}

.loader-spin * {
	box-sizing: border-box;
		-o-box-sizing: border-box;
		-ms-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		-moz-box-sizing: border-box;
}

.loader-spin {
	width: 1em;
	height: 1em;
	font-size: 188px;
	position: relative;
	display:block;
	margin: 63px auto;
}

.loader-spin:before, .loader-spin:after {
	content: "";
	top: 0;
	display: block;
	width: 1em;
	height: 1em;
	position: absolute;
	border-width: 0.5em;
	border-style: double;
	border-color: transparent;
	border-radius: 1em;
	box-sizing: border-box;
		-o-box-sizing: border-box;
		-ms-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		-moz-box-sizing: border-box;
	animation: spin 1.15s infinite;
		-o-animation: spin 1.15s infinite;
		-ms-animation: spin 1.15s infinite;
		-webkit-animation: spin 1.15s infinite;
		-moz-animation: spin 1.15s infinite;
}

.loader-spin:after {
	left: 0;
	border-left-color: rgb(0,0,0);
}

.loader-spin:before {
	right: 0;
	border-right-color: rgb(0,0,0);
	animation-delay: -0.29s;
		-o-animation-delay: -0.29s;
		-ms-animation-delay: -0.29s;
		-webkit-animation-delay: -0.29s;
		-moz-animation-delay: -0.29s;
}

@keyframes spin {
	from {
		transform: rotate(360deg);
	}
}

@-o-keyframes spin {
	from {
		-o-transform: rotate(360deg);
	}
}

@-ms-keyframes spin {
	from {
		-ms-transform: rotate(360deg);
	}
}

@-webkit-keyframes spin {
	from {
		-webkit-transform: rotate(360deg);
	}
}

@-moz-keyframes spin {
	from {
		-moz-transform: rotate(360deg);
	}
}
</style>