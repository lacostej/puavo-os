define [
  "cs!app/view"
  "moment"
  "underscore"
], (View, moment, _) ->

  padZero = (num, size) ->
    s = num + ""
    while s.length < size
      s = "0" + s
    s

  class WlanStats extends View

    className: "bb-wlan-stats"
    templateQuery: "#wlan-stats"

    events:
      "click": (e) ->
        @model.trigger "select", @model
        @animate()

    constructor: (opts) ->
      super
      @previousCount = 0
      @model.clients.on "add remove change", =>
        @render()

      @model.collection.on "select", (model) =>
        @disableAnimation = true
        @selected = model.id is @model.id
        @render()

    animate: ->

      console.info "ANIM", @model.clients.activeClientCount(), @previousCount

      if @disableAnimation
        @disableAnimation = false
        return

      if @model.clients.activeClientCount() is @previousCount
        return

      if @model.clients.activeClientCount() > @previousCount
        @animateClientConnected()
      else
        @animateClientLeft()

      @animTimer = setTimeout =>
        @clearAnimation()
      , 1300

      @previousCount = @model.clients.activeClientCount()

    animateClientConnected: -> @$el.addClass "animated tada"
    animateClientLeft: -> @$el.addClass "animated wobble"

    clearAnimation: ->
      clearTimeout @animTimer if @animTimer
      @$el.removeClass "animated wobble tada"

    viewJSON: ->
      count: @model.activeClientCount()
      name: @model.id

    render: ->
      @clearAnimation()
      console.info "render", @model.id
      super
      imgId = padZero  @model.relativeSize(), 2
      url = "/img/wlan/wlan#{ imgId }.png"
      @$el.css "background-image", "url(#{ url })"
      if @selected
        @$el.addClass "selected"
      else
        @$el.removeClass "selected"
      @animate()

