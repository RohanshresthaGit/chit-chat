import AppError from "./app.error.js";

class BadRequestError extends AppError {
    constructor(message = "Bad request", code = "BAD_REQUEST") {
        super(message, 400, code);
    }
}

export default BadRequestError;