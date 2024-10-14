class NotesController < ApplicationController
    before_action :set_note, only: [:show, :render_html]
  
    def create
      grammar_errors = check_grammar(note_params[:content])
  
      if grammar_errors.any?
        render json: { message: 'Grammar issues found', errors: grammar_errors }, status: :unprocessable_entity
      else
        @note = current_user.notes.build(note_params)
        if @note.save
          render json: { message: 'Note saved successfully', note: @note }, status: :created
        else
          render json: @note.errors, status: :unprocessable_entity
        end
      end
    end
  
    def index
      @notes = current_user.notes
      render json: @notes
    end
  
    def show
      render json: @note
    end
  
    def render_html
      render html: markdown_to_html(@note.content).html_safe
    end
  
    def grammar_check
      content = params[:content]
      grammar_errors = check_grammar(content)
      render json: { content: content, errors: grammar_errors }
    end
  
    private
  
    def set_note
      @note = current_user.notes.find(params[:id])
    end
  
    def note_params
      params.require(:note).permit(:content, :filename)
    end
  
    def markdown_to_html(markdown_text)
      renderer = Redcarpet::Render::HTML.new
      markdown = Redcarpet::Markdown.new(renderer)
      markdown.render(markdown_text)
    end
  
    def check_grammar(content)
      response = HTTP.post("https://api.languagetool.org/v2/check", form: {
        text: content,
        language: 'en-US'
      })
  
      grammar_matches = JSON.parse(response.body.to_s)['matches']
      
      grammar_matches.map { |error| error['message'] }
    end
  end
  