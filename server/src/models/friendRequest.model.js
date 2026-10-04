import mongoose from "mongoose";
import { MODEL } from "../constants/model.constant.js";
import { FriendRequestType } from "../constants/friendRequestType.constant.js";

const friendRequestSchema = new mongoose.Schema({
    senderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.USER,
        required: true
    },
    receiverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.USER,
        required: true
    },
    status: {
        type: String,
        enum: Object.values(FriendRequestType),
        default: FriendRequestType.PENDING
    }
}, {
    timestamps: true
});

const FriendRequest = mongoose.model(MODEL.FRIEND_REQUEST, friendRequestSchema);

export default FriendRequest;