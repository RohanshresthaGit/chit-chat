import AppError from "./app.error.js";

class ConflictError extends AppError {
    constructor(message = "Conflict occurred", code = "CONFLICT") {
        super(message, 409, code);
    }
}

export default ConflictError;