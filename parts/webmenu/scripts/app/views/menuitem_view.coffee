define [
  "underscore"
  "app/views/spin"
  "backbone.viewmaster"

  "hbs!app/templates/menuitem"
  "app/utils/debounce"
  "cs!app/application"
], (
  _
  spin
  ViewMaster

  template
  debounce
  Application
) ->

  class MenuItemView extends ViewMaster

    className: "bb-menu-item"

    template: template

    constructor: ->
      super

      # Make sure that single app can be opened only once in 250ms. Prevents
      # situations when holding down enter key might spawn multiple instances
      # of the same app
      @open = _.throttle(@open, 250)

      @$el.addClass "item-" + @model.get("name")
        .toLowerCase()
        .replace(/[^a-z]/g, "")

      @$el.addClass("type-#{ @model.get("type") }")

      if @isInactive()
        @$el.addClass "inactive"

      @listenTo this, "hide-window", =>
        @$img.removeClass("rotate-loading")

    events:
      "click": "open"
      "mouseover": "toggleInactiveNotify"
      "mouseout": "toggleInactiveNotify"

    elements:
      "$thumbnail": ".thumbnail"
      "$description": ".description"
      "$img": "img"

    open: ->
      if @isInactive()
        return

      if @model.get("type") is "menu"
        @bubble "open-menu", @model
      else
        @bubble "open-app", @model
        @model.incClicks()
        @$img.addClass("rotate-loading")

    toggleInactiveNotify: ->
      if @isInactive()
        @$('.inactiveNotify').toggle()

    context: ->
      json = super()
      json.menu = @model.get("type") is "menu"
      return json

    displaySelectHighlight: ->
      @$el.addClass "selectHighlight"

    hideSelectHighlight: ->
      @$el.removeClass "selectHighlight"

    scrollTo: ->
      @bubble "scrollTo", @

    isInactive: ->
      @model.get("status") is "inactive"
