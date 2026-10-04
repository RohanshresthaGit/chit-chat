import mongoose from "mongoose";
import { MODEL } from "../constants/model.constant.js";

const conversationMemberSchema = new mongoose.Schema({
    conversationId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.CONVERSATION,
        required: true
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.USER,
        required: true
    },
    joinedAt: {
        type: Date,
        default: Date.now
    },
    lastMessageReadId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: MODEL.MESSAGE,
        default: null
    },
    lastMessageReadAt: {
        type: Date,
        default: null
    },

    // Additional fields for conversation member which might be useful in the future
    isMuted: {
        type: Boolean,
        default: false
    },
    isPinned: {
        type: Boolean,
        default: false
    },
    role: {
        type: String,
        enum: ["admin", "member"],
        default: "member"
    }
}, {
    timestamps: true
})

const ConversationMember = mongoose.model(MODEL.CONVERSATION_MEMBER, conversationMemberSchema);

export default ConversationMember;