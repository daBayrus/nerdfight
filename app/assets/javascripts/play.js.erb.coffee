class PlayPage
  timeLimit: 10 # in seconds

  constructor: (@page) ->
    @timer = @page.find('.timer')
    @question = @page.find('.question')
    @question_id = @page.find('input#question_id')
    @asked = @page.find('h1 span')
    @points = @page.find('h1 small')
    @answer = @page.find('input#answer')

    # @setBehaviors()

  setBehaviors: ->
    # @answerButton.find('.btn').on 'click', (e) =>
    #   e.preventDefault()
    #   @answerButton.addClass('hide')
    #   @answer.removeClass('hide')
    #   @revealPoints()

  setContents: (data) ->
    @answer.removeAttr('readonly').val('')
    @question_id.val data.id
    @question.text data.content
    @asked.text data.asked
    @points.text ' ' + data.points + '-pt'

    @setRankings()
    @startTimer()

  setRankings: ->
    $.get "/play/rankings"

  startTimer: ->
    @timer.slideDown()
    @timer.countdown(
      until: @timeLimit, format: 'S'
      onExpiry: =>
        @timer.countdown('destroy')
        @timesUp()
    )

  revealPoints: ->
    @points.removeClass('hide')

  timesUp: ->
    @timer.slideUp()
    @answer.attr('readonly', true)
    @submitAnswer(@question_id.val(), @answer.val())

  submitAnswer: (q, ans) ->
    $.post "/play/buzz", { question_id: q, answer: ans }

$ ->
  if $('#quiz-client').length
    $play = $('#quiz-client')
    $wait = $('#waiting')

    # Show current question
    PrivatePub.subscribe "/questions/active", (data, channel) ->
      playPage = new PlayPage($play)
      playPage.setContents(data)

      $wait.addClass 'hidden'
      $play.removeClass 'hidden'

    # Load next question
    PrivatePub.subscribe "/questions/new", (data, channel) ->
      window.location.reload()

