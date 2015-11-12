CountWordsView = require './count-words-view'
{CompositeDisposable} = require 'atom'

module.exports = CountWords =
  countWordsView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @countWordsView = new CountWordsView(state.countWordsViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @countWordsView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'count-words:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @countWordsView.destroy()

  serialize: ->
    countWordsViewState: @countWordsView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor()
      words = editor.getText().split(/\s+/).length
      @countWordsView.setCount(words)
      @modalPanel.show()
 
