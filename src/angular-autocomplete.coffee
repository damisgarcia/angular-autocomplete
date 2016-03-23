'use strict'

###*
 # @ngdoc directive
 # @name angular-autocomplete
 # @description
 #
###

###
#
# @private
#
###

parseData = (result,params,scope,filter)->
  filterResult = []

  if result instanceof Array
    filterResult = filter('filter')(result, params.term)
  else if result.hasOwnProperty("data")
    filterResult = filter('filter')(result.data, params.term)

  data = $.map filterResult, (item)->
    response =
      id: item[scope.id]
      text: item[scope.text]
      $object: item
    #
    response.subtitle = item[scope.subtitle] if scope.hasOwnProperty("subtitle")
    response.picture = item[scope.picture] if scope.hasOwnProperty("picture")
    response
  #...
  return data
#...

setRemote = (url,scope,filter)->
  remote =
    url: url
    dataType: scope.dataType
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

autocomplete = ($filter)->
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
      scope.item = item

      return item.text unless item.id

      if item.hasOwnProperty('subtitle') && !item.hasOwnProperty('picture')
       return $("<p>#{item.text} <br> <small>#{item.subtitle.join(',')}</small></p>")

      else if item.hasOwnProperty('picture') && !item.hasOwnProperty('subtitle')
       return $("<img src='#{item.picture}' class='img-circle' width='45' style='display:inline;margin:0 15px;float:left;' /><p>#{item.text}</p>")

      else if item.hasOwnProperty('picture') && item.hasOwnProperty('subtitle')
       return $("<img src='#{item.picture}' class='img-circle' width='45' style='display:inline;margin:0 15px;float:left' /> <p>#{item.text} <br> <small>#{item.subtitle}</small></p>")

      else
       return item.text

    #...

    element.on "select2:select", (response)->
      console.log response
      scope.ngModel = angular.copy(response.params.data.$object)
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
    options.dataType = scope.select2.dataType if scope.select2.hasOwnProperty("dataType")
    options.minimumInputLength = scope.select2.minimumInputLength if scope.select2.hasOwnProperty("minimumInputLength")
    options.placeholder = attrs.placeholder if attrs.hasOwnProperty("placeholder")
    options.templateResult = templateResult

    $(element).select2 options




angular.module 'angular.autocomplete', []
  .directive('autocomplete', autocomplete)

select2.$inject = ['$filter']

# .directive('select2Options', select2_options)

# select2_options = ->
#   restrict: 'A'
#   require: '^select2'
#   scope:
#     value: '='
#   link: (scope, element, attrs,ctrls) ->
#     element.bind 'change', ->
#       select2.ngModel = scope.value


# select2Ctrl.$inject = ["$scope"]
