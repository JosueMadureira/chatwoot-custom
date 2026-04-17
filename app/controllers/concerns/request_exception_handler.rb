module RequestExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
    rescue_from CustomExceptions::Conversation::OpenConversationExists, with: :render_open_conversation_exists_error
  end

  private

  def handle_with_exception
    yield
  rescue ActiveRecord::RecordNotFound => e
    log_handled_error(e)
    render_not_found_error('Resource could not be found')
  rescue Pundit::NotAuthorizedError => e
    log_handled_error(e)
    render_unauthorized('You are not authorized to do this action')
  rescue ActionController::ParameterMissing => e
    log_handled_error(e)
    render_could_not_create_error(e.message)
  ensure
    # to address the thread variable leak issues in Puma/Thin webserver
    Current.reset
  end

  def render_unauthorized(message)
    render json: { error: message }, status: :unauthorized
  end

  def render_not_found_error(message)
    render json: { error: message }, status: :not_found
  end

  def render_could_not_create_error(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  def render_payment_required(message)
    render json: { error: message }, status: :payment_required
  end

  def render_internal_server_error(message)
    render json: { error: message }, status: :internal_server_error
  end

  def render_record_invalid(exception)
    log_handled_error(exception)
    record = exception.record
    if record.is_a?(::Conversation) && (dup_msg = conversation_open_duplicate_error_message(record))
      return render json: { error: dup_msg }, status: :unprocessable_entity
    end

    render json: {
      message: record.errors.full_messages.join(', '),
      attributes: record.errors.attribute_names
    }, status: :unprocessable_entity
  end

  def conversation_open_duplicate_error_message(record)
    record.errors[:base].find { |m| m.start_with?(::Conversation::OPEN_DUPLICATE_MESSAGE_PREFIX) }
  end

  def render_open_conversation_exists_error(exception)
    log_handled_error(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def render_error_response(exception)
    log_handled_error(exception)
    render json: exception.to_hash, status: exception.http_status
  end

  def log_handled_error(exception)
    logger.info("Handled error: #{exception.inspect}")
  end
end
