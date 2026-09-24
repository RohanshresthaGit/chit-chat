import User from "../models/user.model.js";
import { hashPassword, comparePassword } from "./password.services.js";
import { generateToken } from "./jwt.services.js";

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

const loginUser = async ({email, password}) => {
    if(!email || !password) {
        throw new Error("All fields are required");
    }
    if(!email.includes("@")) {
        throw new Error("Email is not valid");
    }
    if(password.length < 6) {
        throw new Error("Password must be at least 6 characters long");
    }

    const user = await User.findOne({ email });
    if(!user) {
        throw new Error("User does not exist");
    }
    const isPasswordValid = await comparePassword(password, user.password);
    if(!isPasswordValid) {
        throw new Error("Invalid password");
    }
    const token = generateToken({
      userId:  user._id
    });
    return {
        id: user._id,
        fullName: user.fullName,
        email: user.email,
        token: token
    };


}
export default {
    registerUser,
    loginUser
}