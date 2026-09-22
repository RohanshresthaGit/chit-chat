import User from "../models/user.model.js";
import { hashPassword } from "./password.services.js";

const registerUser = async ({ fullName, email, password }) => {
    if(!fullName || !email || !password) {
        throw new Error("All fields are required");
    }
    if(!email.includes("@")) {
        throw new Error("Email is not valid");
    }
    if(password.length < 6) {
        throw new Error("Password must be at least 6 characters long");
    }

    const existingUser = await User.findOne({ email });
    if(existingUser) {
        throw new Error("User already exists");
    }

    const hashedPassword = await hashPassword(password);

    const user = await User.create({
        fullName,
        email,
        password: hashedPassword 
    });
    return user;
}

export default {
    registerUser
}