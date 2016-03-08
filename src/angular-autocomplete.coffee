'use strict'

###*
 # @ngdoc directive
 # @name angular-select2
 # @description
 #
###

###
#
# @private
#
###

parseData = (result,params,scope,filter)->
  filterResult = filter('filter')(result, params.term)

  data = $.map filterResult, (item)->
    response =
      id: item[scope.id]
      text: item[scope.text]
      $object: item
    #

    unless scope.hasOwnProperty("subtitle")
      scope.subtitle = "subtitle"
      scope.subtitleLabel = scope.subtitle
    #

    response.subtitle = item[scope.subtitle]
    response.subtitleLabel = scope.subtitle
    response.picture = item[scope.picture] if scope.hasOwnProperty("picture")
    response
  #...
  return data
#...

setRemote = (url,scope,filter)->
  remote =
    url: url
    dataType: 'json'
    delay: 250
    data: (params) ->
      {
        q: params.term
        page: params.page
      }
    processResults: (data, params) ->
      params.page = params.page or 1
      {
        results: parseData data, params, scope, filter
        pagination: more: params.page * 30 < data.total_count
      }
    cache: true

  remote
#...

###
# @public
###

select2 = ($filter)->
  restrict: 'A'
  scope: {
    ngModel: '='
    select2: '='
    optionId: '@'
    optionText: '@'
    optionSubText: '@'
  }
  link: (scope, element, attrs) ->
    scope.select2.id = "id" unless scope.select2.hasOwnProperty("id")
    scope.select2.text = "text" unless scope.select2.hasOwnProperty("text")

    templateResult = (item)->
      return item.text unless item.id

      item.subtitleLabel = "" unless item.hasOwnProperty('subtitleLabel')

      if item.hasOwnProperty('subtitle') && !item.hasOwnProperty('picture')
       return $("<p>#{item.text} <br> <small>#{item.subtitleLabel.toUpperCase()} #{item.subtitle}</small></p>")

      else if item.hasOwnProperty('picture') && !item.hasOwnProperty('subtitle')
       return $("<img src='#{item.picture}' class='img-circle' width='45' style='display:inline;margin:0 15px;float:left;' /><p>#{item.text}</p>")

      else if item.hasOwnProperty('picture') && item.hasOwnProperty('subtitle')
       return $("<img src='#{item.picture}' class='img-circle' width='45' style='display:inline;margin:0 15px;float:left' /> <p>#{item.text} <br> <small>#{item.subtitleLabel.toUpperCase()} #{item.subtitle}</small></p>")

      else
       return item.text

    #...

    templateSelection = (item)->
      scope.$object = item.$object
      item.text
    #...

    element.on "select2:close", ->
      scope.ngModel = scope.$object
      scope.$apply()

    options = {}

    # List Type
    if scope.select2.hasOwnProperty("remote")
      url = scope.select2.remote
      options.ajax = setRemote(url,scope.select2,$filter)
    else if scope.select2.hasOwnProperty("local")
      options.data = scope.select2.local

    options.theme = scope.select2.theme if scope.select2.hasOwnProperty("theme")
    options.language = scope.select2.language if scope.select2.hasOwnProperty("language")
    options.placeholder = attrs.placeholder if attrs.hasOwnProperty("placeholder")
    options.templateResult = templateResult
    options.templateSelection = templateSelection

    $(element).select2 options


angular.module 'angular.autocomplete', []
  .directive 'select2', select2

select2.$inject = ['$filter']
