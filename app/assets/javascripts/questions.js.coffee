class QuizPage
  timeLimit: 10 # in seconds

  constructor: (@page) ->
    @timer = @page.find('.timer')
    @question_id = @page.find('input#question_id')
    @answerButton = @page.find('.answer-field')
    @answer = @page.find('.answer')
    @points = @page.find('.points')
    @setBehaviors()

  setBehaviors: ->
    @answerButton.find('.btn').on 'click', (e) =>
      e.preventDefault()
      @answerButton.addClass('hide')
      @answer.removeClass('hide')
      @revealPoints()

  startTimer: ->
    @timer.countdown(
      until: @timeLimit, format: 'S'
      onExpiry: =>
        @timer.countdown('destroy')
        @timesUp()
    )

  revealPoints: ->
    @points.removeClass('hide')
    $.get "/play/answers", { question_id: @question_id.val() }

  timesUp: ->
    @timer.slideUp()
    @answerButton.removeClass('hide')
    # TODO: show all teams answers

$ ->
  if $('#quiz-server').length
    $quiz = $('.quiz-page')
    if $quiz.length > 0
      quizPage = new QuizPage($quiz)
      quizPage.startTimer()
