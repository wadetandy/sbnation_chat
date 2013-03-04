#= require angular-1.0.5
#= require twitter/bootstrap
#

@sbnChat = angular.module('SbnChat', [])
@sbnChat.controller('ChatCtrl', ['$scope', 'Comments', ($scope, Comments)->
    $scope.sitename  = ''
    $scope.threadId = 0
    $scope.LoadComments = ->
      Comments.forThreadId (3825819, data) ->
        $scope.comments = data
  ])
  .factory 'Comments', ['$http', ($http) ->
    getCommentId = (commentHtml) ->
      $(commentHtml).find('.pic img').attr('src')

    getCommentProfilePic = (commentHtml) ->
      $(commentHtml).find('.pic img').attr('src')

    getCommentUser = (commentHtml) ->
      $(commentHtml).find('.by a').first().html()

    getCommentSignature = (commentHtml) ->
      $(commentHtml).find('.cbody .sig p').html()

    getCommentTime = (commentHtml) ->
      new Date($(commentHtml).find('.by .time a').html())

    getCommentTitle = (commentHtml) ->
      $(commentHtml).find('.comment_title a').html()

    getCommentBody = (commentHtml) ->
      $(commentHtml).find('.cbody > p .sig').remove()
      $(commentHtml).find('.cbody').html()

    buildComments = (html) ->
      comments = []
      $(html).children('.citem').each ->
        c = $(this).children('.comment').first()

        comment =
          id: $(c).attr('id').replace('comment_inner_', '')
          user:
            username: getCommentUser(c)
            profile_pic: getCommentProfilePic(c)
            signature: getCommentSignature(c)
          title: getCommentTitle(c)
          body: getCommentBody(c)
          timestamp: getCommentTime(c)
          replies: buildComments(this)

        comments.push(comment)

      comments

    forThreadId: (threadId, callback) ->
      $http(
        method: 'GET'
        url: "http://www.sbnation.com/posts/load_comments/#{threadId}"
      ).success (data) ->
        comments = buildComments($('<div>').html(data.comments))
        callback_data =
          comments: comments
          flagged_comment_ids: data.flagged_comment_ids
          last_comment_id: data.last_comment_id
          html: data.comments

        console.log callback_data
        callback(callback_data)
  ]
