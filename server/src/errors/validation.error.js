import AppError from "./app.error.js";

class ValidationError extends AppError {
    constructor(message = "Validation failed", code = "VALIDATION_ERROR") {
        super(message, 422, code);
    }
}
export default ValidationError;