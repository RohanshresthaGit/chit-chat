import AppError from "./app.error.js";

class UnauthorizedError extends AppError {
    constructor(message = "Unauthorized access", code = "UNAUTHORIZED") {
        super(message, 401, code);
    }
}

export default UnauthorizedError;