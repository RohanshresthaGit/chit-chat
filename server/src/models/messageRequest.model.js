import mongoose from "mongoose";
import { MODEL } from '../constants/model.constant.js';
import { MessageRequestStatus } from "../constants/messageRequestStatus.constant.js";

const messageRequestSchema = new mongoose.Schema({
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
        enum: Object.values(MessageRequestStatus),
        default: MessageRequestStatus.PENDING
    },
    conversationId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.CONVERSATION,
        required: true
    },

    // miscellenous fields can be removed if not needed in the future
    firstMessageId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.MESSAGE,
        required: true
    },
}, {
    timestamps: true
});

const MessageRequest = mongoose.model(MODEL.MESSAGE_REQUEST, messageRequestSchema);

export default MessageRequest;