import AppError from "./app.error.js";

class ForbiddenError extends AppError {
    constructor(message = "You are not allowed to perform this action", code = "FORBIDDEN") {
        super(message, 403, code);
    }
}
export default ForbiddenError;