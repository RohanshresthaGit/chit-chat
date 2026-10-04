import mongoose from "mongoose";
import { MODEL } from "../constants/model.constant.js";
import { MessageStatus } from "../constants/messageStatus.constant.js";

const messageSchema = new mongoose.Schema({
    conversationId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.CONVERSATION,
        required: true
    },
    senderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.USER,
        required: true
    },
    content: {
        type: String,
        required: true
    },
    type: {
        type: String,
        enum: Object.values(MessageType),
        default: MessageType.TEXT
    },
    status: {
        type: String,
        enum: Object.values(MessageStatus),
        default: MessageStatus.SENT
    },
    readBy: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.USER
    }]
}, { timestamps: true });

const Message = mongoose.model(MODEL.MESSAGE, messageSchema);

export default Message;