import mongoose from "mongoose";
import { MODEL } from '../constants/model.constant.js';
import { CONVERSATION_TYPE } from "../constants/conversationType.constant.js";


const conversationSchema = new mongoose.Schema({
    type: {
        type: String,
        enum: Object.values(CONVERSATION_TYPE),
        required: true
    },
    lastMessageId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.MESSAGE,
    },
    lastMessageAt: {
        type: Date,
        default: null
    },
}, { timestamps: true });

const Conversation = mongoose.model(MODEL.CONVERSATION, conversationSchema);

export default Conversation;