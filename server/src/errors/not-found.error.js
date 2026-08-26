import AppError from "./app.error.js";

class NotFoundError extends AppError {
constructor(message = "Resource not found", code = "NOT_FOUND") {
    super(message, 404, code);
  }
}

export default NotFoundError;