import User from "../models/user.model.js";
import { generateToken } from "./jwt.services.js";

const getProfileById = async (userId) => {
    const user = await User.findById(userId);
    if(!user) {
        throw new Error("User not found");
    }
    return {
        id: user._id,
        fullName: user.fullName,
        email: user.email,
        profileImage: user.profileImage,
        bio: user.bio,
        links: user.links
    };
}


const updateProfile = async (userId, { fullName, email, profileImage, bio, links }) => {
    const user = await User.findById(userId);
    if(!user) {
        throw new Error("User not found");
    }
    if(fullName) {
        user.fullName = fullName;
    }
    if(email) {
        user.email = email;
    }
    if(profileImage) {
        user.profileImage = profileImage;
    }
    if(bio) {
        user.bio = bio;
    }
    if(links) {
        user.links = links;
    }

    await user.save();
    return true;
}

const deleteProfile = async (userId) => {
    const user = await User.findByIdAndDelete(userId);
    if(!user) {
        throw new Error("User not found");
    }
    return true;
}

export default {
    getProfileById,
    updateProfile,
    deleteProfile
}